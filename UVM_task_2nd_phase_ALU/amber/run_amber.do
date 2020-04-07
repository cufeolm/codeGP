if [file exists "work"] {vdel -all}
vlib work
onerror {quit}

vlog -f amber/dut_amber.f 
vlog +incdir+amber+GUVM amber/target_pkg.sv
vlog amber/amber_interface.sv
vlog amber/top.sv

vsim top

run -all
log /* -r
quit
