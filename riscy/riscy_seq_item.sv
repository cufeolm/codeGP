
//extends the GUVM_sequence_item to specify the fields needed in the instruction format as each processor has 
//a diffreant way of dividing the fields of a 32bit instruction

import uvm_pkg::*;
`include "uvm_macros.svh"

class target_seq_item extends GUVM_sequence_item;
	`uvm_object_utils(target_seq_item)
	  
	function new (string name = "");
		super.new(name);
	endfunction

	logic [6:0]funct7;
	logic [4:0]rs2;
	logic [4:0]rs1;
	logic [2:0]funct3;
	logic [4:0]rd;
	logic [6:0]opcode;
	logic [11:0]immb11_0;
	logic [6:0]immb11_5;
	logic [4:0]immb4_0;
	logic immb11;
	logic [3:0]immb4_1;
	logic [5:0]immb10_5;
	logic immb12;
	logic [19:0]immb31_12;
	logic [7:0]immb19_12;
	logic [9:0]immb10_1;
	logic immb20;
	logic [4:0]shamt;
	logic [3:0]pred;
	logic [3:0]succ;
	logic [11:0]csr;

	function void store(logic [4:0] r);//for initially storing the register file only ; not for testing the store instruction 
		ran_constrained(Store);
		inst[24:20]=r;
	endfunction

	function void load(logic [4:0] r);//for initially loading the register file only ; not for testing the laod instruction 
		ran_constrained(Load);
		inst[11:7]=r;
	endfunction

	function void setup();// sets up the fields upove based on the randomized instruction
		GUVM_sequence_item temp;
		//target_seq_item leon ;
		temp = get_format(inst);
		//if (!($cast(leon,temp))) 
		//$fatal(1,"failed to cast transaction to leon's transaction"); 
		do_copy(temp);
	endfunction

	function void do_copy(uvm_object rhs);
		target_seq_item RHS;
		assert(rhs != null) else
		    $fatal(1,"Tried to copy null transaction");
		super.do_copy(rhs);
		assert($cast(RHS,rhs)) else
	  		$fatal(1,"Faied cast in do_copy");
	  		funct7 = RHS.funct7;
			rs2 = RHS.rs2;
			rs1 = RHS.rs1;
			funct3 = RHS.funct3;
			rd = RHS.rd;
			opcode = RHS.opcode;
			immb11_0 = RHS.immb11_0;
			immb11_5 = RHS.immb11_5;
			immb4_0 = RHS.immb4_0;
			immb11 = RHS.immb11;
			immb4_1 = RHS.immb4_1;
			immb10_5 = RHS.immb10_5;
			immb12 = RHS.immb12;
			immb31_12 = RHS.immb31_12;
			immb19_12 = RHS.immb19_12;
			immb10_1 = RHS.immb10_1;
			immb20 = RHS.immb20;
			shamt = RHS.shamt;
			pred = RHS.pred;
			succ = RHS.succ;
			csr = RHS.csr;
	 endfunction : do_copy

	/*function string convert2string();
		string s;
		s = $sformatf(
		"/n op=%b,op2=%b,op3=%b,rd=%b,rs1=%b,rs2=%b,i=%b,a=%b /n 
		imm13=%h,imm22=%h ",
		op, op2, op3, rd, rs1, rs2, i, a, imm13, imm22);
		return {super.convert2string(),s};
	endfunction : convert2string*/
	

endclass : target_seq_item