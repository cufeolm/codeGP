
`include "uvm_macros.svh"
//`include "processor_sequence.sv"
import uvm_pkg::*;
`uvm_analysis_imp_decl(_mon_trans)
`uvm_analysis_imp_decl(_drv_trans)

class GUVM_scoreboard extends uvm_scoreboard;
    
    // register the scoreboard in the UVM factory
    `uvm_component_utils(GUVM_scoreboard);

    //processor_transaction trans, input_trans;

    // analysis implementation ports
    uvm_analysis_imp_mon_trans #(processor_transaction,GUVM_scoreboard) Mon2Sb_port;
    uvm_analysis_imp_drv_trans #(processor_transaction,GUVM_scoreboard) Drv2Sb_port;

    // TLM FIFOs to store the actual and expected transaction values
    uvm_tlm_fifo #(processor_transaction)  drv_fifo;
    uvm_tlm_fifo #(processor_transaction)  mon_fifo;

   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      //Instantiate the analysis ports and Fifo
      Mon2Sb_port = new("Mon2Sb",  this);
      Drv2Sb_port = new("Drv2Sb",  this);
      drv_fifo     = new("drv_fifo", this,8);  //BY DEFAULT ITS SIZE IS 1 BUT CAN BE UNBOUNDED by putting 0
      mon_fifo     = new("mon_fifo", this,8);
   endfunction : build_phase

   // write_drv_trans will be called when the driver broadcasts a transaction
   // to the scoreboard
   function void write_drv_trans (processor_transaction input_trans);
        void'(drv_fifo.try_put(input_trans));
   endfunction : write_drv_trans

   // write_mon_trans will be called when the monitor broadcasts the DUT results
   // to the scoreboard 
   function void write_mon_trans (processor_transaction trans);
        void'(mon_fifo.try_put(trans));
   endfunction : write_mon_trans

   task run_phase(uvm_phase phase);
      processor_transaction exp_trans, out_trans;
      bit [31:0] h1,i1,i2,imm;
	  //bit [19:0] sign;
      forever begin
			drv_fifo.get(exp_trans);
			mon_fifo.get(out_trans);
			i1=exp_trans.RS1_data;
			i2=exp_trans.RS2_data;
			imm={{20{exp_trans.immediate_data[11]}}, exp_trans.immediate_data};  //IMMEDIATE VALUE SIGN EXTENSION
			
			
 if((exp_trans.instrn[31:30]==2'b10 && exp_trans.instrn[24:19]==6'b000000 && exp_trans.instrn[13:5]==9'b000000000) ||(exp_trans.instrn[6:0]==7'b0110011 && exp_trans.instrn[14:12]==3'b000 && exp_trans.instrn[31:25]==7'b0000000 ) || (exp_trans.instrn[24:21]==4'h4 && exp_trans.instrn[27:26]==2'b00)) //LEON/RISCY/AMBER //ADD common 
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
	  else if((exp_trans.instrn[31:30]==2'b10 && exp_trans.instrn[24:19]==6'b000000 && exp_trans.instrn[13]==1'b1) || (exp_trans.instrn[6:0]==7'b0010011 && exp_trans.instrn[14:12]==3'b000 )) //ADD IMMEDIATE INSTRUCTION
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
	  end
	  end
   endtask
endclass : GUVM_scoreboard	