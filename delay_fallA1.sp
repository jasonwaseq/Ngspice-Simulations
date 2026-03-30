* delay_fallA1

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
Xinv A1 A2 B1 gnd gnd vdd vdd Y sky130_fd_sc_hd__a21oi_2

* define the supply voltages
VDD vdd 0 supply_voltage

VA2 A2 0 supply_voltage
VB1 B1 0 0

* create a voltage pulse on the input
VA1 A1 0 PULSE (0 supply_voltage 500ps {0.122474n/0.8} {0.122474n/0.8} 1000p 2000ps)

* perform a 3ns transient analysis
.tran 1ps 3ns

.param half_supply = '0.5*supply_voltage'
.param slew_low     = '0.1*supply_voltage'
.param slew_high    = '0.9*supply_voltage'

* measure the input rise to output fall delay
* uses a calculation to compute half of 50% of the supply voltage
.meas tran fall_delay trig v(A1) val=half_supply rise=1 targ v(Y) val=half_supply fall=1
.meas tran in_rise_slew trig v(A1) val=slew_low  rise=1 targ v(A1) val=slew_high rise=1

*.control
*run
*quit
*.endc

.END
