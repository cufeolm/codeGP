vcom -f leon/DUT_LEON.f 
vlog +incdir+leon+GUVM leon/target_pkg.sv
vlog leon/leon_interface.sv
vlog leon/top.sv

#+incdir+leon/DUT

vsim top


run -all
log /* -r
quit
