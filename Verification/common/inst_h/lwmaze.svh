function void verify_load_word_misaligned_zero_extend(GUVM_sequence_item cmd_trans,GUVM_result_transaction res_trans,GUVM_history_transaction hist_trans);
	bit [31:0]reg_data,i1,i2,exp_res,actual_res,exp_mem_add,actual_mem_add,caseop ;
    bit [4:0]reg_add;
    bit[2:0] i;
	bit [31:0]rs1_data;
    reg_data = cmd_trans.data;
    reg_add = cmd_trans.rd;
    //exp_res= reg_data;
    if (cmd_trans.SOM == SB_HISTORY_MODE)
	begin	
		rs1_data = hist_trans.get_reg_data(cmd_trans.rs1);
		caseop = rs1_data+cmd_trans.zimm;
		case (caseop[1:0])
			2'b00:reg_data = cmd_trans.data[31:0];
			2'b01:reg_data = {{cmd_trans.data[7:0]},{cmd_trans.data[31:8]}};
			2'b10:reg_data = {{cmd_trans.data[15:0]},{cmd_trans.data[31:16]}};
			2'b11:reg_data = {{cmd_trans.data[23:0]},{cmd_trans.data[31:24]}};
		endcase
		hist_trans.loadreg(reg_data,reg_add);
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
		exp_res = hist_trans.get_reg_data(cmd_trans.rd);
		exp_mem_add = rs1_data+cmd_trans.zimm;
		exp_mem_add = (exp_mem_add/4)*4;
		$display("1st load r[%d] 2nd load r[%d] data=%h store r[%d]",cmd_trans.rs1,cmd_trans.rs2,cmd_trans.data,cmd_trans.rd);
		$display("zimm=%h %d",cmd_trans.zimm,cmd_trans.zimm);
		$display ("exp_res=%0d", exp_res);
		if((exp_res == actual_res) && (exp_mem_add == actual_mem_add))
		begin
			`uvm_info ("load_word_misaligned_zero_extend_PASS", $sformatf("DUT result Calculation=%0d SB result Calculation=%0d DUT mem_add Calculation=%0d SB mem_add Calculation=%0d ",actual_res,exp_res,actual_mem_add,exp_mem_add), UVM_LOW)
		end
		else
		begin
			`uvm_error("load_word_misaligned_zero_extend_FAIL", $sformatf("DUT result Calculation=%0d SB result Calculation=%0d DUT mem_add Calculation=%0d SB mem_add Calculation=%0d ",actual_res,exp_res,actual_mem_add,exp_mem_add))
		end
	end
endfunction