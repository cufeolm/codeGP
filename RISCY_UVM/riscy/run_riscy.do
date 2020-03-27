# change directory
# cd D:/Projects/GP/developing_codes/riscv-master/rtl

vlib work

################### compiling ################
vlog fpnew_pkg.sv
vlog riscv_defines.sv
vlog riscv_config.sv
vlog riscv_tracer_defines.sv
vlog apu_core_package.sv
vlog apu_macros.sv

vlog *.sv

vsim -novopt riscv_core

add wave -r /*
add wave -position insertpoint sim:/riscv_core/id_stage_i/registers_i/*


####################### forcing values ##################
# forcing clock and reset
force -freeze sim:/riscv_core/clock_en_i 1 0
force -freeze sim:/riscv_core/clk_i 1 0, 0 {500 ns} -r 1us
force -freeze sim:/riscv_core/rst_ni 1 0
force -freeze sim:/riscv_core/rst_ni 0 1us
force -freeze sim:/riscv_core/rst_ni 1 3us
force -freeze sim:/riscv_core/test_en_i 0 0
force -freeze sim:/riscv_core/fregfile_disable_i 1 0
# forcing Core ID, Cluster ID and boot address are considered more or less static
#force -freeze sim:/riscv_core/boot_addr_i 32'h0000000a 0
force -freeze sim:/riscv_core/core_id_i 4'h0 0
force -freeze sim:/riscv_core/cluster_id_i 6'h0 0
# forcing Instruction memory interface
force -freeze sim:/riscv_core/instr_gnt_i 1 0us   
force -freeze sim:/riscv_core/instr_rvalid_i 1 0
#load 32'h00000003 in reg[2]
force -freeze sim:/riscv_core/instr_rdata_i 32'h000Fa103 5us
force -freeze sim:/riscv_core/data_rdata_i 32'h00000003 5us
#load 32'h00000005 in reg[3]
force -freeze sim:/riscv_core/instr_rdata_i 32'h000Fa183 20us
force -freeze sim:/riscv_core/data_rdata_i 32'h00000005 25us
#add reg[2]+reg[3] => reg[1]
force -freeze sim:/riscv_core/instr_rdata_i 32'h002180B3 35us
#store reg[1] => M(reg[3])
force -freeze sim:/riscv_core/instr_rdata_i 32'h001Fa023 50us
# forcing Data memory interface
force -freeze sim:/riscv_core/data_gnt_i 1 0
force -freeze sim:/riscv_core/data_rvalid_i 1 0
# forcing interrupt and debug
force -freeze sim:/riscv_core/irq_i 1'h0 0
force -freeze sim:/riscv_core/irq_sec_i 1'h0 0
force -freeze sim:/riscv_core/debug_req_i 1'h0 0
force -freeze sim:/riscv_core/fetch_enable_i 1'h1 0
# forcing register file
#force -freeze {sim:/riscv_core/id_stage_i/registers_i/riscv_register_file_i/mem[1]} 32'h00000001 7us
#force -freeze {sim:/riscv_core/id_stage_i/registers_i/riscv_register_file_i/mem[2]} 32'h00000002 7us
#force -freeze {sim:/riscv_core/id_stage_i/registers_i/riscv_register_file_i/mem[3]} 32'h00000003 7us
#force -freeze {sim:/riscv_core/id_stage_i/registers_i/riscv_register_file_i/mem[31]} 32'h00000007 7us
