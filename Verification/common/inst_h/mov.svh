function void verify_move(GUVM_sequence_item cmd_trans, GUVM_result_transaction res_trans, GUVM_history_transaction hist_trans);
	bit [31:0] hc, i1, i2, h1;
	i1 = hist_trans.get_reg_data(cmd_trans.rs1); 
	i2 = hist_trans.get_reg_data(cmd_trans.rs2); 
	$display("i1=%d i2=%d ", i1, i2);
	if(cmd_trans.SOM == SB_HISTORY_MODE) begin	
		hist_trans.loadreg(i2[31:0], cmd_trans.rd);	
	end else if(cmd_trans.SOM == SB_VERIFICATION_MODE) begin
		foreach(hist_trans.item_history[i]) begin
			if(hist_trans.item_history[i].res_trans.result!==0) begin
				hc = hist_trans.item_history[i].res_trans.result; 
				//break; 
			end
		end
		h1 = hist_trans.get_reg_data(cmd_trans.rd);
		if(h1 == hc) begin
			`uvm_info ("move_pass", $sformatf("DUT Calculation=%d SB Calculation=%d ", hc, h1), UVM_LOW)
		end else begin
			`uvm_error("move_fail", $sformatf("DUT Calculation=%d SB Calculation=%d ", hc, h1))
		end
	end
/*
    bit [32:0]i1,i2,hc ;
	bit [32:0] h1 ; 
	logic [31:0] q[$] ; 
	logic [31:0] result ;
	integer pipe_length ; 
	string report ; 
    bit success ;
    i1 = hist_trans.get_reg_data(cmd_trans.rs1); 
	i2 =  hist_trans.get_reg_data(cmd_trans.rs2); 
	pipe_length =  5 ;
	q = {};
	if (cmd_trans.SOM == SB_HISTORY_MODE)
    begin	
		//h1 = i1 + i2  ;
		hist_trans.loadreg(i2[31:0],cmd_trans.rd);
    end
    
    else if (cmd_trans.SOM == SB_VERIFICATION_MODE)
	begin
		h1 =   hist_trans.get_reg_data(cmd_trans.rd); 
        foreach(hist_trans.item_history[i])begin
			
			if (xis1(hist_trans.item_history[i].cmd_trans.inst,findOP("Store")))begin 
				result = 0 ;
				for(int j = 0 ; j< pipe_length ; j++)begin
					if (hist_trans.item_history[i+j].res_trans.result!=0)begin
						result = hist_trans.item_history[i+j].res_trans.result ; 
					end
				end
				q.push_back(result);
				i=i+1 ; 
			end
		end
		success = 1 ; 
		report = "\n error report:\n";
		if (q[0]!=h1[31:0]) begin
			success = 0 ;
			report = {report , $sformatf("operation done wrong : Dut calculation=%d,SB calculation = %d \n",q[0],h1)};
		end
		
		if(!success)report = {report , $sformatf("rs1=%d,rs2=%d,rd=%d\n",cmd_trans.rs1,cmd_trans.rs2,cmd_trans.rd)};

		if(success)
		begin
			`uvm_info ("move_PASS", report, UVM_LOW)
		end
		else
		begin
			`uvm_error("move_FAIL", report)
		end
	end*/

endfunction





