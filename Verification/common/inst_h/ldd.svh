function void verify_load_double_word(GUVM_sequence_item cmd_trans,GUVM_result_transaction res_trans,GUVM_history_transaction hist_trans);
	bit [31:0]reg_data,reg_data2,exp_res,exp_res2,actual_res,actual_res2,exp_mem_add,actual_mem_add ;
    bit [4:0]reg_add;
    integer i,j;
	bit [31:0]rs1_data;
    reg_data = cmd_trans.data;
    reg_data2 = cmd_trans.data2;
    reg_add = cmd_trans.rd;
    //exp_res= reg_data;
    if (cmd_trans.SOM == SB_HISTORY_MODE)
	begin	
		rs1_data = hist_trans.get_reg_data(cmd_trans.rs1);
		hist_trans.loadreg(reg_data,reg_add);
        hist_trans.loadreg(reg_data2,(reg_add+32'd1));
	end
	else if (cmd_trans.SOM == SB_VERIFICATION_MODE)begin
        foreach(hist_trans.item_history[i]) begin
			if (hist_trans.item_history[i].res_trans.mem_add!=0) begin
				 actual_mem_add = hist_trans.item_history[i].res_trans.mem_add ;
                 j=i+2;
				break ; 
			end
		end
        $display("j=%d",j);
		while(hist_trans.item_history[j]) begin
			if (hist_trans.item_history[j].res_trans.result!=0) begin
				 actual_res = hist_trans.item_history[j].res_trans.result ;
                 j=j+1; 
				break ; 
			end
            j=j+1;
		end
        $display("j=%d",j);
        while(hist_trans.item_history[j]) begin
			if (hist_trans.item_history[j].res_trans.result!=0) begin
				 actual_res2 = hist_trans.item_history[j].res_trans.result ;
                 j=j+1; 
				break ; 
			end
            j=j+1;
		end
		exp_res = hist_trans.get_reg_data(cmd_trans.rd);
        exp_res2 = hist_trans.get_reg_data((cmd_trans.rd+32'd1));
		exp_mem_add = rs1_data+cmd_trans.simm;
		$display("1st load r[%d] 2nd load r[%d] data=%h data2=%h store r[%d]",cmd_trans.rs1,cmd_trans.rs2,cmd_trans.data,cmd_trans.data2,cmd_trans.rd);
		$display("simm=%h %d",cmd_trans.simm,cmd_trans.simm);
		$display ("exp_res=%0d", exp_res,"exp_res2=%0d", exp_res2);
		if((exp_res == actual_res) && (exp_mem_add == actual_mem_add) && (exp_res2 == actual_res2))
		begin
			`uvm_info ("load_word_PASS", $sformatf("DUT result Calculation=%0d,%0d SB result Calculation=%0d,%0d DUT mem_add Calculation=%0d SB mem_add Calculation=%0d ",actual_res,actual_res2,exp_res,exp_res2,actual_mem_add,exp_mem_add), UVM_LOW)
		end
		else
		begin
			`uvm_error("load_word_FAIL", $sformatf("DUT result Calculation=%0d,%0d SB result Calculation=%0d,%0d DUT mem_add Calculation=%0d SB mem_add Calculation=%0d ",actual_res,actual_res2,exp_res,exp_res2,actual_mem_add,exp_mem_add))
		end
	end
endfunction