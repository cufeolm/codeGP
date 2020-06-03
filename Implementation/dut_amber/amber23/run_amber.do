# change directory
# cd E:/vlog/amber25

vlib work

################### compiling ################
# vlog a25_localparams.v	
# vlog *.v

vlog a23_alu.v
vlog a23_barrel_shift.v
vlog a23_barrel_shift_fpga.v
vlog a23_config_defines.v
vlog a23_coprocessor.v
vlog a23_core.v
#vlog a23_dcache.v
vlog a23_decode.v
vlog a23_execute.v
vlog a23_fetch.v
#vlog a23_icache.v
vlog a23_cache.v
#vlog a23_mem.v
vlog a23_multiply.v
vlog a23_register_bank.v
#vlog a23_shifter.v
vlog a23_wishbone.v
#vlog a23_wishbone_buf.v
#vlog a23_write_back.v
vlog boot_mem32.v
vlog boot_mem128.v
vlog generic_sram_byte_en.v
vlog generic_sram_line_en.v

vsim -novopt a23_core

add wave -position insertpoint sim:/a23_core/*
add wave -position insertpoint sim:/a23_core/u_execute/u_register_bank/*


####################### forcing values ##################
# forcing clock, interrupt and system status:
# force -freeze sim:/a23_core/i_clk 1 0, 0 {500 ns} -r 1us
force -freeze sim:/a23_core/i_clk 1 0, 0 {50 ns} -r 100
force -freeze sim:/a23_core/i_irq 1'b0 0
force -freeze sim:/a23_core/i_firq 1'b0 0
force -freeze sim:/a23_core/i_system_rdy 1'b1 0

# forcing address, data in and control signals:
# add inst. --> 1110 0000 1000 (Rn=0000) (Rd=0001) 0000 0000 (Rm=0011)‬
force -freeze sim:/a23_core/i_wb_dat 32'hE0801002 0
############################################################################
#force -freeze sim:/a25_core/i_wb_dat 128'hF0801003F0801003F0801003E5801000 0
# TRANS --> 1110 01(I25=)(P24=) (U23=)(B22=)(W21=)(L20=) 0000 0001 0000 0000 0000
#       --> 1110 0101 1000 0000 0001 0000 0000 0000

force -freeze sim:/a23_core/i_wb_ack 1'b1 0
force -freeze sim:/a23_core/i_wb_err 1'b0 0

# forcing register file
#force -freeze sim:/a23_core/u_execute/u_register_bank/r1 32'b00000000000000000000000000000111 0
force -freeze sim:/a23_core/u_execute/u_register_bank/r0 32'b00000000000000000000000000000001 0
force -freeze sim:/a23_core/u_execute/u_register_bank/r3 32'b00000000000000000000000000000001 0

