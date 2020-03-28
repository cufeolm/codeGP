interface GUVM_interface;
    import iface::*;

    logic       clk;
    logic       rst;
    logic       pciclk;
    logic       pcirst;

    iu_in_type integer_unit_input; // to the core
    iu_out_type integer_unit_output; // from the core
    
    icache_out_type icache_output; // to the core
    icache_in_type icache_input; // address to the instruction cach

    dcache_out_type dcache_output; // to the core
    
    dcache_in_type dcache_input ;  // to the data cach

    icdiag_in_type dcache_output_diag; // inside dcache_out_type package // what is this ? 

    initial begin
        clk = 0;
	end	
	
    always @ (posedge clk)  force dut.iu0.de.cwp=7;  ///////////////
	
    function void send_data(logic [31:0] data);
        dcache_output.data = data ;
    endfunction

    function void send_inst(logic [31:0] inst);
        icache_output.data = inst ; 
    endfunction
	
	task verify_inst(logic [31:0] inst);
        send_inst(inst) ; 
		repeat(2*5)#10 clk=~clk;
        repeat(2*5)#10 clk=~clk;
    endtask
	
	
    function logic [31:0] receive_data();
        $display("madd : %b",dcache_input.maddress);
		return dcache_input.edata;
    endfunction 
	
	
    //function logic [31:0] store(logic [4:0] ra );
    task store(logic [31:0] inst );
		send_inst(inst);
		repeat(2*2)#10 clk=~clk;
        bfm.nop();		
		repeat(2*1)#10 clk=~clk;
		$display("result = %0d",receive_data());
		repeat(2*10)#10 clk=~clk;
		//mon();
    endtask

    //function void load(logic [4:0] ra , logic [31:0] rd );
    task load(logic [31:0] inst, logic [31:0] rd );
        send_inst(inst);
        send_data(rd);
		repeat(2*1)#10 clk=~clk;
		nop();
		repeat(2*4)#10 clk=~clk;
    endtask

    function void nop ();
        icache_output.data = 32'h01000000;
    endfunction
	
    function void add(logic [4:0] r1,logic [4:0] r2,logic [4:0] rd);
        //dcache_output.hold = 1'b0;
        //icache_output.hold = 1'b0;
        //dcache_output.mds = 1'b1;
        send_inst({2'b10,rd,6'b0,r1,1'b0,8'b0,r2});
    endfunction

    task set_Up();
                ////////////// da mkan elsetup function //////////////////
        send_data(32'h100);
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
		repeat (2*10)#10 clk=~clk;
    endtask

    task reset_dut();
        rst = 1'b0;
		repeat (2*10)#10 clk=~clk;  
		rst = 1'b1;
		repeat (2*1)#10 clk=~clk;
    endtask : reset_dut

endinterface: GUVM_interface