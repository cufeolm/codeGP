
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
	//logic [4:0]rs2;
	//logic [4:0]rs1;
	logic [2:0]funct3;
	//logic [4:0]rd;
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

	function void storeadd();//for getting address of the register with required data to be stored 
		store_add = inst[24:20];
	endfunction

	function void load(logic [4:0] r);//for initially loading the register file only ; not for testing the laod instruction 
		ran_constrained(Load);
		inst[11:7]=r;
	endfunction

	function void setup();// sets up the fields upove based on the randomized instruction
		//GUVM_sequence_item temp;
		//target_seq_item leon ;
		//temp = get_format(inst);
		//if (!($cast(leon,temp))) 
		//$fatal(1,"failed to cast transaction to leon's transaction"); 
		//$display("before :simm= %h simm= %b",temp.simm,temp.simm);
		//do_copy(temp);
		//$display("after :simm= %h simm= %b",simm,simm);
		get_format();
	endfunction

	function void do_copy(uvm_object rhs);
		target_seq_item RHS;
		assert(rhs != null) else
		    $fatal(1,"Tried to copy null transaction");
		super.do_copy(rhs);
		assert($cast(RHS,rhs)) else
	  		$fatal(1,"Failed cast in do_copy");
			current_pc = RHS.current_pc;
			updated_flags =RHS.updated_flags;
			zimm = RHS.zimm;
			simm = RHS.simm;
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
	function void get_format ();
		target_seq_item ay;
		//GUVM_sequence_item k;
		//k = new("k");
		
		ay = new("ay");
		ay.do_copy(this);
		//ay.inst = inst;
		ay.opcode = inst[6:0];
		case(ay.opcode)
			U_type, U_type1:
				begin
					//U-type
					ay.immb31_12 = inst[31:12];
					ay.rd = inst[11:7];
					ay.simm = {inst[31:12],{12{0}}}; // they are shifted 12 bit to left as in ISA
					ay.zimm = {inst[31:12],{12{0}}}; // they are shifted 12 bit to left as in ISA
				end
			J_type:
				begin
					//J-type
					ay.immb20 = inst[31];
					ay.immb10_1 = inst[30:21];
					ay.immb11 = inst[20];
					ay.immb19_12 = inst[19:12];
					ay.rd = inst[11:7];
					ay.simm = {{12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0};
					ay.zimm = {{12{0}},inst[31],inst[20:12],inst[20],inst[30:21]};
				end
			I_type, I_type1:
				begin
					if (inst[14:12] == 3'b111)
					begin
						//load R-type in riscy extensions
						ay.funct7 = inst[31:25];
						ay.rs2 = inst[24:20];
						ay.rs1 = inst[19:15];
						ay.funct3 = inst[14:12];
						ay.rd = inst[11:7];
					end
					else
					begin
						//I-type
						ay.immb11_0 = inst[31:20];
						ay.rs1 = inst[19:15];
						ay.funct3 = inst[14:12];
						ay.rd = inst[11:7];
						ay.simm = {{20{inst[31]}},inst[31:20]};
						ay.zimm = {{20{0}},inst[31:20]};
					end
				end
			I_type_shift:
				begin
					if ( (inst[14:12] == 3'b001) || (inst[14:12] == 3'b101))
						begin
							//I-type-shift
							ay.funct7 = inst[31:25];
							ay.shamt = inst[24:20];
							ay.rs1 = inst[19:15];
							ay.funct3 = inst[14:12];
							ay.rd = inst[11:7];
						end
						else
							begin
								//I-type
								ay.immb11_0 = inst[31:20];
								ay.rs1 = inst[19:15];
								ay.funct3 = inst[14:12];
								ay.rd = inst[11:7];
								ay.simm = {{20{inst[31]}},inst[31:20]};
								ay.zimm = {{20{0}},inst[31:20]};
							end
				end
			I_type_fence:
				begin
					//I-type-fence
					ay.pred = inst[27:24];
					ay.succ = inst[23:20];
				end
			I_type_csr:
				begin
					//I-type-csr
					ay.csr = inst[31:20];
					ay.rs1 = inst[19:15];
					ay.funct3 = inst[14:12];
					ay.rd = inst[11:7];
				end
			B_type:
				begin
					//B-type
					ay.rs1 = inst[19:15];
					ay.funct3 = inst[14:12];
					ay.immb12 = inst[31];
					ay.immb10_5 = inst[30:25];
					ay.rs2 = inst[24:20];
					ay.immb4_1 = inst[11:8];
					ay.immb11 = inst[7];
					ay.simm = {{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0};
					ay.zimm = {{20{0}},inst[31],inst[7],inst[30:25],inst[11:8]};
				end
			S_type:
				begin
					//S-type
					ay.immb11_5 = inst[31:25];
					ay.rs2 = inst[24:20];
					ay.rs1 = inst[19:15];
					ay.funct3 = inst[14:12];
					ay.immb4_0 = inst[11:7];
					ay.simm = {{20{inst[31]}},inst[31:25],inst[11:7]};
					ay.zimm = {{20{0}},inst[31:25],inst[11:7]};
				end
			R_type:
				begin
					//R-type
					ay.funct7 = inst[31:25];
					ay.rs2 = inst[24:20];
					ay.rs1 = inst[19:15];
					ay.funct3 = inst[14:12];
					ay.rd = inst[11:7];
				end
		endcase // ay.opcode
		//if(!($cast(k,ay)))	$fatal(1, "failed to cast transaction to riscy's transaction");
		//return k;
		this.do_copy(ay);
	endfunction

	

endclass : target_seq_item