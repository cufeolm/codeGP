
if [file exists "work"] {vdel -all}
vlib work
onerror {quit}

puts "Hello, World; - With  a semicolon inside the quotes"

vlog -f riscy/dut_riscy.f

vlog +incdir+riscy+GUVM riscy/target_pkg.sv 
vlog riscy/riscy_interface.sv
vlog riscy/top.sv

vsim top

run -all
log /* -r
quit
