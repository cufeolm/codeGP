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

# force -freeze sim:top/dut/u_execute/u_register_bank/r1 32'b00000000000000000000000000000111 0
add wave -position insertpoint sim:/top/bfm/send_inst/*
add wave -position insertpoint sim:/top/bfm/receive_data/*
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
add wave -position insertpoint sim:/top/dut/u_execute/u_register_bank/*

