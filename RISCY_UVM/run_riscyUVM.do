vlog +incdir+format riscy_pkg.sv

vlog riscy/fpnew_pkg.sv
vlog riscy/riscv_defines.sv
vlog riscy/riscv_config.sv
vlog riscy/riscv_tracer_defines.sv
vlog riscy/apu_core_package.sv
vlog riscy/apu_macros.sv
vlog riscy/*.sv

vlog GUVM_interface.sv
vlog top.sv

set NoQuitOnFinish 1
onbreak {resume}

vsim -novopt top 

log /* -r

run -all