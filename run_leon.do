if [file exists "work"] {vdel -all}
vlib work
vcom -f DUT_LEON.f 

vlog -f GUVM_tb.f 
#vlog GUVM_testbench_pkg.sv 
#vlog top.sv
vsim top 
run -all
quit
