

`include "uvm_macros.svh"
//`include "GUVM_sequence.sv"
//`include "leon_pkg.sv"
//`include "riscy_pkg.sv"
//`include "amber_pkg.sv"
import uvm_pkg::*;
import leon_package::*;
`uvm_analysis_imp_decl(_mon_trans)
`uvm_analysis_imp_decl(_drv_trans)

class GUVM_scoreboard extends uvm_scoreboard;
    
    // register the scoreboard in the UVM factory
    `uvm_component_utils(GUVM_scoreboard);

    //GUVM_sequence_item trans, input_trans;

    // analysis implementation ports
    uvm_analysis_imp_mon_trans #(GUVM_sequence_item,GUVM_scoreboard) Mon2Sb_port;
    uvm_analysis_imp_drv_trans #(GUVM_sequence_item,GUVM_scoreboard) Drv2Sb_port;

    // TLM FIFOs to store the actual and expected transaction values
    uvm_tlm_fifo #(GUVM_sequence_item)  drv_fifo;
    uvm_tlm_fifo #(GUVM_sequence_item)  mon_fifo;

   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      //Instantiate the analysis ports and Fifo
      Mon2Sb_port = new("Mon2Sb",  this);
      Drv2Sb_port = new("Drv2Sb",  this);
      drv_fifo     = new("drv_fifo", this,100);  //BY DEFAULT ITS SIZE IS 1 BUT CAN BE UNBOUNDED by putting 0
      mon_fifo     = new("mon_fifo", this,100);
   endfunction : build_phase

   // write_drv_trans will be called when the driver broadcasts a transaction
   // to the scoreboard
   function void write_drv_trans (GUVM_sequence_item input_trans);
        void'(drv_fifo.try_put(input_trans));
   endfunction : write_drv_trans

   // write_mon_trans will be called when the monitor broadcasts the DUT results
   // to the scoreboard 
   function void write_mon_trans (GUVM_sequence_item trans);
        void'(mon_fifo.try_put(trans));
   endfunction : write_mon_trans

	   task run_phase(uvm_phase phase);
		  GUVM_sequence_item exp_trans, out_trans;
		  bit [31:0] h1,i1,i2,imm,registered_inst;
		  //bit [19:0] sign;
		  forever begin
		  $display("RANDA SCOREBOARD have started xxx");
		//  $display("Expected Instruction=%h \n", exp_trans.inst);
		  //$display("operand1_scb=%h \n", i1);
		//  $display("operand2_scb=%h \n", i2);
		  
		 // `uvm_info ("READ_INSTRUCTION ", $sformatf("Expected Instruction=%h \n", exp_trans.inst), UVM_LOW)
			drv_fifo.get(exp_trans);
			mon_fifo.get(out_trans);
				i1=exp_trans.op1;
				i2=exp_trans.op2;
				registered_inst=exp_trans.inst;
				$display("RANDA HIIIIIII");
				$display("operand1_scb=%h \n", i1);
				$display("operand2_scb=%h \n", i2);
				$display("Expected Instruction=%h \n", registered_inst);
				//opcode reg_instruction;
				//`uvm_info ("SCOREBOARD ENTERED ",$sformatf("HELLO IN SCOREBOARD"), UVM_LOW);
				leon_package::reg_instruction = leon_package::reg_instruction.first;
                for(int i=0;i<6;i++)
				begin
				$display("LOOP ENTERED");
                $display("reg_instruction  ::  Value of  %0s is = %0d",leon_package::reg_instruction.name(),leon_package::reg_instruction);
				end
				//si_a []
					/*for (int i = 0; i < $size(leon_package::si_a); i++)
					begin
					$display("LOOP ENTERED");
					if(exp_trans.inst==leon_package::si_a[i])
					begin
					registered_inst=leon_package::si_a[i];
					$display("resulted_inst is si_a[%0d] = %s", i, leon_package::si_a[i]);
					end
					else
					begin
					$display("instruction is not in the enum si_a[%0d] = %s",i, leon_package::si_a[i]);
					end
		  $display("element si_a[%0d] = %s", i,leon_package::si_a[i]);
		  end*/
			
			//imm={{20{exp_trans.immediate_data[11]}}, exp_trans.immediate_data};  //IMMEDIATE VALUE SIGN EXTENSION
			// rand logic [31:0] inst;
                         //rand logic [31:0] oprand1,oprand2;
			
