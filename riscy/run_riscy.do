if [file exists "work"] {vdel -all}
vlib work
onerror {quit}

puts "Hello, World; - With  a semicolon inside the quotes"

vlog -f riscy/dut_riscy.f

vlog +incdir+riscy+GUVM riscy/target_pkg.sv 
vlog riscy/riscy_interface.sv
vlog riscy/top.sv

vsim top

add wave -position insertpoint sim:/top/dut/id_stage_i/registers_i/riscv_register_file_i/mem
add wave -position insertpoint sim:/top/bfm/send_inst/*
add wave -position insertpoint sim:/top/bfm/send_data/*
add wave -position insertpoint sim:/top/bfm/load/*
add wave -position insertpoint sim:/top/bfm/store/*
add wave -position insertpoint sim:/top/bfm/receive_data/*
add wave -r /*
add wave -position insertpoint sim:/top/dut/id_stage_i/registers_i/riscv_register_file_i/mem

run -all
log /* -r
quit
