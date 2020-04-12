function void verify_add(target_seq_item cmd_trans,GUVM_result_transaction res_trans);
	bit [31:0]hc,i1,i2,h1 ;
	hc = res_trans.result;
	i1 = cmd_trans.operand1; 
	i2 = cmd_trans.operand2;
	h1 = i1 + i2 ;
	if((h1) == (hc))
	begin
        `uvm_info ("ADDITION_PASS", $sformatf("Actual Calculation=%d Expected Calculation=%d ", hc, h1), UVM_LOW)
	end
	else
	begin
		`uvm_error("ADDITION_FAIL", $sformatf("Actual Calculation=%d Expected Calculation=%d ", hc, h1))
	end
endfunction