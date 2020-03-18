if [file exists "work"] {vdel -all}
vlib work
vlog DUT.f 
vlog GUVM_testbench_pkg.sv 
vlog top.sv
vsim top 
run -all
quit
