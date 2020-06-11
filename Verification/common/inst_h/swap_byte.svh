/*function void verify_swap_byte(GUVM_sequence_item cmd_trans,GUVM_result_transaction res_trans,GUVM_history_transaction hist_trans);
	//bit [31:0]he,h1 ;
	bit [31:0] actual_result,actual_mem_add,exp_result,exp_mem_add,rs2_data;
	bit [4:0]reg_add;
	bit [31:0] reg_data;
	bit [5:0]i;
	reg_add = cmd_trans.rd;
	//hc = res_trans.result;
	
	//he = res_trans.result;
//	h1 = cmd_trans.swapped_operand;
if (cmd_trans.SOM == SB_HISTORY_MODE)
	begin	
	    reg_data = {{24{0}},cmd_trans.data[7:0]};
		reg_add = cmd_trans.rd;
		hist_trans.loadreg(reg_data,reg_add);
        rs2_data = hist_trans.get_reg_data(cmd_trans.rs2);		
		
       
	end
	else if (cmd_trans.SOM == SB_VERIFICATION_MODE)begin
		foreach(hist_trans.item_history[i]) begin
			if (hist_trans.item_history[i].res_trans.result!=0) begin
				 actual_result = hist_trans.item_history[i].res_trans.result ; 
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
	           exp_result = hist_trans.get_reg_data(cmd_trans.rd);///////
               exp_mem_add=rs2_data;
        //  swap_b_res={{24{0}},res_trans.result[7:0]};
				//$display("swapped_operand=%d",cmd_trans.swapped_operand);

					if(((exp_result) == (actual_result)) && (exp_mem_add==actual_mem_add))
						begin
							`uvm_info ("SWAP__BYTE_PASS", $sformatf("DUT Calculation=%d SCOREBOARD Calculation=%d DUT memory address Calculation=%0d SCOREBOARD memory address Calculation=%0d ", actual_result, exp_result,actual_mem_add,exp_mem_add), UVM_LOW)
						end
					else
						begin
							`uvm_error("SWAP_bYTE_FAIL", $sformatf("DUT Calculation=%0d SCOREBOARD Calculation=%0d DUT memory address Calculation=%0d SCOREBOARD memory address Calculation=%0d ",actual_result,exp_result,actual_mem_add,exp_mem_add))
						end
	end
endfunction*/

function void verify_swap_byte(GUVM_sequence_item cmd_trans,GUVM_result_transaction res_trans,GUVM_history_transaction hist_trans);
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
	    rs1_data = hist_trans.get_reg_data(cmd_trans.rs1);
	    rs2_data = hist_trans.get_reg_data(cmd_trans.rs2);
	    op= rs1_data;	
	    case(op[1:0])
			2'b00:reg_data = {{24{0}},{cmd_trans.data[7:0]}};
			//2'b01:reg_data = {{cmd_trans.data[31:16]},{cmd_trans.data[7:0]},{cmd_trans.data[15:8]}};
			//2'b10:reg_data = {{cmd_trans.data[15:0]},{cmd_trans.data[31:16]}};
			//2'b11:reg_data = {{cmd_trans.data[23:0]},{cmd_trans.data[31:24]}};
			2'b01:reg_data = {{24{0}},{cmd_trans.data[15:8]}};
			2'b10:reg_data = {{24{0}},{cmd_trans.data[23:16]}};
			2'b11:reg_data = {{24{0}},{cmd_trans.data[31:24]}};
		endcase
		
	    reg_add = cmd_trans.rd;
	    //hc = res_trans.result;
	    //reg_data = cmd_trans.data;
		hist_trans.loadreg(reg_data,reg_add);
        
	end
	else if (cmd_trans.SOM == SB_VERIFICATION_MODE)begin
		foreach(hist_trans.item_history[i]) begin
			if (hist_trans.item_history[i].res_trans.result!=0) begin
				 actual_result_reg = hist_trans.item_history[i].res_trans.result ; 
				break ; 
			end
		end
		foreach(hist_trans.item_history[i]) begin
			if (hist_trans.item_history[i].res_trans.result!=0) begin
				 actual_result_mem = hist_trans.item_history[i].res_trans.result ; 
				//break ; 
			end
		end
		foreach(hist_trans.item_history[i]) begin
		if (xis1(hist_trans.item_history[i].cmd_trans.inst,findOP("Store")))begin
			if (hist_trans.item_history[i].res_trans.mem_add!=0) begin
				 actual_mem_add = hist_trans.item_history[i].res_trans.mem_add ; 
				//break ; 
			end
		end
		end
		//hc = res_trans.result;
	           exp_result_mem= hist_trans.get_reg_data(cmd_trans.rd);///////
			   exp_result_reg={{3{rs2_data[7:0]}},{rs2_data[7:0]}};
               exp_mem_add=rs1_data;
			   
        //  swap_b_res={{24{0}},res_trans.result[7:0]};
				//$display("swapped_operand=%d",cmd_trans.swapped_operand);

					if(((exp_result_mem) == (actual_result_mem)) && (exp_result_reg==actual_result_reg))
					//&& (exp_mem_add==actual_mem_add))
						begin
							`uvm_info ("SWAP_PASS", $sformatf("DUT Calculation mem=%h SCOREBOARD Calculation mem=%h DUT reg Calculation=%0h SCOREBOARD reg Calculation=%0h ", actual_result_mem,exp_result_mem,actual_result_reg,exp_result_reg), UVM_LOW)
						end
					else
						begin
							`uvm_error("SWAP_FAIL", $sformatf("DUT Calculation mem=%h SCOREBOARD Calculation mem=%h DUT reg Calculation=%0h SCOREBOARD reg Calculation=%0h ", actual_result_mem,exp_result_mem,actual_result_reg,exp_result_reg))
						end
	end
endfunction