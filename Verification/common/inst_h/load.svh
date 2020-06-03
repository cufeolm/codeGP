function void verify_load(GUVM_sequence_item cmd_trans,GUVM_result_transaction res_trans,GUVM_history_transaction hist_trans);
	bit [31:0]reg_data,i1,i2,h1 ;
    bit [4:0]reg_add;
    reg_data = cmd_trans.data;
	//$display("loadfn********************rd= %0d",cmd_trans.rd);
    reg_add = cmd_trans.rd;
    
	if (cmd_trans.SOM == SB_HISTORY_MODE)
	begin	
		hist_trans.loadreg(reg_data,reg_add);

	end
	else if (cmd_trans.SOM == SB_VERIFICATION_MODE)begin
		/*hc = res_trans.result;
		if((h1) == (hc))
		begin
			`uvm_info ("ADDITION_PASS", $sformatf("Actual Calculation=%d Expected Calculation=%d ", hc, h1), UVM_LOW)
		end
		else
		begin
			`uvm_error("ADDITION_FAIL", $sformatf("Actual Calculation=%d Expected Calculation=%d ", hc, h1))
		end*/
	end
endfunction