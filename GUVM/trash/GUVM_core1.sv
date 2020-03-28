`timescale 10ns/1ns
interface GUVM_interface(
		//logic clk
	);

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

	// Clock and Reset
	bit       clk_i;
	bit       rst_ni;
	bit       clock_en_i;    // enable clock, otherwise it is gated
	bit       test_en_i;    // enable all clock gates for testing
	bit       fregfile_disable_i;  // disable the fp regfile, using int regfile instead
	// Core ID, Cluster ID and boot address are considered more or less static
	reg [31:0] boot_addr_i;
	reg [ 3:0] core_id_i;
	reg [ 5:0] cluster_id_i;
	// Instruction memory interface
	bit                     instr_req_o;
	bit                     instr_gnt_i;
	bit                     instr_rvalid_i;
	reg                 [31:0] instr_addr_o;
	reg [INSTR_RDATA_WIDTH-1:0] instr_rdata_i;
	// Data memory interface
	bit       data_req_o;
	bit       data_gnt_i;
	bit       data_rvalid_i;
	bit       data_we_o;
	reg [3:0]  data_be_o;
	reg [31:0] data_addr_o;
	reg [31:0] data_wdata_o;
	reg [31:0] data_rdata_i;
	// apu-interconnect
	// handshake signals
	bit             apu_master_req_o ;
	bit             apu_master_ready_o ;
	bit             apu_master_gnt_i ;
	// request channel
	reg [APU_NARGS_CPU-1:0][31:0] apu_master_operands_o;
	reg [APU_WOP_CPU-1:0]         apu_master_op_o;
	reg [WAPUTYPE-1:0]            apu_master_type_o;
	reg [APU_NDSFLAGS_CPU-1:0]    apu_master_flags_o;
	// response channel
	bit                           apu_master_valid_i;
	reg [31:0]                     apu_master_result_i;
	reg [APU_NUSFLAGS_CPU-1:0]     apu_master_flags_i;
	// Interrupt inputs
	bit       irq_i;                 // level sensitive IR lines
	reg [4:0]  irq_id_i;
	bit       irq_ack_o;
	reg [4:0]  irq_id_o;
	bit        irq_sec_i;
	bit        sec_lvl_o;
	// Debug Interface
	bit       debug_req_i;
	// CPU Control Signals
	bit       fetch_enable_i;
	bit       core_rbusy_o;
	reg [N_EXT_PERF_COUNTERS-1:0] ext_perf_counters_i;

	reg [31:0] wdata;
	wire [31:0] inst_in;

	initial begin
		clk_i = 0;
		#10;
		clk_i = 1;
		#10;
	end

	/*
	initial begin
	clk = 0;
	#10;
	clk = 1;
	#10;
	end
	*/

	task reset_dut();
		rst_ni = 1'b0;
		repeat (10) begin @(negedge clk_i); end
		rst_ni = 1'b1;
	endtask :

	/*
	task reset_dut();
	repeat (10) begin
	@(negedge clk);
	end
	endtask : reset_dut
	*/

	function void set_Up();
		clock_en_i            = 1'b1;
		test_en_i             = 1'b0;
		fregfile_disable_i    = 1'b1;
		boot_addr_i           = 32'h0000000A;
		core_id_i             = 4'h0;
		cluster_id_i          = 6'h0;
		instr_gnt_i           = 1'b1;
		instr_rvalid_i        = 1'b1;
		data_gnt_i            = 1'b0;
		data_rvalid_i         = 1'b1;
		irq_i                 = 1'h0;
		irq_sec_i             = 1'h0;
		debug_req_i           = 1'h0;
		fetch_enable_i        = 1'h1;

	endfunction: set_Up

	clocking driver_cb @ (posedge clk_i);
	output inst_in;
	endclocking : driver_cb

		always @ (inst_in) begin
			instr_rdata_i = inst_in;
		end

	always @ (inst_in) begin
		#110
			wdata=data_wdata_o;
	end

	clocking monitor_cb @ (posedge clk_i && wdata);
	input wdata;
	endclocking : monitor_cb

		modport driver_if_mp (clocking driver_cb);
	modport monitor_if_mp (clocking monitor_cb);

endinterface: GUVM_interface