/* if((exp_trans.inst[31:30]==2'b10 && exp_trans.inst[24:19]==6'b000000 && exp_trans.inst[13:5]==9'b000000000) ||(exp_trans.inst[6:0]==7'b0110011 && exp_trans.inst[14:12]==3'b000 && exp_trans.inst[31:25]==7'b0000000 ) || (exp_trans.inst[24:21]==4'h4 && exp_trans.inst[27:26]==2'b00)) //LEON/RISCY/AMBER //ADD common 
begin 
`uvm_info ("ADD_INSTRUCTION_PASS ", $sformatf("Actual Instruction=%h Expected Instruction=%h \n",out_trans.inst_out, exp_trans.instrn), UVM_LOW)
	h1=i1+i2;				
						if((h1)==(out_trans.reg_data))
						begin
						`uvm_info ("ADDITION_PASS ", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1), UVM_LOW)
						end
						else
						begin
						`uvm_error("ADDITION_FAIL", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1))
						end


	  end
	  else if((exp_trans.inst[31:30]==2'b10 && exp_trans.inst[24:19]==6'b000000 && exp_trans.inst[13]==1'b1) || (exp_trans.inst[6:0]==7'b0010011 && exp_trans.inst[14:12]==3'b000 )) //ADD IMMEDIATE INSTRUCTION
	  begin 
      `uvm_info ("ADD_IMMEDIATE_INSTRUCTION_PASS ", $sformatf("Actual Instruction=%h Expected Instruction=%h \n",out_trans.inst_out, exp_trans.instrn), UVM_LOW)
	   h1=i1+imm;				
						if((h1)==(out_trans.reg_data))
						begin
						`uvm_info ("ADDITION_IMMEDIATE_PASS ", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1), UVM_LOW)
						end
						else
						begin
						`uvm_error("ADDITION_IMMEDIATE_FAIL", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1))
						end


	  end
	  else
	  begin
	  `uvm_error("INSTRUCTION_ERROR", $sformatf("Actual=%d Expected=%d \n",out_trans.inst_out, exp_trans.instrn))
	  end */
	  
	  
	  
	  //if((registered_inst==A)) //LEON only
	  if((exp_trans.inst[31:30]==2'b10 && exp_trans.inst[24:19]==6'b000000 && exp_trans.inst[13:5]==9'b000000000) ||(exp_trans.inst[6:0]==7'b0110011 && exp_trans.inst[14:12]==3'b000 && exp_trans.inst[31:25]==7'b0000000 ) || (exp_trans.inst[24:21]==4'h4 && exp_trans.inst[27:26]==2'b00))
begin 
 $display("RANDA inst ADDDDDDDD");
`uvm_info ("ADD_INSTRUCTION_PASS ", $sformatf("Expected Instruction=%h \n", exp_trans.inst), UVM_LOW)
	h1=i1+i2;				
						if((h1)==(out_trans.receivedDATA))
						begin
						`uvm_info ("ADDITION_PASS ", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.receivedDATA, h1), UVM_LOW)
						end
						else
						begin
						`uvm_error("ADDITION_FAIL", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.receivedDATA, h1))
						end


	  end
	 /* else if((exp_trans.inst==AI) //ADD IMMEDIATE INSTRUCTION
	  begin 
      `uvm_info ("ADD_IMMEDIATE_INSTRUCTION_PASS ", $sformatf("Actual Instruction=%h Expected Instruction=%h \n",out_trans.inst_out, exp_trans.instrn), UVM_LOW)
	   h1=i1+i2;				
						if((h1)==(out_trans.data))
						begin
						`uvm_info ("ADDITION_IMMEDIATE_PASS ", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1), UVM_LOW)
						end
						else
						begin
						`uvm_error("ADDITION_IMMEDIATE_FAIL", $sformatf("Actual Calculation=%d Expected Calculation=%d \n",out_trans.reg_data, h1))
						end


	  end*/
	  else
	  begin
	  `uvm_error("INSTRUCTION_ERROR", $sformatf("Expected=%d \n", exp_trans.inst))
	  $display("WRONG INSTTTTT");
	  end 
	  end
   endtask
endclass : GUVM_scoreboard	
