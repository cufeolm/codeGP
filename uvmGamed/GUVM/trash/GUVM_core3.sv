interface GUVM_interface(
		// logic clk;
		logic [31:0] i_reg //used in a hierarchy to access register file
	);

	// import amber_pkg::*;
	// import GUVM_classes_pkg::*;
	bit i_clk;
	bit i_irq;
	bit i_firq;
	bit i_system_rdy;
	//Wishbone Interface
	reg [31:0] o_wb_adr;
	reg [15:0] o_wb_sel;
	bit o_wb_we;
	reg [127:0] i_wb_dat;
	reg [127:0] o_wb_dat;

	//added signals to generalize
	wire [31:0] inst_in;
	reg [31:0] wdata;

	/////////

	bit o_Wb_cyc;
	bit o_wb_stb;
	bit i_wb_ack;
	bit i_wb_err;



	initial begin
		i_clk = 0;
		#10;
		i_clk = 1;
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
		repeat (10) begin
			@(negedge i_clk);
		end
	endtask : reset_dut

	/*
	task reset_dut();
	repeat (10) begin
	@(negedge clk);
	end
	endtask : reset_dut
	*/

	function void set_Up();
		i_irq 				= 1'b0;
		i_firq      		= 1'b0;
		i_system_rdy        = 1'b1;
		i_wb_ack			= 1'b1;
		i_wb_err			= 1'b0;
	endfunction: set_Up

	clocking driver_cb @ (posedge i_clk);
	output inst_in;
	endclocking : driver_cb

		always @ (inst_in)
			begin
				i_wb_dat = {96'hF0081003F0081003F0081003, inst_in};
			end

	always @ (inst_in)
		begin
			#110
				wdata=o_wb_dat[31:0];
		end

	clocking monitor_cb @ (posedge i_clk && wdata);
	input wdata;
	endclocking : monitor_cb

		modport driver_if_mp (clocking driver_cb);
	modport monitor_if_mp (clocking monitor_cb);

endinterface: GUVM_interface


