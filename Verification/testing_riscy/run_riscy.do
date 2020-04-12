
if [file exists "work"] {vdel -all}
vlib work
onerror {quit}


vlog -f ../testing_riscy/DUT_riscy.f 

vlog +incdir+../testing_riscy+../common+../common/inst_h ../testing_riscy/target_pkg.sv 
vlog ../testing_riscy/riscy_interface.sv
vlog ../testing_riscy/top.sv

vsim top


run -all
log /* -r
quit
