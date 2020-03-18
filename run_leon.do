if [file exists "work"] {vdel -all}
vlib work
vlog DUT_LEON.f 

vlog GUVM_tb.f 
#vlog GUVM_testbench_pkg.sv 
#vlog top.sv
vsim top 
run -all
quit
