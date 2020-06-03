//extends the GUVM_sequence_item to specify the fields needed in the instruction format as each processor has 
//a diffreant way of dividing the fields of a 32bit instruction

import uvm_pkg::*;
`include "uvm_macros.svh"
class target_seq_item extends GUVM_sequence_item;

	`uvm_object_utils(target_seq_item)
	logic [1:0]op;
	logic [29:0]disp30;
	//logic [4:0]rd;
	logic [2:0]op2;
	logic [21:0]imm22;
	logic a;
	logic [3:0]cond;
	logic [21:0]disp22;
	logic [5:0]op3;
	//logic [4:0]rs1;
	logic i;		
	logic [7:0]asi;
	//logic [4:0]rs2;
	logic [12:0]imm13;
	logic [8:0]opf;

	parameter rd_upper_bit = 29 ;
	parameter rd_lower_bit = 25 ;

	function void store(logic [4:0] r);//for initially storing the register file only ; not for testing the store instruction 
		ran_constrained(Store);
		inst[29:25]=r;
	endfunction

	function void storeadd();//for getting address of the register with required data to be stored 
		store_add = inst[29:25];
	endfunction

	function void load(logic [4:0] r);//for initially loading the register file only ; not for testing the laod instruction 
		ran_constrained(Load);
		inst[29:25]=r;
	endfunction
	function new (string name = "");
		super.new(name);
	endfunction
	//function ran();
	//	super.ran();
	//endfunction 
	function void setup();// sets up the fields upove based on the randomized instruction
		//GUVM_sequence_item temp;
		//target_seq_item leon ;
		//temp = get_format(inst);
		//temp.data = data ; 
		//if (!($cast(leon,temp))) 
		//$fatal(1,"failed to cast transaction to leon's transaction"); 
		//do_copy(temp);
		get_format();
	endfunction

	function void do_copy(uvm_object rhs);
		target_seq_item RHS;
		assert(rhs != null) else
		  $fatal(1,"Tried to copy null transaction");
		super.do_copy(rhs);
		assert($cast(RHS,rhs)) else
		  $fatal(1,"Faied cast in do_copy");
		  op = RHS.op;
		  disp30 = RHS.disp30;
		  rd = RHS.rd;
		  op2= RHS.op2;
		  imm22=RHS.imm22;
		  a=RHS.a;
		  cond=RHS.cond;
		  disp22=RHS.disp22;
		  op3=RHS.op3;
		  rs1=RHS.rs1;
		  i=RHS.i;
		  asi=RHS.asi;
		  rs2=RHS.rs2;
		  imm13=RHS.imm13;
		  opf=RHS.opf;
	 endfunction : do_copy

	 function string convert2string();
		string            s;
		s = $sformatf(
		"/n op=%b,op2=%b,op3=%b,rd=%b,rs1=%b,rs2=%b,i=%b,a=%b /n 
		imm13=%h,imm22=%h ",
					  op,op2,op3,rd,rs1,rs2,i,a,imm13,imm22);
		return {super.convert2string(),s};
	 endfunction : convert2string

	 
    // function to determine format of verfied instruction and fill its operands
	 function void get_format ();
		target_seq_item ay;
		//logic [31:0] inst;
        //GUVM_sequence_item k ;
        //k = new("k");
		ay = new("ay");
		ay.do_copy(this);
		//k.do_copy(this);
		//inst = this.inst ; 
        //ay.inst=inst;
        ay.op = inst[31:30];
        case (ay.op)
            CALL :
                //call format1
                ay.disp30 = inst[29:0];
            SETHI_NOP_BRANCH : begin
                ay.op2 = inst[24:22];
                case (ay.op2)
                    3'b100,3'b000 :
                        //sethi & no op & unimplemnted format 2
                        begin
                            ay.rd = inst[29:25];
                            ay.imm22 = inst[21:0];
                            ay.simm = {{10{inst[21]}},inst[21:0]};
                            ay.zimm = {{10{0}},inst[21:0]};
                        end
                    3'b010, 3'b110, 3'b111 :
                        //branch & fp branch & co branch format 2
                        begin
                            ay.a = inst[29];
                            ay.cond = inst[28:25];
                            ay.disp22 = inst[21:0];
                            ay.simm = {{10{inst[21]}},inst[21:0]};
							ay.zimm = {{10{0}},inst[21:0]};
                        end
                    default: uvm_report_error("k.instruction", "k.instruction format not defined");
                endcase
            end
            Remaining_instructions, Remaining_instructions1 : begin
                ay.i = inst[13];
                ay.rd = inst[29:25];
                ay.op3 = inst[24:19];
                ay.rs1 = inst[18:14];
                if (!ay.i)
                    //format 3 register register
                    begin
                        ay.asi = inst[12:5];
                        ay.rs2 = inst[4:0];
                    end
                else
                    //format 3 register immediate
                    begin
                        ay.imm13 = inst[12:0];
                        ay.simm = {{19{inst[12]}},inst[12:0]};
                        ay.zimm = {{19{0}},inst[12:0]};
                    end

            end
            default: uvm_report_error("k.instruction", "k.instruction format not defined");
        endcase

        /*if (!($cast(k,ay)))
            $fatal(1,"failed to cast transaction to leon's transaction");
		return k;*/
		this.do_copy(ay);
    endfunction




endclass : target_seq_item