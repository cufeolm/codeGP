if [file exists "work"] {vdel -all}
vlib work

################### compiling ################
vlog fpnew_pkg.sv
vlog riscv_defines.sv
vlog riscv_config.sv
vlog riscv_tracer_defines.sv
vlog apu_core_package.sv
vlog apu_macros.sv
# vlog -f DUT_RISCY.f

vlog *.sv

################ testbench ################
vlog GUVM_bfm_riscy.sv;
vlog top.sv
# vsim -novopt top

# ################ add to wave ################
# add wave -r /*
# add wave -position insertpoint sim:/riscv_core/id_stage_i/registers_i/*
