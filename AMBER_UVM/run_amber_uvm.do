vlog +incdir+format amber_pkg.sv
vlog -f file.f
vlog GUVM_interface.sv
vlog top.sv

set NoQuitOnFinish 1
onbreak {resume}

vsim top 

log /* -r

run -all

quit