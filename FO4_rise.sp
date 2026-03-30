* FO4_rise.sp

* include the MOSFET models with TT proccess 
.lib '~/.ciel/sky130A/libs.tech/ngspice/sky130.lib.spice' tt

* include the standard cell library
.include '~/.ciel/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice'

* our supplies are global to the hierarchy
*.global vdd gnd
.param supply_voltage=1.8V

* set the operating temperature
.option temp=25

* include the circuit to be simulated
Xinv A gnd gnd vdd vdd Z sky130_fd_sc_hd__inv_2

* fanout 4 capacitive load on inverter output
Xinv1 Z gnd gnd vdd vdd Z1 sky130_fd_sc_hd__inv_2
Xinv2 Z gnd gnd vdd vdd Z2 sky130_fd_sc_hd__inv_2
Xinv3 Z gnd gnd vdd vdd Z3 sky130_fd_sc_hd__inv_2
Xinv4 Z gnd gnd vdd vdd Z4 sky130_fd_sc_hd__inv_2

* define the supply voltages
VDD vdd 0 supply_voltage

* create a voltage pulse on the input
VSW A 0 PULSE (0 supply_voltage 500p {0.122474n/0.8} {0.122474n/0.8} 1n 2n) 

* perform a 3ns transient analysis
.tran 1ps 3ns

.param half_supply = '0.5*supply_voltage'
.param slew_low     = '0.1*supply_voltage'
.param slew_high    = '0.9*supply_voltage'

* measure the input rise to output fall delay 
* uses a calculation to compute half of 50% of the supply voltage
.meas tran rise_delay trig v(A) val=half_supply fall=1 targ v(Z) val=half_supply rise=1
.meas tran in_rise_slew trig v(A) val=slew_low  rise=1 targ v(A) val=slew_high rise=1

*.control
*run
*quit
*.endc

.END

