onerror {resume}
quietly WaveActivateNextPane {} 0

add wave /top/bfm/clk_pseudo
add wave vsim:/top/dut/instr_rdata_i 
add wave vsim:/top/dut/data_rdata_i
add wave vsim:/top/dut/data_addr_o
add wave vsim:/top/dut/data_wdata_o
add wave vsim:/top/dut/instr_addr_o
add wave vsim:/top/dut/if_stage_i/branch_req
add wave vsim:/top/dut/if_stage_i/prefetch_32/prefetch_buffer_i/branch_i 
add wave /top/dut/id_stage_i/imm_uj_type
add wave /top/dut/id_stage_i/pc_id_i
add wave vsim:/top/dut/if_stage_i/pc_if_o
add wave vsim:/top/dut/if_stage_i/instr_valid_id_o
add wave vsim:/top/dut/if_stage_i/if_valid
add wave vsim:/top/dut/instr_req_o
add wave vsim:/top/dut/instr_gnt_i
add wave vsim:/top/dut/instr_rvalid_i
add wave vsim:/top/dut/id_stage_i/registers_i/riscv_register_file_i/mem
#add wave vsim:/top/dut/id_stage_i/registers_i/riscv_register_file_i/*

add wave -r /top/dut/*
add wave -r /*


TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50316229 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1000 ns}
