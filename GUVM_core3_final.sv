interface GUVM_interface(input clk);
//	  import amber_pkg::*;
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
wire [31:0] inst_in;
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

function void setup_data();
i_irq 				= 1'b0;
i_firq      		= 1'b0;
i_system_rdy        = 1'b1;
i_wb_ack			= 1'b1;
i_wb_err			= 1'b0;
endfunction: setup_data

clocking driver_cb @ (posedge i_clk);
	    output inst_in;
endclocking : driver_cb

always @ (inst_in)
begin
	i_wb_dat = {96'hF0081003F0081003F0081003, inst_in};
end
    
clocking monitor_cb @ (posedge i_clk);
        input o_wb_dat;
endclocking : monitor_cb

modport driver_if_mp (clocking driver_cb);
modport monitor_if_mp (clocking monitor_cb);

endinterface: GUVM_interface

