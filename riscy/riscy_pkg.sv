package target_package;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	typedef enum logic[31:0] {
		LW = 32'bxxxxxxxxxxxxxxxxx010xxxxx0000011,
		A = 32'b0000000xxxxxxxxxx000xxxxx0110011,
		SW = 32'bxxxxxxxxxxxxxxxxx010xxxxx0100011,
		Store =32'b0000000xxxxx00000010000000100011,
        Load = 32'b00000000000000000010xxxxx0000011
	} opcode;


	opcode si_a []; 
	opcode reg_instruction;
    integer supported_instructions; 

    //includes
	`include "GUVM.sv"
   

	function void fill_si_array();// fill supported instruction array
		// this does NOT  affect generalism this makes sure you dont run
		// the same function twice in a test bench
		`ifndef SET_UP_INSTRUCTION_ARRAY
		`define SET_UP_INSTRUCTION_ARRAY
			opcode si_i ; // for iteration only
			supported_instructions = si_i.num();
			si_a = new [supported_instructions];
			si_i = si_i.first();
			for(integer i=0; i<supported_instructions; i++) begin
				si_a[i] = si_i;
				si_i = si_i.next();
			end
			//$display("array is filled and ready to use");
		`endif
	endfunction

	function GUVM_sequence_item get_format (logic [31:0] inst);
		target_seq_item ay;
		GUVM_sequence_item k;
		k = new("k");
		ay = new("ay");
		ay.inst = inst;
		ay.opcode = inst[6:0];
		case(ay.opcode)
			7'b0110111, 7'b0010111:
				begin
					//U-type
					ay.immb31_12 = inst[31:12];
					ay.rd = inst[11:7];
				end
			7'b1101111:
				begin
					//J-type
					ay.immb20 = inst[31];
					ay.immb10_1 = inst[30:21];
					ay.immb11 = inst[20];
					ay.immb19_12 = inst[19:12];
					ay.rd = inst[11:7];
				end
			7'b1100111, 7'b0000011:
				begin
					//I-type
					ay.immb11_0 = inst[31:20];
					ay.rs1 = inst[19:15];
					ay.funct3 = inst[14:12];
					ay.rd = inst[11:7];
				end
			7'b0010011:
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
							end
				end
			7'b0001111:
				begin
					//I-type-fence
					ay.pred = inst[27:24];
					ay.succ = inst[23:20];
				end
			7'b1110011:
				begin
					//I-type-csr
					ay.csr = inst[31:20];
					ay.rs1 = inst[19:15];
					ay.funct3 = inst[14:12];
					ay.rd = inst[11:7];
				end
			7'b1100011:
				begin
					//B-type
					ay.rs1 = inst[19:15];
					ay.funct3 = inst[14:12];
					ay.immb12 = inst[31];
					ay.immb10_5 = inst[30:25];
					ay.rs2 = inst[24:20];
					ay.immb4_1 = inst[11:8];
					ay.immb11 = inst[7];
				end
			7'b0100011:
				begin
					//S-type
					ay.immb11_5 = inst[31:25];
					ay.rs2 = inst[24:20];
					ay.rs1 = inst[19:15];
					ay.funct3 = inst[14:12];
					ay.immb4_0 = inst[11:7];

				end
			7'b0110011:
				begin
					//R-type
					ay.funct7 = inst[31:25];
					ay.rs2 = inst[24:20];
					ay.rs1 = inst[19:15];
					ay.funct3 = inst[14:12];
					ay.rd = inst[11:7];
				end
		endcase // ay.opcode
		if(!($cast(k,ay)))
			$fatal(1, "failed to cast transaction to riscy's transaction");
		return k;
	endfunction

endpackage