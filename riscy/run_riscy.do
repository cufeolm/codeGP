
if [file exists "work"] {vdel -all}
vlib work
onerror {quit}

puts "Hello, World; - With  a semicolon inside the quotes"

vlog -f dut_riscy.f

vlog +incdir+riscy+GUVM target_pkg.sv 
vlog riscy_interface.sv
vlog top.sv

vsim top


run -all
log /* -r
quit
