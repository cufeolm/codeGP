interface GUVM_interface(input clk);
	
	import GUVM_classes_pkg::*;

	logic i_clk;
	logic i_irq = 1'b0;
	logic i_firq = 1'b0;
	logic i_system_rdy = 1'b1;
	//Wishbone Interface
	logic [31:0] o_wb_adr;
	logic [15:0] o_wb_sel;
	logic o_wb_we;
	logic [127:0] i_wb_dat;
	logic [127:0] o_wb_dat;
	logic o_Wb_cyc = 1'b1;
	logic o_wb_stb;
	logic i_wb_ack;
	logic i_wb_err = 1'b0;
	logic [31:0] inst;

	clocking driver_cb @ (negedge clk);
	    output inst;
	endclocking : driver_cb

	always @ (negedge clk) begin
        i_wb_dat = {96'hF0081003F0081003F0081003, inst_in};
    end
    
    clocking monitor_cb @ (negedge clk);
        input o_wb_dat;
        // lessa b2eet el7agat 
    endclocking : monitor_cb

    modport driver_if_mp (clocking driver_cb);
    modport monitor_if_mp (clocking monitor_cb);

    ////////////// elclock generation hatkoon fe eltop ///////////////////
    // always #5 clk = ~clk;
    // initial begin
    //     clk = 0;
    // end
    ////////////////////////////////////////////////////////////////////// 
   
    /*
	initial begin
	    i_clk = 0;
	    #10;
	    i_clk = 1;
	    #10;
	end
	*/

	task reset_dut();	
		repeat (10) begin
			@(negedge i_clk);
		end
	endtask : reset_dut

endinterface: GUVM_interface


