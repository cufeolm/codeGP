function void verify_store_half_word(GUVM_sequence_item cmd_trans,GUVM_result_transaction res_trans,GUVM_history_transaction hist_trans);
	automatic bit [31:0]store_data,exp_res,actual_res,exp_mem_add,actual_mem_add ;
    bit[2:0] i;
	automatic bit c1,c2; // verification conditions
	automatic string m="" ;
	automatic string s = "" ; 
    if (cmd_trans.SOM == SB_HISTORY_MODE)
	begin
		
	end
	else if (cmd_trans.SOM == SB_VERIFICATION_MODE)begin
		foreach(hist_trans.item_history[i]) begin
			if (hist_trans.item_history[i].res_trans.result!=0) begin
				 actual_res = hist_trans.item_history[i].res_trans.result ; 
				//break ; 
			end
		end
		foreach(hist_trans.item_history[i]) begin
			if (hist_trans.item_history[i].res_trans.mem_add!=0) begin
				 actual_mem_add = hist_trans.item_history[i].res_trans.mem_add ;
				break ; 
			end
		end
		exp_mem_add = hist_trans.get_reg_data(cmd_trans.rs1)+cmd_trans.simm;
		store_data = hist_trans.get_reg_data(cmd_trans.store_add);
		$display ("store_data=%0h", store_data);
		exp_res = {2{store_data[15:0]}};
		$display("1st load r[%d] 2nd load r[%d] 3rd load r[%d]",cmd_trans.rs1,cmd_trans.rs2,cmd_trans.rd);
		$display("simm=%h %d",cmd_trans.simm,cmd_trans.simm);
		$display ("exp_res=%0h", exp_res);
		c1 = (exp_res == actual_res);
		c2 = (exp_mem_add == actual_mem_add);
		$sformat(m,"DUT result Calculation=%0d  SB result Calculation=%0d\n",actual_res,exp_res);
		s={s ,m} ;	
		$sformat(m,"DUT mem_add Calculation=%0d SB mem_add Calculation=%0d\n",actual_mem_add,exp_mem_add);
		s={s ,m} ;
		if(c1 && c2)
		begin
			`uvm_info ("store_half_word_PASS",s, UVM_LOW)
		end
		else
		begin
			`uvm_error("store_half_word_FAIL",s)
		end
	end
endfunction