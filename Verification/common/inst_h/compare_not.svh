function void verify_compare_not(GUVM_sequence_item cmd_trans,GUVM_result_transaction res_trans,GUVM_history_transaction hist_trans);
 	bit [32:0] hc,h1 ;
	bit [31:0] i1,i2;
	automatic bit [3:0] actual_updated_flags=4'bxxxx;
	automatic bit carry=1'bx;
 	i1 = hist_trans.get_reg_data(cmd_trans.rs1); 
 	i2 = hist_trans.get_reg_data(cmd_trans.rs2);
//i1=0;
//i2=0;	
	//carry = cmd_trans.current_pc[29];
 	h1 = i1 + i2;
 	$display("i1=%b i2=%b h1=%b",i1,i2,h1);
 	//hist_trans.updateflags (h1);

 	if (cmd_trans.SOM == SB_HISTORY_MODE)
 	begin	
 		//h1 = i1 - i2;
		hist_trans.loadreg(h1[31:0],cmd_trans.rd);	
		
        hist_trans.carry=h1[32];
        hist_trans.neg = h1[31];
		if(i1==i2)
		begin
		hist_trans.zero =1'b1;
		end
		else
		begin
		hist_trans.zero =1'b0;
		end
		
        hist_trans.overflow = (i1[31]&&i2[31]&&(~h1[31])) || ((~i1[31])&&(~i2[31])&&(h1[31]));
 	end
 	else if (cmd_trans.SOM == SB_VERIFICATION_MODE)begin
	    foreach(hist_trans.item_history[i])begin
 		if (xis1(hist_trans.item_history[i].cmd_trans.inst,findOP("Store")))begin
        		actual_updated_flags=cmd_trans.updated_flags[31:28];
		end
		end
 		//hc = res_trans.result;
 		h1 = hist_trans.get_reg_data(cmd_trans.rd);
		$display("flags= %b",actual_updated_flags);
		$display("carry= %b",h1[32]);
		$display("overflow= %b",(i1[31]&&i2[31]&&(~h1[31])) || ((~i1[31])&&(~i2[31])&&(h1[31])));
		$display("history flags: carry %h , neg %h ,zero %h , overflow %h", hist_trans.carry, hist_trans.neg ,hist_trans.zero,hist_trans.overflow);
 		if((hist_trans.carry==actual_updated_flags[1]) && (hist_trans.neg==actual_updated_flags[3]) && (hist_trans.zero==actual_updated_flags[2]) && (hist_trans.overflow==actual_updated_flags[0]))
 		begin
 			`uvm_info ("COMPARE_NOT_PASS", $sformatf("DUT flags: carry %h , neg %h ,zero %h , overflow %h  SCOREBOARD flags: carry %h , neg %h ,zero %h , overflow %h ",actual_updated_flags[1],actual_updated_flags[3],actual_updated_flags[2],actual_updated_flags[0], hist_trans.carry, hist_trans.neg ,hist_trans.zero,hist_trans.overflow), UVM_LOW)
 		end
 		else
		begin
 			`uvm_error("COMPARE_NOT_FAIL", $sformatf("DUT flags: carry %h , neg %h ,zero %h , overflow %h  SCOREBOARD flags: carry %h , neg %h ,zero %h , overflow %h ",actual_updated_flags[1],actual_updated_flags[3],actual_updated_flags[2],actual_updated_flags[0], hist_trans.carry, hist_trans.neg ,hist_trans.zero,hist_trans.overflow))
 		end
        
	end
    endfunction