interface GUVM_interface;
  import amber_pkg::*;

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

task reset_dut();	
repeat (10) begin
	 	@(negedge i_clk);
	 end
endtask : reset_dut


task input_inst (logic [31:0] inst);
	i_wb_dat = {96'hF0081003F0081003F0081003, inst};
endtask : input_inst	

function void set_UP();
i_irq 				= 1'b0;
i_firq      		= 1'b0;
i_system_rdy        = 1'b1;
i_wb_ack			= 1'b1;
i_wb_err			= 1'b0;
endfunction: set_UP

function automatic logic [31:0] OUTPUT_DATA(
		ref logic [31:0] idata,
		ref logic [31:0] wdata,
		ref logic [31:0] instr,
		ref logic [31:0] addr);	 


endfunction: OUTPUT_DATA


endinterface: GUVM_interface


