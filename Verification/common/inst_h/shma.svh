function void verify_store_half_word_misaligned(GUVM_sequence_item cmd_trans,GUVM_result_transaction res_trans,GUVM_history_transaction hist_trans);
	automatic bit [31:0]store_data,exp_res,actual_res,exp_mem_add,actual_mem_add,exp_mem_add2,actual_mem_add2 ;
    bit[2:0] i;
	bit [3:0]exp_write_e,actual_write_e,exp_write_e2,actual_write_e2;
	automatic bit c1,c2,c3,c4,c5; // verification conditions
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
				 actual_mem_add2 = hist_trans.item_history[i+1].res_trans.mem_add ; 
				 actual_write_e = hist_trans.item_history[i].res_trans.data_write_e ;
				 actual_write_e2 = hist_trans.item_history[i+1].res_trans.data_write_e ;
				break ; 
			end
		end
		exp_mem_add = hist_trans.get_reg_data(cmd_trans.rs1)+cmd_trans.simm;
		exp_mem_add2 = exp_mem_add;
		store_data = hist_trans.get_reg_data(cmd_trans.store_add);
		$display ("store_data=%0h", store_data);
		case (exp_mem_add[1:0])
			2'b00:begin
				exp_res = store_data[31:0];
				exp_write_e = 4'b0011;
				exp_write_e2 = exp_write_e;
			end
			2'b01:begin
				exp_res = {{store_data[23:0]},{store_data[31:24]}};
				exp_write_e = 4'b0110;
				exp_write_e2 = exp_write_e;	
			end
			2'b10:begin
				exp_res = {{store_data[15:0]},{store_data[31:16]}};
				exp_write_e = 4'b1100;	
				exp_write_e2 = exp_write_e;
			end
			2'b11:begin
				exp_res = {{store_data[7:0]},{store_data[31:8]}};
				exp_mem_add = exp_mem_add2+32'd4;
				exp_write_e = 4'b0001;
				exp_write_e2 = 4'b1000;	
			end
		endcase
		$display("1st load r[%d] 2nd load r[%d] 3rd load r[%d]",cmd_trans.rs1,cmd_trans.rs2,cmd_trans.rd);
		$display("simm=%h %d",cmd_trans.simm,cmd_trans.simm);
		$display ("exp_res=%0h", exp_res);
		c1 = (exp_res == actual_res);
		c2 = (exp_mem_add == actual_mem_add);
		c3  = (exp_write_e == actual_write_e);
		c4 = (exp_mem_add2 == actual_mem_add2);
		c5  = (exp_write_e2 == actual_write_e2);
		$sformat(m,"DUT result Calculation=%0d  SB result Calculation=%0d\n",actual_res,exp_res);
		s={s ,m} ;	
		$sformat(m,"DUT mem_add Calculation=%0d SB mem_add Calculation=%0d\n",actual_mem_add,exp_mem_add);
		s={s ,m} ;
		$sformat(m,"DUT write_e Calculation=%0d SB write_e Calculation=%0d\n",actual_write_e,exp_write_e);
		s={s ,m} ;
		$sformat(m,"DUT mem_add2 Calculation=%0d SB mem_add2 Calculation=%0d\n",actual_mem_add2,exp_mem_add2);
		s={s ,m} ;
		$sformat(m,"DUT write_e2 Calculation=%0d SB write_e2 Calculation=%0d\n",actual_write_e2,exp_write_e2);
		s={s ,m} ;
		if(c1 && c2 && c3 && c4 && c5)
		begin
			`uvm_info ("store_half_word_PASS",s, UVM_LOW)
		end
		else
		begin
			`uvm_error("store_half_word_FAIL",s)
		end
	end
endfunction