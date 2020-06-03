if [file exists "work"] {vdel -all}
vlib work

################### compiling ################
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

################ testbench ################
vlog GUVM_bfm_amber.sv;
vlog top.sv
vsim -novopt top

# force -freeze sim:top/dut/u_execute/u_register_bank/r1 32'b00000000000000000000000000000111 0
#add wave -position insertpoint sim:/top/bfm/send_inst/*
#add wave -position insertpoint sim:/top/bfm/receive_data/*
add wave -position insertpoint  \
sim:/top/bfm/i_clk \
sim:/top/bfm/i_firq \
sim:/top/bfm/i_irq \
sim:/top/bfm/i_system_rdy \
sim:/top/bfm/i_wb_ack \
sim:/top/bfm/i_wb_dat \
sim:/top/bfm/i_wb_err \
sim:/top/bfm/o_wb_adr \
sim:/top/bfm/o_wb_cyc \
sim:/top/bfm/o_wb_dat \
sim:/top/bfm/o_wb_sel \
sim:/top/bfm/o_wb_stb \
sim:/top/bfm/o_wb_we
add wave -r /* 
#add wave -position insertpoint sim:/a23_core/*
#add wave -position insertpoint sim:/top/dut/u_execute/u_register_bank/*

log /* -r

run -all
