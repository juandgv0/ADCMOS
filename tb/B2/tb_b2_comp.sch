v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
C {B2_comp/b2_comp_sa.sym} 0 0 0 0 {name=X_DUT}
C {devices/lab_pin.sym} 150 -40 0 0 {name=l1 sig_type=std_logic lab=CMP}
C {devices/lab_pin.sym} -150 -40 0 1 {name=l2 sig_type=std_logic lab=VTOP}
C {devices/lab_pin.sym} -150 -20 0 1 {name=l3 sig_type=std_logic lab=CLK_CMP}
C {devices/lab_pin.sym} -150 0 0 1 {name=l4 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} -150 20 0 1 {name=l5 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} -150 40 0 1 {name=l6 sig_type=std_logic lab=VCM}
C {devices/vsource.sym} -300 220 0 0 {name=Vdd value="1.8" savecurrent=false}
C {devices/lab_pin.sym} -300 190 0 0 {name=l7 sig_type=std_logic lab=VDD}
C {devices/gnd.sym} -300 250 0 0 {name=g_Vdd lab=GND}
C {devices/vsource.sym} -200 220 0 0 {name=Vss value="0" savecurrent=false}
C {devices/lab_pin.sym} -200 190 0 0 {name=l8 sig_type=std_logic lab=VSS}
C {devices/gnd.sym} -200 250 0 0 {name=g_Vss lab=GND}
C {devices/vsource.sym} -100 220 0 0 {name=Vvcm value="0.6" savecurrent=false}
C {devices/lab_pin.sym} -100 190 0 0 {name=l9 sig_type=std_logic lab=VCM}
C {devices/gnd.sym} -100 250 0 0 {name=g_Vvcm lab=GND}
C {devices/vsource.sym} 0 220 0 0 {name=Vclk value="PULSE(1.8 0 50n 200p 200p 49.8n 100n)" savecurrent=false}
C {devices/lab_pin.sym} 0 190 0 0 {name=l10 sig_type=std_logic lab=CLK_CMP}
C {devices/gnd.sym} 0 250 0 0 {name=g_Vclk lab=GND}
C {devices/vsource.sym} 100 220 0 0 {name=Vtop value="PWL(0 0.60234 95n 0.60234 96n 0.59766 195n 0.59766 196n 0.60234 300n 0.60234)" savecurrent=false}
C {devices/lab_pin.sym} 100 190 0 0 {name=l11 sig_type=std_logic lab=VTOP_SRC}
C {devices/gnd.sym} 100 250 0 0 {name=g_Vtop lab=GND}
C {devices/res.sym} 200 220 0 0 {name=Riso value=100 footprint=1206 device=resistor m=1}
C {devices/lab_pin.sym} 200 190 0 0 {name=l12 sig_type=std_logic lab=VTOP_SRC}
C {devices/lab_pin.sym} 200 250 0 0 {name=l13 sig_type=std_logic lab=VTOP}
C {devices/capa.sym} 300 220 0 0 {name=Ccdac value=5.12p m=1}
C {devices/lab_pin.sym} 300 190 0 0 {name=l14 sig_type=std_logic lab=VTOP}
C {devices/gnd.sym} 300 250 0 0 {name=g_cdac lab=GND}
C {devices/capa.sym} 400 220 0 0 {name=Cload value=20f m=1}
C {devices/lab_pin.sym} 400 190 0 0 {name=l15 sig_type=std_logic lab=CMP}
C {devices/gnd.sym} 400 250 0 0 {name=g_load lab=GND}
C {devices/code_shown.sym} 240 -120 0 0 {name=NGSPICE only_toplevel=false value=".lib /home/juan/.volare/sky130A/libs.tech/ngspice/sky130.lib.spice tt
.include /home/juan/.volare/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice
.temp 25

.control
  * 1. Punto de operacion (.op) en estado de precarga/reset (CLK_CMP = 1.8 V)
  op
  print i(Vdd) v(X_DUT.DI_P) v(X_DUT.DI_N) v(X_DUT.OUT_P) v(X_DUT.OUT_N)

  * 2. Simulacion transitoria (.tran)
  tran 20p 300n

  * Tiempo de decision en subida (Ciclo 2: VTOP = 0.59766 V < VCM)
  meas tran t_clk_r WHEN v(clk_cmp)=0.9 FALL=2
  meas tran t_cmp_r WHEN v(cmp)=0.9 RISE=1 TD=149n
  let t_dec_rise = t_cmp_r - t_clk_r
  print t_dec_rise

  * Tiempo de decision en bajada (Ciclo 3: VTOP = 0.60234 V > VCM)
  meas tran t_clk_f WHEN v(clk_cmp)=0.9 FALL=3
  meas tran t_cmp_f WHEN v(cmp)=0.9 FALL=1 TD=249n
  let t_dec_fall = t_cmp_f - t_clk_f
  print t_dec_fall

  * Energia total consumida por ciclo de decision (145 ns a 245 ns)
  let p_vdd = -v(vdd)*i(vdd)
  meas tran e_dec INTEG p_vdd FROM=145n TO=245n
  print e_dec

  * Ruido de kickback pico a pico en VTOP durante el disparo (49 ns a 65 ns)
  meas tran vtop_max MAX v(vtop) FROM=49n TO=65n
  meas tran vtop_min MIN v(vtop) FROM=49n TO=65n
  let kickback_pp = vtop_max - vtop_min
  print kickback_pp

  plot v(clk_cmp) v(cmp)+2
  plot v(vtop)
.endc"}
