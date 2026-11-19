#!/usr/bin/env python3
import os
import re
import time
import math
import subprocess
from concurrent.futures import ProcessPoolExecutor, as_completed

PROJ_DIR    = os.path.expanduser("~/proyecto_sky130")
SIM_DIR     = os.path.expanduser("~/.xschem/simulations")
TB_SCH      = os.path.join(PROJ_DIR, "tb/B2/tb_b2_comp.sch")
BASE_NET    = os.path.join(SIM_DIR, "tb_b2_comp.spice")
OUT_TXT     = os.path.join(PROJ_DIR, "tb/B2/results_mc_b2.txt")

N_RUNS      = 50
MAX_WORKERS = 8
VCM_NOM     = 0.600
RAMP_START  = 0.6080   # VCM + 8.0 mV (inicializa CMP=0 en t=50 ns)
RAMP_END    = 0.5920   # VCM - 8.0 mV (0.5 mV por ciclo de 100 ns)
T_SIM       = "3200n"


def extract_netlist():
    os.makedirs(SIM_DIR, exist_ok=True)
    subprocess.run(
        ["xschem", "-n", "-q", "-o", SIM_DIR, TB_SCH],
        cwd=PROJ_DIR,
        check=True,
    )


def prepare_mc_netlist(base_txt: str, run_idx: int) -> str:
    # 1. Usar modelos combinados en esquina estadistica tt_mm a 25 C
    net = re.sub(
        r'(\.lib\s+\S+/libs\.tech/)(?:ngspice|combined)(/sky130\.lib\.spice)\s+\S+',
        r'\1combined\2 tt_mm',
        base_txt,
    )
    if "mc_mm_switch" not in net:
        net = ".param mc_mm_switch=1\n" + net

    net = re.sub(r'^\.temp\s+\S+', '.temp 25', net, flags=re.M)

    # 2. Reemplazar Vtop VTOP_SRC GND PWL(...) por rampa descendente [+8 mV -> -8 mV]
    ramp_pwl = f"PWL(0 {RAMP_START:.4f} {T_SIM} {RAMP_END:.4f})"
    net, n_sub = re.subn(
        r'^(Vtop\s+VTOP_SRC\s+GND\s+)PWL\([^)]*\)',
        rf'\g<1>{ramp_pwl}',
        net,
        flags=re.M | re.I,
    )
    if n_sub == 0:
        raise RuntimeError("No se encontro la fuente 'Vtop VTOP_SRC GND PWL(...)' en el netlist.")

    # 3. Bloque .control en un solo hilo midiendo el disparo tras el ciclo inicial (TD=100n)
    ctrl_block = f""".control
  set num_threads=1
  set seed={1000 + run_idx}
  tran 250p {T_SIM}
  meas tran t_trip WHEN v(cmp)=0.9 RISE=1 TD=100n
  meas tran v_trip FIND v(vtop) AT=t_trip
  let vos_val = v_trip - {VCM_NOM}
  print vos_val
  quit
.endc"""

    net = re.sub(r'\.control[\s\S]*?\.endc', ctrl_block, net, flags=re.I)
    return net


def run_single(run_idx: int):
    tmp_sp = f"/tmp/mc_b2_{os.getpid()}_{run_idx}.spice"
    env = os.environ.copy()
    env["OMP_NUM_THREADS"] = "1"
    try:
        net_txt = prepare_mc_netlist(BASE_TXT, run_idx)
        with open(tmp_sp, "w") as f:
            f.write(net_txt)
        out = subprocess.check_output(
            ["ngspice", "-b", tmp_sp],
            stderr=subprocess.STDOUT,
            text=True,
            env=env,
        )
        m = re.search(r'vos_val\s*=\s*([+\-0-9.eE]+)', out)
        if not m:
            return run_idx, None
        return run_idx, float(m.group(1)) * 1e3  # mV
    finally:
        if os.path.exists(tmp_sp):
            os.remove(tmp_sp)


if __name__ == "__main__":
    extract_netlist()
    with open(BASE_NET) as f:
        BASE_TXT = f.read()

    t0 = time.time()
    _, vos0 = run_single(0)
    dt = time.time() - t0
    if vos0 is None:
        raise RuntimeError("Fallo la medicion de Vos[0] en el testbench.")
    print(f"\nPrueba individual completada en {dt:.1f} s (Vos[0] = {vos0:+.3f} mV)", flush=True)

    results = {0: vos0}
    print(f"Ejecutando {N_RUNS} simulaciones Monte Carlo en {MAX_WORKERS} nucleos...", flush=True)

    completed = 1
    with ProcessPoolExecutor(max_workers=MAX_WORKERS) as ex:
        futures = {ex.submit(run_single, i): i for i in range(1, N_RUNS)}
        for fut in as_completed(futures):
            idx, val = fut.result()
            if val is not None:
                results[idx] = val
            completed += 1
            if completed % 5 == 0 or completed == N_RUNS:
                print(f"  Progreso: {completed}/{N_RUNS} completadas...", flush=True)

    vals = [results[i] for i in sorted(results)]
    n_ok = len(vals)
    mu = sum(vals) / n_ok
    sigma = math.sqrt(sum((x - mu) ** 2 for x in vals) / (n_ok - 1)) if n_ok > 1 else 0.0
    v_min, v_max = min(vals), max(vals)

    summary = (
        f"\nResultados Monte Carlo B2 (tt_mm, 25°C, N={n_ok}/{N_RUNS})\n"
        f"----------------------------------------------------\n"
        f"Media (mu_os)    : {mu:+.3f} mV\n"
        f"Sigma (sigma_os) : {sigma:.3f} mV  (Meta: <= 1.000 mV)\n"
        f"3*sigma          : {3 * sigma:.3f} mV  (0.5 LSB = 2.344 mV)\n"
        f"Rango [min, max] : [{v_min:+.2f} mV, {v_max:+.2f} mV]\n"
    )
    print(summary)

    os.makedirs(os.path.dirname(OUT_TXT), exist_ok=True)
    with open(OUT_TXT, "w") as f:
        f.write(summary.strip() + "\n\nCorridas individuales (mV):\n")
        for i in sorted(results):
            f.write(f"run_{i:02d}: {results[i]:+.4f} mV\n")

    print(f"Guardado en: {OUT_TXT}")
