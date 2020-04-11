module top;
   import uvm_pkg::*;
   import target_package::*;

    `include "uvm_macros.svh"

	GUVM_interface bfm();

    riscv_core dut(
        .clk_i(bfm.clk_i),
        .rst_ni(bfm.rst_ni),
        .clock_en_i(bfm.clock_en_i),
        .test_en_i(bfm.test_en_i),
        .fregfile_disable_i(bfm.fregfile_disable_i),
        .boot_addr_i(bfm.boot_addr_i),
        .core_id_i(bfm.core_id_i),
        .cluster_id_i(bfm.cluster_id_i),
        .instr_req_o(bfm.instr_req_o),
        .instr_gnt_i(bfm.instr_gnt_i),
        .instr_rvalid_i(bfm.instr_rvalid_i),
        .instr_addr_o(bfm.instr_addr_o),
        .instr_rdata_i(bfm.instr_rdata_i),
        .data_req_o(bfm.data_req_o),
        .data_gnt_i(bfm.data_gnt_i),
        .data_rvalid_i(bfm.data_rvalid_i),
        .data_we_o(bfm.data_we_o),
        .data_be_o(bfm.data_be_o),
        .data_addr_o(bfm.data_addr_o),
        .data_wdata_o(bfm.data_wdata_o),
        .data_rdata_i(bfm.data_rdata_i),
        .apu_master_req_o(bfm.apu_master_req_o),
        .apu_master_ready_o(bfm.apu_master_ready_o),
        .apu_master_gnt_i(bfm.apu_master_gnt_i),
        .apu_master_operands_o(bfm.apu_master_operands_o),
        .apu_master_op_o(bfm.apu_master_op_o),
        .apu_master_type_o(bfm.apu_master_type_o),
        .apu_master_flags_o(bfm.apu_master_flags_o),
        .apu_master_valid_i(bfm.apu_master_valid_i),
        .apu_master_result_i(bfm.apu_master_result_i),
        .apu_master_flags_i(bfm.apu_master_flags_i),
        .irq_i(bfm.irq_i),    
        .irq_id_i(bfm.irq_id_i),
        .irq_ack_o(bfm.irq_ack_o),
        .irq_id_o(bfm.irq_id_o),
        .irq_sec_i(bfm.irq_sec_i),
        .sec_lvl_o(bfm.sec_lvl_o),
        .debug_req_i(bfm.debug_req_i),
        .fetch_enable_i(bfm.fetch_enable_i),
        .core_busy_o(bfm.core_busy_o),
        .ext_perf_counters_i(bfm.ext_perf_counters_i)
    );

    initial begin
        uvm_config_db#(virtual GUVM_interface)::set(null, "*", "bfm", bfm);
        fill_si_array();
        run_test("GUVM_test");
    end

endmodule : top

     
   