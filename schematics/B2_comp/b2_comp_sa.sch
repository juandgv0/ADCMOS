v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -260 -120 -240 -120 {lab=VTOP}
N -260 -80 -240 -80 {lab=CLK_CMP}
N -260 -40 -240 -40 {lab=VDD}
N -260 -10 -240 -10 {lab=VSS}
N -260 30 -240 30 {lab=VCM}
N 520 -140 540 -140 {lab=CMP}
N -160 -185 -160 -170 {lab=TAIL}
N -215 -140 -200 -140 {lab=CLK_INT}
N -160 -110 -160 -95 {lab=VSS}
N -160 -140 -145 -140 {lab=VSS}
N -10 -185 -10 -170 {lab=DI_P}
N -65 -140 -50 -140 {lab=VTOP}
N -10 -110 -10 -95 {lab=TAIL}
N -10 -140 5 -140 {lab=VSS}
N 120 -185 120 -170 {lab=DI_N}
N 65 -140 80 -140 {lab=VCM}
N 120 -110 120 -95 {lab=TAIL}
N 120 -140 135 -140 {lab=VSS}
N 270 -185 270 -170 {lab=OUT_P}
N 215 -140 230 -140 {lab=OUT_N}
N 270 -110 270 -95 {lab=DI_P}
N 270 -140 285 -140 {lab=VSS}
N 390 -195 390 -180 {lab=OUT_N}
N 335 -150 350 -150 {lab=OUT_P}
N 390 -120 390 -105 {lab=DI_N}
N 390 -150 405 -150 {lab=VSS}
N -160 -85 -160 -70 {lab=VDD}
N -215 -40 -200 -40 {lab=OUT_N}
N -160 -10 -160 5 {lab=OUT_P}
N -160 -40 -145 -40 {lab=VDD}
N -30 -85 -30 -70 {lab=VDD}
N -85 -40 -70 -40 {lab=OUT_P}
N -30 -10 -30 5 {lab=OUT_N}
N -30 -40 -15 -40 {lab=VDD}
N 100 -85 100 -70 {lab=VDD}
N 45 -40 60 -40 {lab=CLK_INT}
N 100 -10 100 5 {lab=DI_P}
N 100 -40 115 -40 {lab=VDD}
N 220 -95 220 -80 {lab=VDD}
N 165 -50 180 -50 {lab=CLK_INT}
N 220 -20 220 -5 {lab=DI_N}
N 220 -50 235 -50 {lab=VDD}
N 350 -95 350 -80 {lab=VDD}
N 295 -50 310 -50 {lab=CLK_INT}
N 350 -20 350 -5 {lab=OUT_P}
N 350 -50 365 -50 {lab=VDD}
N 490 -85 490 -70 {lab=VDD}
N 435 -40 450 -40 {lab=CLK_INT}
N 490 -10 490 5 {lab=OUT_N}
N 490 -40 505 -40 {lab=VDD}
N -160 50 -140 50 {lab=OUT_N}
N -160 90 -140 90 {lab=CMP_B}
N -40 70 -20 70 {lab=CMP}
N 10 50 30 50 {lab=OUT_P}
N 10 90 30 90 {lab=CMP}
N 130 70 150 70 {lab=CMP_B}
N -310 120 -290 120 {lab=CLK_CMP}
N -230 120 -210 120 {lab=CLK_INT}
C {devices/ipin.sym} -260 -120 0 0 {name=p1 lab=VTOP}
C {devices/ipin.sym} -260 30 2 1 {name=p2 lab=VCM}
C {devices/ipin.sym} -260 -80 2 1 {name=p3 lab=CLK_CMP}
C {devices/ipin.sym} -260 -40 2 1 {name=p4 lab=VDD}
C {devices/ipin.sym} -260 -10 2 1 {name=p5 lab=VSS}
C {devices/opin.sym} 540 -140 0 0 {name=p6 lab=CMP}
C {devices/lab_pin.sym} -240 -120 0 0 {name=l1 sig_type=std_logic lab=VTOP}
C {devices/lab_pin.sym} -240 -80 0 0 {name=l2 sig_type=std_logic lab=CLK_CMP}
C {devices/lab_pin.sym} -240 -40 0 0 {name=l3 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} -240 -10 0 0 {name=l4 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} -240 30 0 0 {name=l5 sig_type=std_logic lab=VCM}
C {devices/lab_pin.sym} 520 -140 0 1 {name=l6 sig_type=std_logic lab=CMP}
C {devices/lab_pin.sym} -160 -185 0 0 {name=l7 sig_type=std_logic lab=TAIL}
C {devices/lab_pin.sym} -215 -140 0 1 {name=l8 sig_type=std_logic lab=CLK_INT}
C {devices/lab_pin.sym} -160 -95 0 0 {name=l9 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} -145 -140 0 0 {name=l10 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} -10 -185 0 0 {name=l11 sig_type=std_logic lab=DI_P}
C {devices/lab_pin.sym} -65 -140 0 1 {name=l12 sig_type=std_logic lab=VTOP}
C {devices/lab_pin.sym} -10 -95 0 0 {name=l13 sig_type=std_logic lab=TAIL}
C {devices/lab_pin.sym} 5 -140 0 0 {name=l14 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 120 -185 0 0 {name=l15 sig_type=std_logic lab=DI_N}
C {devices/lab_pin.sym} 65 -140 0 1 {name=l16 sig_type=std_logic lab=VCM}
C {devices/lab_pin.sym} 120 -95 0 0 {name=l17 sig_type=std_logic lab=TAIL}
C {devices/lab_pin.sym} 135 -140 0 0 {name=l18 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 270 -185 0 0 {name=l19 sig_type=std_logic lab=OUT_P}
C {devices/lab_pin.sym} 215 -140 0 1 {name=l20 sig_type=std_logic lab=OUT_N}
C {devices/lab_pin.sym} 270 -95 0 0 {name=l21 sig_type=std_logic lab=DI_P}
C {devices/lab_pin.sym} 285 -140 0 0 {name=l22 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} 390 -195 0 0 {name=l23 sig_type=std_logic lab=OUT_N}
C {devices/lab_pin.sym} 335 -150 0 1 {name=l24 sig_type=std_logic lab=OUT_P}
C {devices/lab_pin.sym} 390 -105 0 0 {name=l25 sig_type=std_logic lab=DI_N}
C {devices/lab_pin.sym} 405 -150 0 0 {name=l26 sig_type=std_logic lab=VSS}
C {devices/lab_pin.sym} -160 -85 0 0 {name=l27 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} -215 -40 0 1 {name=l28 sig_type=std_logic lab=OUT_N}
C {devices/lab_pin.sym} -160 5 0 0 {name=l29 sig_type=std_logic lab=OUT_P}
C {devices/lab_pin.sym} -145 -40 0 0 {name=l30 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} -30 -85 0 0 {name=l31 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} -85 -40 0 1 {name=l32 sig_type=std_logic lab=OUT_P}
C {devices/lab_pin.sym} -30 5 0 0 {name=l33 sig_type=std_logic lab=OUT_N}
C {devices/lab_pin.sym} -15 -40 0 0 {name=l34 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} 100 -85 0 0 {name=l35 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} 45 -40 0 1 {name=l36 sig_type=std_logic lab=CLK_INT}
C {devices/lab_pin.sym} 100 5 0 0 {name=l37 sig_type=std_logic lab=DI_P}
C {devices/lab_pin.sym} 115 -40 0 0 {name=l38 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} 220 -95 0 0 {name=l39 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} 165 -50 0 1 {name=l40 sig_type=std_logic lab=CLK_INT}
C {devices/lab_pin.sym} 220 -5 0 0 {name=l41 sig_type=std_logic lab=DI_N}
C {devices/lab_pin.sym} 235 -50 0 0 {name=l42 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} 350 -95 0 0 {name=l43 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} 295 -50 0 1 {name=l44 sig_type=std_logic lab=CLK_INT}
C {devices/lab_pin.sym} 350 -5 0 0 {name=l45 sig_type=std_logic lab=OUT_P}
C {devices/lab_pin.sym} 365 -50 0 0 {name=l46 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} 490 -85 0 0 {name=l47 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} 435 -40 0 1 {name=l48 sig_type=std_logic lab=CLK_INT}
C {devices/lab_pin.sym} 490 5 0 0 {name=l49 sig_type=std_logic lab=OUT_N}
C {devices/lab_pin.sym} 505 -40 0 0 {name=l50 sig_type=std_logic lab=VDD}
C {devices/lab_pin.sym} -160 50 0 1 {name=l51 sig_type=std_logic lab=OUT_N}
C {devices/lab_pin.sym} -160 90 0 1 {name=l52 sig_type=std_logic lab=CMP_B}
C {devices/lab_pin.sym} -20 70 0 0 {name=l53 sig_type=std_logic lab=CMP}
C {devices/lab_pin.sym} 10 50 0 1 {name=l54 sig_type=std_logic lab=OUT_P}
C {devices/lab_pin.sym} 10 90 0 1 {name=l55 sig_type=std_logic lab=CMP}
C {devices/lab_pin.sym} 150 70 0 0 {name=l56 sig_type=std_logic lab=CMP_B}
C {devices/lab_pin.sym} -310 120 0 1 {name=l57 sig_type=std_logic lab=CLK_CMP}
C {devices/lab_pin.sym} -210 120 0 0 {name=l58 sig_type=std_logic lab=CLK_INT}
C {sky130_fd_pr/nfet_01v8.sym} -180 -140 0 0 {name=MTAIL
W=1
L=0.35
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8_lvt.sym} -30 -140 0 0 {name=M1
W=2.5
L=0.5
nf=1
mult=6
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 100 -140 0 0 {name=M2
W=2.5
L=0.5
nf=1
mult=6
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 250 -140 0 0 {name=M3
W=1
L=0.15
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 370 -150 0 0 {name=M4
W=1
L=0.15
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} -180 -40 0 0 {name=M5
W=1
L=0.15
nf=1
mult=2
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} -50 -40 0 0 {name=M6
W=1
L=0.15
nf=1
mult=2
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 80 -40 0 0 {name=M7
W=0.5
L=0.15
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 200 -50 0 0 {name=M8
W=0.5
L=0.15
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 330 -50 0 0 {name=M9
W=1
L=0.15
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 470 -40 0 0 {name=M10
W=1
L=0.15
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_stdcells/nand2_1.sym} -90 70 0 0 {name=x1 VGND=VSS VNB=VSS VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/nand2_1.sym} 80 70 0 0 {name=x2 VGND=VSS VNB=VSS VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/inv_2.sym} -260 120 0 0 {name=x3 VGND=VSS VNB=VSS VPB=VDD VPWR=VDD prefix=sky130_fd_sc_hd__ }
