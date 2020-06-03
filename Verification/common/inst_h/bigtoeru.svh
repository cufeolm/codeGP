function void verify_bigtoeru(GUVM_sequence_item cmd_trans,GUVM_result_transaction res_trans,GUVM_history_transaction hist_trans);
	bit [31:0]i1,i2,exp_npc,actual_npc,offset,cpc;
    //integer i1c,i2c,kemo;
    static bit greater_or_equal;
	//hist_trans.updateflags (h1);


	if (cmd_trans.SOM == SB_HISTORY_MODE)
	begin	
        i1 = hist_trans.get_reg_data(cmd_trans.rs1); 
        i2 = hist_trans.get_reg_data(cmd_trans.rs2);
        // i1c= $signed({i1[31],i1});
        // i2c= $signed({i2[31],i2});
        // $display("i1=%b i2=%b\ni1c=%b i2c=%b",i1,i2,i1c,i2c);
        greater_or_equal = i1 >= i2;
        $display("greater_or_equal = %b",greater_or_equal);
        //$display("i1=%h i2=%h",i1,i2);
	end
	else if (cmd_trans.SOM == SB_VERIFICATION_MODE)begin
        cpc = cmd_trans.current_pc ; 
		$display("cpc = %0d",cpc);
		offset =  cmd_trans.simm ;
		$display("offset = 32h'%h 	32b'%b",offset,offset);
        exp_npc = cpc + offset;
        $display("greater_or_equal = %b",greater_or_equal);
        if (greater_or_equal)begin
            foreach(hist_trans.item_history[i])begin
			if ((hist_trans.item_history[i+1].cmd_trans.current_pc - hist_trans.item_history[i].cmd_trans.current_pc) > 32'd4) begin
				 actual_npc = hist_trans.item_history[i+1].cmd_trans.current_pc; 
				 break ; 
			end
		    end
            if((actual_npc) == (exp_npc))
                `uvm_info ("BRANCH_IF_GREATER_REGISTER_PASS", $sformatf("DUT Calculation=%h SB Calculation=%h ", actual_npc, exp_npc), UVM_LOW)
            else
                `uvm_error("BRANCH_IF_GREATER_REGISTER_FAIL", $sformatf("DUT Calculation=%h SB Calculation=%h ", actual_npc, exp_npc))
        end
        else begin
            foreach(hist_trans.item_history[i])begin
			if ((cmd_trans.inst == hist_trans.item_history[i].cmd_trans.inst)) begin
				 actual_npc = hist_trans.item_history[i+1].cmd_trans.current_pc; 
				 break ; 
			end
		    end
            if((actual_npc) == (cpc + 32'd4))
                `uvm_info ("BRANCH_IF_GREATER_REGISTER_PASS", $sformatf("DUT Calculation=%h SB Calculation=%h ", actual_npc, (cpc + 32'd4)), UVM_LOW)
            else
                `uvm_error("BRANCH_IF_GREATER_REGISTER_FAIL", $sformatf("DUT Calculation=%h SB Calculation=%h ", actual_npc, (cpc + 32'd4)))
        end
	end


endfunction