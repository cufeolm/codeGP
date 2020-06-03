

function void verify_addx(GUVM_sequence_item cmd_trans,GUVM_result_transaction res_trans,GUVM_history_transaction hist_trans);
    bit [32:0]i1,i2,hc ;
	bit [32:0] h1 ; 
	logic [31:0] q[$] ; 
	logic [31:0] result ;
	
	integer pipe_length ; 
	string report ; 
    bit success ; 
    static int old_c = 0  ; 

    i1 = hist_trans.get_reg_data(cmd_trans.rs1); 
	i2 =  hist_trans.get_reg_data(cmd_trans.rs2); 
	
	
	pipe_length =  5 ;
	q = {};
	
	
	if (cmd_trans.SOM == SB_HISTORY_MODE)
    begin	
        old_c = hist_trans.carry ;
		h1 = i1 + i2 + old_c ;
		hist_trans.loadreg(h1[31:0],cmd_trans.rd);

        // hist_trans.carry=h1[32];
        // hist_trans.neg = h1[31];
		// hist_trans.zero = (h1[31:0]==0);
        // hist_trans.overflow = (i1[31]&&i2[31]&&(~h1[31])) || ((~i1[31])&&(~i2[31])&&(h1[31]));
        
        

		//$display("holaaaaaaaaaaaaa3a33a3a %d,CARRY = %d",h1,hist_trans.carry);
    end
    
    else if (cmd_trans.SOM == SB_VERIFICATION_MODE)
	begin
		h1 =   hist_trans.get_reg_data(cmd_trans.rd); 
        foreach(hist_trans.item_history[i])begin
			
			if (xis1(hist_trans.item_history[i].cmd_trans.inst,findOP("Store")))begin 
				result = 0 ;
				for(int j = 0 ; j< pipe_length ; j++)begin
				// for(int j = 0 ; j< 5 ; j++)begin
					if (hist_trans.item_history[i+j].res_trans.result!=0)begin
						result = hist_trans.item_history[i+j].res_trans.result ; 
					end
				end
				q.push_back(result);
				i=i+1 ; 
			end
		end
		// $display("%p",q[0:$]);
		//hc = res_trans.result;
		success = 1 ; 
		report = "\n error report:\n";
		if (q[0]!=h1[31:0]) begin
			success = 0 ;
			report = {report , $sformatf("operation done wrong : Dut calculation=%h,SB calculation = %h \n",q[0],h1)};
		end
		// if (q[1][23]!=hist_trans.neg) begin
		// 	success = 0 ;
		// 	report = {report , $sformatf("wrong icc negative flag : dut flag =%d, SB flag =%d \n",q[1][23],hist_trans.neg)};
		// end
		// if (q[1][22]!=hist_trans.zero) begin
		// 	success = 0 ;
		// 	report = {report , $sformatf("wrong icc zero flag : dut flag =%d, SB flag =%d \n",q[1][22],hist_trans.zero)};
		// end
		// if (q[1][21]!=hist_trans.overflow) begin
		// 	success = 0 ;
		// 	report = {report , $sformatf("wrong icc overflow flag : dut flag =%d, SB flag =%d \n",q[1][21],hist_trans.overflow)};
		// end
		// if (q[1][20]!=hist_trans.carry) begin
		// 	success = 0 ;
		// 	report = {report , $sformatf("wrong icc carry flag : dut flag =%d, SB flag =%d \n",q[1][21],hist_trans.carry)};
		// end
		if(!success)report = {report , $sformatf("rs1=%d,rs2=%d,rd=%d\n",cmd_trans.rs1,cmd_trans.rs2,cmd_trans.rd)};

		if(success)
		begin
			`uvm_info ("ADDX_PASS", report, UVM_LOW)
		end
		else
		begin
			`uvm_error("ADDX_FAIL", report)
		end
	end

endfunction
