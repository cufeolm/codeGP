if [file exists "work"] {vdel -all}
vlib work

################### compiling ################
vlog a25_alu.v
vlog a25_barrel_shift.v
vlog a25_config_defines.v
vlog a25_coprocessor.v
vlog a25_core.v
vlog a25_dcache.v
vlog a25_decode.v
vlog a25_execute.v
vlog a25_fetch.v
vlog a25_icache.v
vlog a25_mem.v
vlog a25_multiply.v
vlog a25_register_bank.v
vlog a25_shifter.v
vlog a25_wishbone.v
vlog a25_wishbone_buf.v
vlog a25_write_back.v
vlog boot_mem32.v
vlog boot_mem128.v
vlog generic_sram_byte_en.v
vlog generic_sram_line_en.v

################ testbench ################
vlog GUVM_bfm_amber.sv;
vlog top.sv
vsim -novopt top

add wave -position insertpoint sim:/top/bfm/*


