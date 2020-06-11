function void verify_move_not(GUVM_sequence_item cmd_trans, GUVM_result_transaction res_trans, GUVM_history_transaction hist_trans);
	bit [31:0] hc, i1, i2, h1;
	i1 = hist_trans.get_reg_data(cmd_trans.rs1); 
	i2 = hist_trans.get_reg_data(cmd_trans.rs2); 
	$display("i1=%d i2=%d ", i1, i2);
	//$display("comp_i2=%0d",~i2);
	if(cmd_trans.SOM == SB_HISTORY_MODE) begin	
		hist_trans.loadreg(i2[31:0], cmd_trans.rd);	
	end else if(cmd_trans.SOM == SB_VERIFICATION_MODE) begin
		foreach(hist_trans.item_history[i]) begin
			if(hist_trans.item_history[i].res_trans.result!==0) begin
				hc = hist_trans.item_history[i].res_trans.result; 
				//break; 
			end
		end
		h1 = ~(hist_trans.get_reg_data(cmd_trans.rd));
		if(h1 == hc) begin
			`uvm_info ("move_not_pass", $sformatf("DUT Calculation=%d SB Calculation=%d ", hc, h1), UVM_LOW)
		end else begin
			`uvm_error("move_not_fail", $sformatf("DUT Calculation=%d SB Calculation=%d ", hc, h1))
		end
	end
endfunction