//extends the GUVM_sequence_item to specify the fields needed in the instruction format as each processor has 
//a diffreant way of dividing the fields of a 32bit instruction

class target_seq_item extends GUVM_sequence_item;

	`uvm_object_utils(target_seq_item)

	function new(string name = "");
		super.new(name);
	endfunction

	logic [3:0] cond;
	logic [3:0] opcode;
	logic [3:0] rs1;  // rn
	logic [3:0] rd;
	logic [3:0] rs;
	logic [3:0] rs2;    // rm
	logic [11:0] offset12;
	logic [15:0] register_list;
	logic [23:0] offset24;
	logic [3:0] crd;
	logic [3:0] cphash;
	logic [7:0] offset8;
	logic [3:0] crm;
	logic [3:0] crn;
	logic [3:0] cp_opcode4;
	logic [2:0] cp_opcode3;
	logic [2:0] cp;
	logic [23:0] ibc;
	logic [1:0] shift;
	logic [5:0] shift_imm;
	logic [7:0] imm8;
	logic [3:0] encode_imm;
	logic i;
	logic s;
	logic a;
	logic b;
	logic p;
	logic u;
	logic w;
	logic l;
	logic n;

	function setup(); // sets up the fields upove based on the randomized instruction
		GUVM_sequence_item temp;
		//$display(inst);
		temp = get_format(inst);

		//$display(temp.inst);
		//$display(inst);
		do_copy(temp);
		//$display(inst);
	endfunction

	function void store(logic [3:0] r);//for initially storing the register file only ; not for testing the store instruction 
		ran_constrained(Store);
		inst[15:12]=r;
	endfunction

	function void load(logic [3:0] r);//for initially loading the register file only ; not for testing the laod instruction 
		ran_constrained(Load);
		inst[15:12]=r;
	endfunction


	function void do_copy(uvm_object rhs);
		target_seq_item RHS;
		assert(rhs != null) else
			$fatal(1,"Tried to copy null transaction");
		super.do_copy(rhs);
		assert($cast(RHS,rhs)) else
			$fatal(1,"Faied cast in do_copy");
		cond = RHS.cond;
		opcode = RHS.opcode;
		rd = RHS.rd;
		rs1 = RHS.rs1;
		rs = RHS.rs;
		rs2 = RHS.rs2;
		offset12 = RHS.offset12;
		register_list = RHS.register_list;
		offset24 = RHS.offset24;
		crd = RHS.crd;
		cphash = RHS.cphash;
		offset8 = RHS.offset8;
		crm = RHS.crm;
		crn = RHS.crn;
		cp_opcode4 = RHS.cp_opcode4;
		cp_opcode3 = RHS.cp_opcode3;
		cp = RHS.cp;
		ibc = RHS.ibc;
		shift = RHS.shift;
		shift_imm = RHS.shift_imm;
		imm8 = RHS.imm8;
		encode_imm = RHS.encode_imm;
		i = RHS.i;
		s = RHS.s;
		a = RHS.a;
		b = RHS.b;
		p = RHS.p;
		u = RHS.u;
		w = RHS.w;
		l = RHS.l;
		n = RHS.n;
	endfunction

endclass : target_seq_item