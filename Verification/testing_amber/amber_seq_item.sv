//extends the GUVM_sequence_item to specify the fields needed in the instruction format as each processor has 
//a diffreant way of dividing the fields of a 32bit instruction

class target_seq_item extends GUVM_sequence_item;

	`uvm_object_utils(target_seq_item)

	function new(string name = "");
		super.new(name);
	endfunction

	logic [3:0] cond;
	logic [3:0] opcode;
	// logic [3:0] rs1;  // rn
	// logic [3:0] rd;
	logic [3:0] rs;
	// logic [3:0] rs2;    // rm
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

	function void setup(); // sets up the fields upove based on the randomized instruction
		//GUVM_sequence_item temp;
		//$display(inst);
		//temp = get_format(inst);
		get_format();
		//$display(temp.inst);
		//$display(inst);
		//do_copy(temp);
		//$display(inst);
	endfunction

	function void storeadd();//for getting address of the register with required data to be stored 
		store_add = inst[15:12];
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
		current_pc = RHS.current_pc;
		updated_flags=RHS.updated_flags;
		zimm = RHS.zimm;
		simm = RHS.simm;	
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

	function void get_format (); 
        target_seq_item ay;
        //GUVM_sequence_item k;
        //k = new("k");
		ay = new("ay");
		ay.do_copy(this);


        ay.inst=inst;
        ay.cond = inst[31:28];
        case (inst[27:25])
            REGOP_SWAP_MULT:
                begin
                    if(inst[4] == 1'b0) 
                        begin // Data Processing (REGOP)
                            if(inst[11:7] == 5'b00000) 
                                begin // no shift
                                    ay.rs1 = inst[19:16];
                                    ay.rd = inst[15:12];
                                    ay.rs2 = inst[3:0];
                                    ay.s = inst[20];
                                end
                            else
                                begin // immediate shift
                                    ay.shift = inst[6:5];
                                    ay.shift_imm = inst[11:7];
                                    ay.rs1 = inst[19:16];
                                    ay.rd = inst[15:12];
                                    ay.rs2 = inst[3:0];
                                    ay.s = inst[20];
                                    ay.simm = {{27{inst[11]}},inst[11:7]};
				                	ay.zimm = {{27{0}},inst[11:7]}; 
                                end
                        end
                    else if(inst[7] == 1'b0)
                        begin //register shift
                            ay.rs1 = inst[19:16];
                            ay.rd = inst[15:12];
                            ay.rs2 = inst[3:0];
                            ay.s = inst[20];
                            ay.shift = inst[6:5];
                            ay.rs = inst[11:8];
                        end
                    else if (inst[24] == 1'b0)
                        begin // Multiply (MULT)
                            ay.rd = inst[19:16];
                            ay.rs = inst[15:12];
                            ay.rs1 = inst[11:8];
                            ay.rs2 = inst[3:0];
                            ay.s = inst[20];
                            ay.a = inst[21];
                        end
                    else
                        begin // Single Data Swap (SWAP)
                            ay.rs1 = inst[19:16];
                            ay.rd = inst[15:12];
                            ay.rs2 = inst[3:0];
                            ay.b = inst[22];
                        end
                end
		REGOP:	//Data Processing (REGOP)
			begin //32-bit immediate
				ay.rs1 = inst[19:16];
				ay.rd = inst[15:12];
				ay.s = inst[20];
				ay.encode_imm = inst[11:8];
				ay.imm8 = inst[7:0];
                ay.simm = {{24{inst[7]}},inst[7:0]};
                ay.zimm = {{24{0}},inst[7:0]};
			end
		TRANS_imm: // Single Data Transfer (TRANS)
			begin // immediate offset 
				ay.rs1 = inst[19:16];
				ay.rd = inst[15:12];
				ay.offset12 = inst[11:0];
				ay.p = inst[24];
				ay.u = inst[23];
				ay.b = inst[22];
				ay.w = inst[21];
				ay.l = inst[20];
                ay.simm = {{20{inst[11]}},inst[11:0]};
                ay.zimm = {{20{0}},inst[11:0]};
			end
		TRANS_reg: // Single Data Transfer (TRANS)
			begin // register offset
				ay.rs1 = inst[19:16];
				ay.rd = inst[15:12];
				ay.rs2 = inst[3:0];
				ay.p = inst[24];
				ay.u = inst[23];
				ay.b = inst[22];
				ay.w = inst[21];
				ay.l = inst[20];
				ay.shift = inst[6:5];
				ay.shift_imm = inst[11:7];
                ay.simm = {{27{inst[11]}},inst[11:7]};
                ay.zimm = {{27{0}},inst[11:7]};
			end
		MTRANS: //Block Data Transfer (MTRANS)
			begin
				ay.rs1 = inst[19:16];
				ay.register_list = inst[15:0];
				ay.p = inst[24];
				ay.u = inst[23];
				ay.s = inst[22];
				ay.w = inst[21];
				ay.l = inst[20];
			end
		BRANCH: // Branch
			begin
				ay.l = inst[24];
				ay.offset24 = inst[23:0];
                ay.simm = {{8{inst[23]}},inst[23:0]};
                ay.zimm = {{8{0}},inst[23:0]};
			end
		CODTRANS: // Coprocessor Data Transfer (CODTRANS)
			begin
				ay.rs1 = inst[19:16];
				ay.crd = inst[15:12];
				ay.cphash = inst[11:8];
				ay.offset8 = inst[7:0];
				ay.p = inst[24];
				ay.u = inst[23];
				ay.n = inst[22];
				ay.w = inst[21];
				ay.l = inst[20];
                ay.simm = {{24{inst[7]}},inst[7:0]};
                ay.zimm = {{24{0}},inst[7:0]};
			end
		COREGOP_CORTRANS_SWI:
			begin
				if(inst[24] == 1'b0)
					begin
						if (inst[4] == 1'b0)
							begin // Coprocessor Data Operation (COREGOP)
								ay.cp_opcode4 = inst[23:20];
								ay.crn = inst[19:16];
								ay.crd = inst[15:12];
								ay.cphash = inst[11:8];
								ay.cp = inst[7:5];
								ay.crm = inst[3:0];
							end
						else
							begin // Coprocessor Register Transfer (CORTRANS)
								ay.cp_opcode3 = inst[23:21];
								ay.l = inst[20];
								ay.crn = inst[19:16];
								ay.crd = inst[15:12];
								ay.cphash = inst[11:8];
								ay.cp = inst[7:5];
								ay.crm = inst[3:0];
							end
					end
				else // Software Interrupt (SWI)
					begin
						ay.ibc = inst[23:0];
					end

                    end
            endcase

           /* if(!($cast(k, ay)))
                $fatal(1, "failed to cast transaction to amber's transaction");
			return k;*/
			
			this.do_copy(ay);
    endfunction



endclass : target_seq_item