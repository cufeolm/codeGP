package riscy_package;
   import uvm_pkg::*;
`include "uvm_macros.svh"
      typedef enum logic[31:0] {
                                LSB=32'bxxxxxxxxxxxxxxxxx000xxxxx0000011,
								LSH=32'bxxxxxxxxxxxxxxxxx001xxxxx0000011,
								LUB=32'bxxxxxxxxxxxxxxxxx100xxxxx0000011,
								LUH=32'bxxxxxxxxxxxxxxxxx101xxxxx0000011,
								LW= 32'bxxxxxxxxxxxxxxxxx010xxxxx0000011,
								LUW=32'bxxxxxxxxxxxxxxxxx110xxxxx0000011,
								LDW=32'bxxxxxxxxxxxxxxxxx000xxxxx0000011,
								LSBfAs=32'b0000000xxxxxxxxxx111xxxxx0000011,
								LSHfAs=32'b0001000xxxxxxxxxx111xxxxx0000011,
								LUBfAs=32'b0100000xxxxxxxxxx111xxxxx0000011,
								LUHfAs=32'b0010100xxxxxxxxxx111xxxxx0000011,
								LWfAs=32'b0010000xxxxxxxxxx111xxxxx0000011,
								LFR=32'bxxxxxxxxxxxxxxxxx010xxxxx0000111,
								LDFR=32'bxxxxxxxxxxxxxxxxx011xxxxx0000111,
								SB=32'bxxxxxxxxxxxxxxxxx000xxxxx0100011,
								SH=32'bxxxxxxxxxxxxxxxxx001xxxxx0100011,
								SW=32'bxxxxxxxxxxxxxxxxx010xxxxx0100011,
								SD=32'bxxxxxxxxxxxxxxxxx011xxxxx0100011,
								M=32'b0000001xxxxxxxxxx000xxxxx0110011,
								Mh=32'b0000001xxxxxxxxxx010xxxxx0110011,
								Mhs=32'b0000001xxxxxxxxxx010xxxxx0110011,
								Mhu=32'b0000001xxxxxxxxxx011xxxxx0110011,
								UId=32'b0000001xxxxxxxxxx101xxxxx0110011,
								SId=32'b0000001xxxxxxxxxx100xxxxx0110011,
								Rem=32'b0000001xxxxxxxxxx110xxxxx0110011,
								Ru=32'b0000001xxxxxxxxxx110xxxxx0110011,
								A=32'b0000000xxxxxxxxxx000xxxxx0110011,
								Ai=32'bxxxxxxxxxxxxxxxxx000xxxxx0010011,
								S=32'b0100000xxxxxxxxxx000xxxxx0110011,
								BwA=32'b0000000xxxxxxxxxx111xxxxx0110011,
								BAI=32'bxxxxxxxxxxxxxxxxx111xxxxx0010011,
								BX=32'b0000000xxxxxxxxxx100xxxxx0110011,
								BXI=32'bxxxxxxxxxxxxxxxxx100xxxxx0010011,
								BO=32'b0000000xxxxxxxxxx110xxxxx0110011,
								BOI=32'bxxxxxxxxxxxxxxxxx110xxxxx0010011,
								Sll=32'b0000000xxxxxxxxxx001xxxxx0110011,
								Srl=32'b0000000xxxxxxxxxx101xxxxx0110011,
								Sra=32'b0100000xxxxxxxxxx101xxxxx0110011,
								Slli=32'b000000xxxxxxxxxxx001xxxxx0010011,
								Srli=32'b000000xxxxxxxxxxx101xxxxx0010011,
								Srai=32'b010000xxxxxxxxxxx101xxxxx0010011,
								JaL=32'bxxxxxxxxxxxxxxxxxxxxxxxxx1101111,
								JaLr=32'bxxxxxxxxxxxxxxxxx000xxxxx1100111,
								Bie=32'bxxxxxxxxxxxxxxxxx000xxxxx1100011,
								Bigtoe=32'bxxxxxxxxxxxxxxxxx101xxxxx1100011,
								Biltoe=32'bxxxxxxxxxxxxxxxxx100xxxxx1100011,
								Bigtoeu=32'bxxxxxxxxxxxxxxxxx111xxxxx1100011,
								Biltoeu=32'bxxxxxxxxxxxxxxxxx110xxxxx1100011,
								Biei=32'bxxxxxxxxxxxxxxxxx010xxxxx1100011,
								Binei=32'bxxxxxxxxxxxxxxxxx011xxxxx1100011
                            } opcode;
  
  function GUVM_sequence_item get_format (logic [31:0] inst);
	riscy_transaction ay;
	GUVM_sequence_item k;
	k = new("k");
   ay = new("ay");
	ay.opcode = inst[6:0];
		case (ay.opcode)
			7'b0110111,7'b0010111 :
					begin 
						//U-type
						ay.immb31_12 = inst[31:12];
						ay.rd = kinst[11:7];
					end
			7'b1101111 :
					begin 
						//J-type
						ay.immb20 = inst[31];
						ay.immb10_1 = inst[30:21];
						ay.immb11 = inst[20];
						ay.immb19_12 = inst[19:12];
						ay.rd = inst[11:7];
					end
			7'b1100111,7'b0000011 :
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
			7'b1110011 :
					begin
						//I-type-csr
						ay.csr = inst[31:20];
						ay.rs1 = inst[19:15];
						ay.funct3 = inst[14:12];
						ay.rd = inst[11:7];
					end
			7'b1100011 :
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
			7'b0100011 :
					begin
						//S-type
						ay.immb11_5 = inst[31:25];
						ay.rs2 = inst[24:20];
						ay.rs1 = inst[19:15];
						ay.funct3 = inst[14:12];
						ay.immb4_0 = inst[11:7];

					end
			7'b0110011 :
					begin
						//R-type
						ay.funct7 = inst[31:25];
						ay.rs2 = inst[24:20];
						ay.rs1 = inst[19:15];
						ay.funct3 = inst[14:12];
						ay.rd = inst[11:7];
					end
			end		
		if (!($cast(ay,k))) 
			$fatal(1,"failed to cast transaction to leon's transaction"); 
		return k;
	endfunction 
	
endpackage