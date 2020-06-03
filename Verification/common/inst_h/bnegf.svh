


function void verify_bnegf(GUVM_sequence_item cmd_trans,GUVM_result_transaction res_trans,GUVM_history_transaction hist_trans);
	logic [31:0] pcold,pcnew ;
	automatic logic  dc =0;
	logic condition ;
	int store,branch,sub; 
	logic [31:0] result ; 
	bit annul , offset ,success ; 
	bit [31:0]hc,i1,i2,h1 ;
	string report;
	// int t_store , t_branch ; 
	//t_store = 3 ; 
    //t_branch = 3;
    automatic string inst_s = "BNEGF";// VERY IMPORTANT

	if (cmd_trans.SOM == SB_HISTORY_MODE)
	begin	

		
    end
    
    else if (cmd_trans.SOM == SB_VERIFICATION_MODE)
	begin
		//GUVM_sequence_item branch , taken ;


		//check for pc discontinuity
		result = 0 ; dc=0; pcold = 0 ; pcnew = 0 ; condition = 0 ;
		foreach(hist_trans.item_history[i])begin
			if (hist_trans.item_history[i].cmd_trans.SOM==SB_HISTORY_MODE&&xis1(hist_trans.item_history[i].cmd_trans.inst,findOP(inst_s))) branch = i ;
			if (xis1(hist_trans.item_history[i].cmd_trans.inst,findOP("Store"))) store = i ;
			if (xis1(hist_trans.item_history[i].cmd_trans.inst,findOP("SUBCC"))) sub = i ;
			
			if (i>0&&hist_trans.item_history[i].cmd_trans.SOM==SB_HISTORY_MODE)begin
				if (hist_trans.item_history[i].cmd_trans.current_pc>hist_trans.item_history[i-1].cmd_trans.current_pc+4) begin
				 //hc = hist_trans.item_history[i].res_trans.result ; 
					//pcold = hist_trans.item_history[branch].cmd_trans.current_pc;
					pcold = hist_trans.item_history[branch].cmd_trans.current_pc;
					pcnew = hist_trans.item_history[i].cmd_trans.current_pc;
					dc =1 ;
					//`uvm_info ("bie_PASS", $sformatf("DUT Calculation=%h SB Calculation=%h ", pc, pc), UVM_LOW); 
				end
				// else begin
				// 	dc=0;
				// end
			end

			if (hist_trans.item_history[i].res_trans.result != 0 && i> store) result = hist_trans.item_history[i].res_trans.result ; 
			
		end
		
		//i = sub ; 
		//$display(sub,branch,store);
		//$display("result : %h,dc : %d,pcold:%d,pcnew:%d",result,dc,pcold,pcnew);
		//$display("subc: rs1=%d,rs2=%d,rd=%d",hist_trans.item_history[sub].cmd_trans.rs1,hist_trans.item_history[sub].cmd_trans.rs2,hist_trans.item_history[sub].cmd_trans.rd);
		//pcold = hist_trans.item_history[branch].cmd_trans.current_pc;
		//pcnew = hist_trans.item_history[branch+t_branch].cmd_trans.current_pc;

		// if (pcnew-pcold == t_branch*4)dc = 0; 
		// else dc = 1 ;
		
		//result =hist_trans.item_history[store+t_store].res_trans.result;


		i1 = hist_trans.get_reg_data(hist_trans.item_history[sub].cmd_trans.rs1); 
		i2 = hist_trans.get_reg_data(hist_trans.item_history[sub].cmd_trans.rs2); 
		h1 = i1 - i2 ;
		//$display("h1 = %d",h1);
		condition = (hist_trans.neg==1);
        //$display("condition %d,annul %d",condition,hist_trans.item_history[branch].cmd_trans.inst[29]);
        //$display("branch %h",condition,hist_trans.item_history[branch].cmd_trans.inst);
		annul = (!condition)&&hist_trans.item_history[branch].cmd_trans.inst[29]; 


        offset=((pcold +hist_trans.item_history[branch].cmd_trans.simm*4) != pcnew );
        //$display("supposed new pc = %d",pcold +hist_trans.item_history[branch].cmd_trans.simm*4);
		
		report ="" ;
		if (dc&&offset) report = {report , $sformatf("offset is wrong , pc jumped somewhere else, DUT offset = 32'h%h,ScoreBoard Offset = 32'h%h,",pcnew-pcold,hist_trans.item_history[branch].cmd_trans.simm*4) } ;
		if ((dc&&(!condition))) report = {report , "condition not met and jumped anyway, "} ;
		// if ((annul&&(result != h1 ))) report = {report , "instruction not annuled when it should have "} ;
		if ((annul&&(result == i1+i2 ))) report = {report , "instruction not annuled when it should have "} ;
		success = (!(dc&&offset)) && (!(dc&&(!condition))) && (!(annul&&(result == i1+i2 )));



		
		if (success)begin
			`uvm_info ("BNEGF_PASS", report, UVM_LOW);
		end
		else begin
			`uvm_info ("BNEGF_FAIL", report, UVM_LOW);
		end
		
	end

endfunction


