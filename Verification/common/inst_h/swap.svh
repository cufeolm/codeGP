function void verify_swap(GUVM_sequence_item cmd_trans,GUVM_result_transaction res_trans,GUVM_history_transaction hist_trans);
	//bit [31:0]he,h1 ;
	bit [31:0] actual_result_reg,actual_mem_add,exp_result_reg,exp_result_mem,exp_mem_add,rs1_data,op,actual_result_mem,rs2_data;
	bit [4:0]reg_add;
	bit [31:0] reg_data;
	bit [5:0]i;
	//reg_add = cmd_trans.rd;
	//hc = res_trans.result;
	//reg_data = cmd_trans.data;
	//he = res_trans.result;
//	h1 = cmd_trans.swapped_operand;
if (cmd_trans.SOM == SB_HISTORY_MODE)
	begin
	
	    reg_add = cmd_trans.rd;
	    //hc = res_trans.result;
	    reg_data = cmd_trans.data;
		hist_trans.loadreg(reg_data,reg_add);
        rs1_data = hist_trans.get_reg_data(cmd_trans.rs1);		
       
	end
	else if (cmd_trans.SOM == SB_VERIFICATION_MODE)begin
		/*foreach(hist_trans.item_history[i]) begin
			if (xis1(hist_trans.item_history[i].cmd_trans.inst,findOP("Store")))begin
				 actual_result_reg = hist_trans.item_history[i].res_trans.result ; 
				break ; 
			end
		end*/
		
		foreach(hist_trans.item_history[i]) begin
			if (hist_trans.item_history[i].res_trans.result!=0) begin
				 actual_result_mem = hist_trans.item_history[i].res_trans.result ; 
				//break ; 
			end
		end
		foreach(hist_trans.item_history[i]) begin
			if (hist_trans.item_history[i].res_trans.mem_add!=0) begin
				 actual_mem_add = hist_trans.item_history[i].res_trans.mem_add ; 
				break ; 
			end
		end
		
		//hc = res_trans.result;
	           exp_result_mem= hist_trans.get_reg_data(cmd_trans.rd);///////
			   exp_result_reg=0;
               exp_mem_add=rs1_data+cmd_trans.simm;
        //  swap_b_res={{24{0}},res_trans.result[7:0]};
				//$display("swapped_operand=%d",cmd_trans.swapped_operand);

					if(((exp_result_mem) == (actual_result_mem)) && (exp_mem_add==actual_mem_add))
						begin
							`uvm_info ("SWAP_PASS", $sformatf("DUT Calculation mem=%h SCOREBOARD Calculation mem=%h DUT memory address Calculation=%0h SCOREBOARD memory address Calculation=%0h", actual_result_mem,exp_result_mem,actual_mem_add,exp_mem_add), UVM_LOW)
						end
					else
						begin
							`uvm_error("SWAP_FAIL", $sformatf("DUT Calculation mem=%h SCOREBOARD Calculation mem=%h DUT memory address Calculation=%0h SCOREBOARD memory address Calculation=%0h", actual_result_mem,exp_result_mem,actual_mem_add,exp_mem_add))
						end
	end
endfunction