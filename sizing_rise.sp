* sizing_rise

.lib '~/.ciel/sky130A/libs.tech/ngspice/sky130.lib.spice' tt
*.include '~/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice'

.param supply_voltage=1.8V
.option temp=25

.subckt sky130_fd_sc_hd__inv_2 A VGND VNB VPB VPWR Y
X0 Y    A VGND VNB sky130_fd_pr__nfet_01v8     w=650000u   l=150000u
X1 VPWR A Y    VPB sky130_fd_pr__pfet_01v8_hvt w=3.57e+06u l=150000u
X2 VGND A Y    VNB sky130_fd_pr__nfet_01v8     w=650000u   l=150000u
X3 Y    A VPWR VPB sky130_fd_pr__pfet_01v8_hvt w=3.57e+06u l=150000u
.ends

Xinv  A gnd gnd vdd vdd Z  sky130_fd_sc_hd__inv_2
Xinv1 Z gnd gnd vdd vdd Z1 sky130_fd_sc_hd__inv_2
Xinv2 Z gnd gnd vdd vdd Z2 sky130_fd_sc_hd__inv_2
Xinv3 Z gnd gnd vdd vdd Z3 sky130_fd_sc_hd__inv_2
Xinv4 Z gnd gnd vdd vdd Z4 sky130_fd_sc_hd__inv_2

VDD vdd 0 supply_voltage

VSW A 0 PULSE (0V supply_voltage 500ps 0.122474n 0.122474n 1000ps 2000ps) DC 0V

.tran 1ps 3ns

.param half_supply = '0.5*supply_voltage'
.meas tran fall_delay trig v(A) val=half_supply rise=1 targ v(Z) val=half_supply fall=1
.meas tran rise_delay trig v(A) val=half_supply fall=1 targ v(Z) val=half_supply rise=1

*.control 
*run 
*quit 
*.endc

.END

