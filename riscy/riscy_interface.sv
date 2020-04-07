interface GUVM_interface;
    import target_package::*; // importing leon core package
    
    // core paramerters
    parameter N_EXT_PERF_COUNTERS =  0;
    parameter INSTR_RDATA_WIDTH   = 32;
    parameter PULP_SECURE         =  0;
    parameter N_PMP_ENTRIES       = 16;
    parameter USE_PMP             =  1; //if PULP_SECURE is 1, you can still not use the PMP
    parameter PULP_CLUSTER        =  1;
    parameter FPU                 =  0;
    parameter Zfinx               =  0;
    parameter FP_DIVSQRT          =  0;
    parameter SHARED_FP           =  0;
    parameter SHARED_DSP_MULT     =  0;
    parameter SHARED_INT_MULT     =  0;
    parameter SHARED_INT_DIV      =  0;
    parameter SHARED_FP_DIVSQRT   =  0;
    parameter WAPUTYPE            =  0;
    parameter APU_NARGS_CPU       =  3;
    parameter APU_WOP_CPU         =  6;
    parameter APU_NDSFLAGS_CPU    = 15;
    parameter APU_NUSFLAGS_CPU    =  5;
    parameter DM_HaltAddress      = 32'h1A110800;

    // core interface ports
      // Clock and Reset
    logic       clk_i;
    logic       rst_ni;
    logic       clock_en_i;    // enable clock, otherwise it is gated
    logic       test_en_i;    // enable all clock gates for testing
    logic       fregfile_disable_i;  // disable the fp logicfile, using int logicfile instead
      // Core ID, Cluster ID and boot address are considered more or less static
    logic [31:0] boot_addr_i;
    logic [ 3:0] core_id_i;
    logic [ 5:0] cluster_id_i;
      // Instruction memory interface
    logic                     instr_req_o;
    logic                     instr_gnt_i;
    logic                     instr_rvalid_i;
    logic                 [31:0] instr_addr_o;
    logic [INSTR_RDATA_WIDTH-1:0] instr_rdata_i;
      // Data memory interface
    logic       data_req_o;
    logic       data_gnt_i;
    logic       data_rvalid_i;
    logic       data_we_o;
    logic [3:0]  data_be_o;
    logic [31:0] data_addr_o;
    logic [31:0] data_wdata_o;
    logic [31:0] data_rdata_i;
      // apu-interconnect
      // handshake signals
    logic             apu_master_req_o ;
    logic             apu_master_ready_o ;
    logic             apu_master_gnt_i ;
      // request channel
    logic [APU_NARGS_CPU-1:0][31:0] apu_master_operands_o;
    logic [APU_WOP_CPU-1:0]         apu_master_op_o;
    logic [WAPUTYPE-1:0]            apu_master_type_o;
    logic [APU_NDSFLAGS_CPU-1:0]    apu_master_flags_o;
      // response channel
    logic                           apu_master_valid_i;
    logic [31:0]                     apu_master_result_i;
    logic [APU_NUSFLAGS_CPU-1:0]     apu_master_flags_i;
      // Interrupt inputs
    logic       irq_i;                 // level sensitive IR lines
    logic [4:0]  irq_id_i;
    logic       irq_ack_o;
    logic [4:0]  irq_id_o;
    logic        irq_sec_i;
    logic        sec_lvl_o;
      // Debug Interface
    logic       debug_req_i;
      // CPU Control Signals
    logic       fetch_enable_i;
    logic       core_busy_o;
    logic [N_EXT_PERF_COUNTERS-1:0] ext_perf_counters_i;

    logic [31:0] out;

    GUVM_monitor monitor_h;

    // initializing the clk signal
    initial begin
        clk_i = 0;
    end 
        
    // sending data to the core    
    function void send_data(logic [31:0] data);
        data_rdata_i = data;
    endfunction

    // sending instructions to the core
    function void send_inst(logic [31:0] inst);
        instr_rdata_i = inst; 
    endfunction
    
    // sending the instruction to be verified
    task verify_inst(logic [31:0] inst);
        send_inst(inst); 
        repeat(2) begin 
            #10 clk_i=~clk_i;
        end
    endtask
    
    // reveiving data from the DUT
    function logic [31:0] receive_data();
        $display("received result: %b", data_wdata_o);
        monitor_h.write_to_monitor(data_wdata_o);
        return data_wdata_o; 
    endfunction 
    
    // dealing with the register file with the following load and store functions
    task store(logic [31:0] inst);
        send_inst(inst);
        repeat(6) begin 
            #10 clk_i=~clk_i;
        end
        $display("result = %0d", receive_data());
        // out = receive_data();
        repeat(30) begin 
            #10 clk_i=~clk_i;
        end
    endtask

    task load(logic [31:0] inst, logic [31:0] rd);
        send_inst(inst);
        repeat(10) begin 
            #10 clk_i=~clk_i;
        end
        send_data(rd);
        repeat(30) begin 
            #10 clk_i=~clk_i;
        end
    endtask
    
    /*task add(logic [4:0] r1, logic [4:0] r2, logic [4:0] rd);
        send_inst({7'b0000000, r2, r1, 3'b000, rd, 7'b0110011});
        repeat(15) begin 
            #10 clk_i=~clk_i;
        end
    endtask*/

    // initializing the core
    task set_Up();
        clock_en_i            = 1'b1;
        test_en_i             = 1'b0;
        fregfile_disable_i    = 1'b1;

        core_id_i             = 4'h0;
        cluster_id_i          = 6'h0;
        instr_gnt_i           = 1'b1;
        instr_rvalid_i        = 1'b1;

        data_gnt_i            = 1'b1;
        data_rvalid_i         = 1'b1;

        irq_i                 = 1'h0;
        irq_sec_i             = 1'h0;
        debug_req_i           = 1'h0;
        fetch_enable_i        = 1'h1;
        repeat(10) begin 
            #10 clk_i=~clk_i;
        end
    endtask

    task reset_dut();
        rst_ni = 1'b1;
        repeat(2*1) begin 
            #10 clk_i=~clk_i;
        end
        rst_ni = 1'b0;
        repeat(2*3) begin 
            #10 clk_i=~clk_i;
        end
        rst_ni = 1'b1;
    endtask : reset_dut

endinterface: GUVM_interface