#!/usr/bin/env python3
import os, re, subprocess

PROJ_DIR = os.path.expanduser("~/proyecto_sky130")
SIM_DIR  = os.path.expanduser("~/.xschem/simulations")
OUT_TXT  = os.path.join(PROJ_DIR, "tb/B2/results_pvt_b2.txt")

# 1. Regenerar netlist actualizado desde Xschem
subprocess.run(
    ["xschem", "-n", "-q", "-o", SIM_DIR, "tb/B2/tb_b2_comp.sch"],
    cwd=PROJ_DIR,
    check=True
)

base_netlist = open(os.path.join(SIM_DIR, "tb_b2_comp.spice")).read()

corners = [
    ("Nominal (typ)",   "tt", 1.80,  25),
    ("LV-cold (lenta)", "ss", 1.62, -45),
    ("HV-hot (rapida)", "ff", 1.95,  90),
    ("HV-cold (kick)",  "ff", 1.95, -45),
]

header = f"{'Esquina':<18} | {'Proc':<4} | {'VDD':<5} | {'Temp':<6} | {'t_rise(ns)':<10} | {'t_fall(ns)':<10} | {'E_dec(pJ)':<9} | {'Kick(mV)':<8}"
sep = "-" * len(header)
report_lines = [header, sep]

for label, proc, vdd, temp in corners:
    vmid = vdd / 2.0
    net = base_netlist
    net = net.replace("sky130.lib.spice tt", f"sky130.lib.spice {proc}")
    net = net.replace(".temp 25", f".temp {temp}")
    net = re.sub(r'^(Vdd\s+\S+\s+\S+\s+)1\.8\b', rf'\g<1>{vdd}', net, flags=re.M)
    net = re.sub(r'PULSE\s*\(\s*1\.8\b', f'PULSE({vdd}', net)
    net = net.replace("=0.9 ", f"={vmid} ")
    net = re.sub(r'^\s*plot\s+.*$', '', net, flags=re.M)

    tmp_file = f"/tmp/tb_b2_{proc}_{temp}.spice"
    open(tmp_file, "w").write(net)
    out = subprocess.check_output(["ngspice", "-b", tmp_file], text=True, stderr=subprocess.STDOUT)

    def get_val(name):
        m = re.search(rf'^{name}\s*=\s*([0-9eE.+\-]+)', out, re.M)
        return float(m.group(1)) if m else float('nan')

    tr = get_val("t_dec_rise") * 1e9
    tf = get_val("t_dec_fall") * 1e9
    ed = get_val("e_dec") * 1e12
    kb = get_val("kickback_pp") * 1e3
    report_lines.append(
        f"{label:<18} | {proc:<4} | {vdd:<5.2f} | {temp:>4}°C | {tr:<10.2f} | {tf:<10.2f} | {ed:<9.3f} | {kb:<8.2f}"
    )

report = "\n".join(report_lines)
print("\n" + report + "\n")
with open(OUT_TXT, "w") as f:
    f.write(report + "\n")
print(f"Resultados guardados en: {OUT_TXT}")
