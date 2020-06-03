interface GUVM_interface(input  clk );
   import uvm_pkg::*;
`include "uvm_macros.svh"
    import iface::*; // importing leon interface package: includes the records
    import target_package::*; // importing leon core package

    // core interface ports: declaring records
    //bit clk ; 
    logic       clk_pseudo;
    logic       rst;
    logic       pciclk;
    logic       pcirst;
    //for debugging only 
    

    iu_in_type integer_unit_input; // to the core
    iu_out_type integer_unit_output; // from the core
    
    icache_out_type icache_output; // to the core
    icache_in_type icache_input; // address to the instruction cach

    dcache_out_type dcache_output; // to the core
    
    dcache_in_type dcache_input ; // to the data cach

    icdiag_in_type dcache_output_diag; // inside dcache_out_type package // what is this ? 

    // declaring the monitor
    GUVM_result_monitor result_monitor_h;

    command_monitor command_monitor_h;

    logic [31:0]next_pc;

    bit allow_pseudo_clk;

    // initializing the clk_pseudo signal
    initial begin
        clk_pseudo = 0;
        allow_pseudo_clk = 0 ;
	end	
    always @(clk) begin
        if (allow_pseudo_clk)begin
            //$display(clk_pseudo);
            clk_pseudo = clk;
        end
    end
    task toggle_clk(integer i);
        allow_pseudo_clk =1 ;
        repeat(i)@(posedge clk_pseudo);
        allow_pseudo_clk =0 ;
    endtask

    always @ (posedge clk_pseudo)  force dut.iu0.de.cwp=7; // 
	
    // sending data to the core
    function void send_data(logic [31:0] data);
        dcache_output.data = data ;
    endfunction

    // sending instructions to the core
    function void send_inst(logic [31:0] inst);
        icache_output.data = inst ; 
    endfunction

    function void update_command_monitor(GUVM_sequence_item cmd);
        //cmd.current_pc=icache_input.rpc;
        command_monitor_h.write_to_cmd_monitor(cmd);

    endfunction
    function void update_result_monitor();
        //result_monitor_h.write_to_monitor(dcache_input.edata,next_pc);
        result_monitor_h.write_to_monitor(dcache_input.edata,dcache_input.maddress,4'd0);
    endfunction

    function logic[31:0] get_cpc();
        logic [31:0] x ;
        x[1:0]=0;
        x[31:2]=icache_input.fpc;
        return x;
    endfunction
    /*
    function void monitor_cmd(GUVM_sequence_item cmd);
        command_monitor_h.write_to_cmd_monitor(cmd);
    endfunction
    */
    // danger zone *************************
   // *** ************* *********************
    // *** ************* *********************
    // *** ************* *********************
    // *** ************* *********************
    // *** ************* *********************
    // *** ************* *********************
    // *** ************* *********************
    // *** ************* *********************
    // all of the below functions are not used except setup and reset
    // sending the instruction to be verified
    /*
    task verify_inst(logic [31:0] inst,logic [31:0]op1,logic [31:0]op2,logic [31:0]simm);
        command_monitor_h.write_to_cmd_monitor(inst,op1,op2,simm);
        send_inst(inst) ; 
        toggle_clk(1);
        nop();
        get_npc();
    endtask
    */


    task get_npc();
      toggle_clk(1);
      $display("next_pc = %b       %t", icache_input.rpc,$time);
      next_pc = icache_input.rpc;
    endtask

	// reveiving data from the DUT
    function logic [31:0] receive_data();//should be protected
        //$display("madd : %b",dcache_input.maddress);
        result_monitor_h.write_to_monitor(dcache_input.edata,dcache_input.maddress,4'd0);
        return dcache_input.edata;
       // monitor_h.write_to_monitor(dcache_input.maddress);
		//return dcache_input.maddress;
    endfunction 
	
	// dealing with the register file with the following load and store functions 
    //function logic [31:0] store(logic [4:0] ra);
    task store(logic [31:0] inst );
        send_inst(inst);
        //keemo_karamilla = 1;
        //allow_pseudo_clk =1 ;

        //repeat(2)@(posedge clk_pseudo);
        toggle_clk(2);
        //repeat(2*2)#10 clk=~clk;
        
        bfm.nop();
        toggle_clk(2);
        //repeat(2)@(posedge clk_pseudo);//repeat onde might cause a problem ???????????
        //repeat(2*1)#10 clk=~clk;
		$display("result = %0d",receive_data());
        //repeat(2*10)#10 clk=~clk;
        toggle_clk(10);
        //repeat(10)@(posedge clk_pseudo);
        //keemo_karamilla = 0 ;
        //allow_pseudo_clk =0 ;
    endtask

    //function void load(logic [4:0] ra , logic [31:0] rd);
    task load(logic [31:0] inst, logic [31:0] rd );
        send_inst(inst);
        send_data(rd);
        //allow_pseudo_clk =1 ;
        //repeat(2*1)#10 clk=~clk;
        //repeat(1)@(posedge clk_pseudo);
        toggle_clk(1);
        nop();
        toggle_clk(4);
        //repeat(4)@(posedge clk_pseudo);
        //repeat(2*4)#10 clk=~clk;
        //allow_pseudo_clk =0 ;
    endtask

    // no operation
    function void nop();
        icache_output.data = 32'h01000000;
    endfunction
	
    /*function void add(logic [4:0] r1,logic [4:0] r2,logic [4:0] rd);
        send_inst({2'b10,rd,6'b0,r1,1'b0,8'b0,r2});
    endfunction*/

    // initializing the core
    task set_Up();
        //send_data(32'h100);
        send_inst(32'h01000000);
		pciclk = 1'b0;
        pcirst = 1'b0;

        // iui
        integer_unit_input.irl = 4'b0000;

        // ico
        // icache_output.data = 32'h8E00C002;
        icache_output.exception = 1'b0;
        icache_output.hold = 1'b1;
        icache_output.flush = 1'b0; 
        icache_output.diagrdy = 1'b0;
        icache_output.diagdata = 32'h00000000; 
        icache_output.mds = 1'b0;

        // dco
        //dcache_output.data = 32'h13; // Data bus address
        dcache_output.mexc = 1'b0; // memory exception
        dcache_output.hold = 1'b1;
        dcache_output.mds = 1'b1;
        dcache_output.werr = 1'b0; // memory write error

        dcache_output_diag.addr = 15 ;
        //dcache_output_diag.enable = 32'h0;
        dcache_output_diag.enable = 1'b0;
        dcache_output_diag.read = 1'b0;
        dcache_output_diag.tag = 1'b0;
        dcache_output_diag.flush = 1'b0;

        dcache_output.icdiag=dcache_output_diag;
        //repeat (2*10)#10 clk=~clk;
        //$display("we reached this point at set up");
       // allow_pseudo_clk =1 ;
        //repeat(10)@(posedge clk_pseudo);
       // allow_pseudo_clk =0 ;
        toggle_clk(10);
    endtask

    task reset_dut();
        rst = 1'b0;
        //repeat (2*10)#10 clk=~clk;  
        //allow_pseudo_clk =1 ;
        //$display("we reached this point at reset");
       // repeat(10)@(posedge clk_pseudo);
        toggle_clk(10);
		rst = 1'b1;
        //repeat (2*1)#10 clk=~clk;
        toggle_clk(1);
       // repeat(1)@(posedge clk_pseudo);
        //allow_pseudo_clk =0 ;
    endtask : reset_dut

endinterface: GUVM_interface