function void verify_JumpAndLinkRegReg(GUVM_sequence_item cmd_trans,GUVM_result_transaction res_trans,GUVM_history_transaction hist_trans);
	bit [31:0]actual_r,exp_r,actual_npc,cpc,exp_npc,offset,i1,i2 ; 
    i1 = hist_trans.get_reg_data(cmd_trans.rs1);
    i2 = hist_trans.get_reg_data(cmd_trans.rs2);
	// cpc => current_pc, npc => next_pc, exp => expected, r => result in rd
	if (cmd_trans.SOM == SB_HISTORY_MODE)
	begin	

		
	end
	else if (cmd_trans.SOM == SB_VERIFICATION_MODE)begin
		cpc = cmd_trans.current_pc ; 
		$display("cpc = %0d",cpc);
		offset =  i1 + i2 ;
		$display("offset = 32h'%h 	32b'%b",offset,offset);
		//actual_npc = cmd_trans.current_pc;
		$display("npc = %0d",actual_npc);
		foreach(hist_trans.item_history[i])begin
			if (hist_trans.item_history[i].res_trans.result!==0) begin
				 actual_r = hist_trans.item_history[i].res_trans.result; 
				 break ; 
			end
		end
		foreach(hist_trans.item_history[i])begin
			if ((hist_trans.item_history[i+1].cmd_trans.current_pc - hist_trans.item_history[i].cmd_trans.current_pc) > 32'd4) begin
				 actual_npc = hist_trans.item_history[i+1].cmd_trans.current_pc; 
				 break ; 
			end
		end
		exp_r = cpc ;
		exp_npc = offset;
		if((exp_r == actual_r) && (exp_npc == actual_npc))
		begin
			`uvm_info ("JumpAndLinkRegReg_PASS", $sformatf("Actual register result=%d Expected register result=%d ", actual_r, exp_r), UVM_LOW)
			`uvm_info ("JumpAndLinkRegReg_PASS", $sformatf("Actual next pc=%d Expected next pc=%d ", actual_npc, exp_npc), UVM_LOW)
		end
		else
		begin
			`uvm_error ("JumpAndLinkRegReg_FAIL", $sformatf("Actual register result=%d Expected register result=%d ", actual_r, exp_r))
			`uvm_error ("JumpAndLinkRegReg_FAIL", $sformatf("Actual next pc=%d Expected next pc=%d ", actual_npc, exp_npc))	
		end
	end
endfunction
