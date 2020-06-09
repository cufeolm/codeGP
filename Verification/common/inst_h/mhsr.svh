
function void verify_multiply_high_signed_reg_reg(GUVM_sequence_item cmd_trans,GUVM_result_transaction res_trans,GUVM_history_transaction hist_trans);
    bit [31:0]i1,i2 ;
	integer i1c,i2c ;
	bit [31:0] h1 ;
	bit [63:0] h1_64 ; 
	logic [31:0] q[$] ; 
	logic [31:0] result ;
	
	integer pipe_length ; 
	string report ; 
    bit success ; 
    //static int old_c = 0  ; 

    i1 = hist_trans.get_reg_data(cmd_trans.rs1); 
	i2 =  hist_trans.get_reg_data(cmd_trans.rs2); 
	i1c= $signed({i1[31],i1});
	i2c= $signed({i2[31],i2});
	$display("i1=%b i2=%b\ni1c=%b i2c=%b",i1,i2,i1c,i2c);
	
	pipe_length =  5 ;
	q = {};
	
	
	if (cmd_trans.SOM == SB_HISTORY_MODE)
    begin			
		h1_64 = i1c * i2c  ;
		h1 = h1_64[63:32] ;
		$display("h1_64=%h h1=%h",h1_64,h1);
		hist_trans.loadreg(h1[31:0],cmd_trans.rd);
    end
    
    else if (cmd_trans.SOM == SB_VERIFICATION_MODE)
	begin
		h1 =   hist_trans.get_reg_data(cmd_trans.rd); 
        foreach(hist_trans.item_history[i])begin
			
			if (xis1(hist_trans.item_history[i].cmd_trans.inst,findOP("Store")))begin 
				result = 0 ;
				for(int j = 0 ; j< pipe_length ; j++)begin
				// for(int j = 0 ; j< 5 ; j++)begin
					if (hist_trans.item_history[i+j].res_trans.result!=0)begin
						result = hist_trans.item_history[i+j].res_trans.result ; 
					end
				end
				q.push_back(result);
				i=i+1 ; 
			end
		end
		// $display("%p",q[0:$]);
		success = 1 ; 
		report = "\n error report:\n";
		if (q[0]!=h1[31:0]) begin
			success = 0 ;
			report = {report , $sformatf("operation done wrong : Dut calculation=%h,SB calculation = %h \n",q[0],h1)};
		end
		
		if(!success)report = {report , $sformatf("rs1=%d,rs2=%d,rd=%d\n",cmd_trans.rs1,cmd_trans.rs2,cmd_trans.rd)};

		if(success)
		begin
			`uvm_info ("multiply_high_signed_reg_reg_PASS", report, UVM_LOW)
		end
		else
		begin
			`uvm_error("multiply_high_signed_reg_reg_FAIL", report)
		end
	end

endfunction
