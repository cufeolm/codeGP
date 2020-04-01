package amber_package;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	typedef enum logic[31:0] {
		LUB=32'bxxxx01xxxxxxxxxxxxxxxxxxxxxxxxxx,
		LW=32'bxxxx01xxxxxxxxxxxxxxxxxxxxxxxxxx,
		LCR=32'bxxxx110xxxxxxxxxxxxxxxxxxxxxxxxx,
		lmorfsm=32'bxxxx100xxxxxxxxxxxxxxxxxxxxxxxxx,
		lmfps=32'bxxxx100xxxxxxxxxxxxxxxxxxxxxxxxx,
		lmorPfsm=32'bxxxx100xxxxxxxxxxxxxxxxxxxxxxxxx,
		SB=32'bxxxx01xxxxx0xxxxxxxxxxxxxxxxxxxx,
		SW=32'bxxxx01xxxxxxxxxxxxxxxxxxxxxxxxxx,
		Sm=32'bxxxx100xxxx0xxxxxxxxxxxxxxxxxxxx,
		SRwM=32'bxxxx00010x00xxxxxxxx00001001xxxx,
		Sabbram=32'bxxxx00010x00xxxxxxxx00001001xxxx,
		M=32'bxxxx00000011xxxxxxxxxxxx1001xxxx,
		MA=32'bxxxx00000011xxxxxxxxxxxx1001xxxx,
		A=32'bxxxx00x0100xxxxxxxxxxxxxxxxxxxxx,
		Awc=32'bxxxx00x0101xxxxxxxxxxxxxxxxxxxxx,
		CN=32'bxxxx00x1011xxxxxxxxxxxxxxxxxxxxx,
		C=32'bxxxx00x1010xxxxxxxxxxxxxxxxxxxxx,
		S=32'bxxxx0010010xxxxxxxxxxxxxxxxxxxxx,
		Rs=32'bxxxx00x0011xxxxxxxxxxxxxxxxxxxxx,
		Swc=32'bxxxx0010110xxxxxxxxxxxxxxxxxxxxx,
		Rswc=32'bxxxx0010100xxxxxxxxxxxxxxxxxxxxx,
		BwA=32'bxxxx00x0000xxxxxxxxxxxxxxxxxxxxx,
		BAwc=32'bxxxx00x1110xxxxxxxxxxxxxxxxxxxxx,
		BX=32'bxxxx00x0001xxxxxxxxxxxxxxxxxxxxx,
		BO=32'bxxxx00x1100xxxxxxxxxxxxxxxxxxxxx,
		BTA=32'bxxxx1011xxxxxxxxxxxxxxxxxxxxxxxx,
		BAL=32'bxxxx1011xxxxxxxxxxxxxxxxxxxxxxxx,
		Mn=32'bxxxx00x1111xxxxxxxxxxxxxxxxxxxxx,
		Mov=32'bxxxx00x1101xxxxxxxxxxxxxxxxxxxxx,
		Swi=32'bxxxx1111xxxxxxxxxxxxxxxxxxxxxxxx
	} opcode;

	function GUVM_sequence_item get_format (logic [31:0] inst);
		amber_seq_item ay;
		GUVM_sequence_item k;
		k = new("k");
		ay = new("ay");
		ay.cond = inst[31:28];
		case (inst[27:25])
			3'b000 :
				begin
					if(inst[4] == 1'b0)
						begin
							if(inst[11:7] == 5'b00000)
								begin
									ay.rn = inst[19:16];
									ay.rd = inst[15:12];
									ay.rm = inst[3:0];
									ay.s = inst[20];
								end
								else
									begin
										ay.shift = inst[6:5];
										ay.shift_imm = inst[11:7];
										ay.rn = inst[19:16];
										ay.rd = inst[15:12];
										ay.rm = inst[3:0];
										ay.s = inst[20];
									end
						end
					else if (inst[7] == 1'b0)
						begin
							ay.rn = inst[19:16];
							ay.rd = inst[15:12];
							ay.rm = inst[3:0];
							ay.s = inst[20];
							ay.shift = inst[6:5];
							ay.rs = inst[11:8];
						end
					else if (inst[24] == 1'b0)
						begin
							ay.rd = inst[19:16];
							ay.rn = inst[15:12];
							ay.rs = inst[11:8];
							ay.rm = inst[3:0];
							ay.s = inst[20];
							ay.a = inst[21];
						end
					else
						begin
							ay.rn = inst[19:16];
							ay.rd = inst[15:12];
							ay.rm = inst[3:0];
							ay.b = inst[22];
						end
				end
			3'b001 :
				begin
					ay.rn = inst[19:16];
					ay.rd = inst[15:12];
					ay.s = inst[20];
					ay.encode_imm = inst[11:8];
					ay.imm8 = inst[7:0];
				end
			3'b010 :
				begin
					ay.rn = inst[19:16];
					ay.rd = inst[15:12];
					ay.offset12 = inst[11:0];
					ay.p = inst[24];
					ay.u = inst[23];
					ay.b = inst[22];
					ay.w = inst[21];
					ay.l = inst[20];
				end
			3'b011 :
				begin
					ay.rn = inst[19:16];
					ay.rd = inst[15:12];
					ay.rm = inst[3:0];
					ay.p = inst[24];
					ay.u = inst[23];
					ay.b = inst[22];
					ay.w = inst[21];
					ay.l = inst[20];
					ay.shift = inst[6:5];
					ay.shift_imm = inst[11:7];
				end
			3'b100 :
				begin
					ay.rn = inst[19:16];
					ay.register_list = inst[15:0];
					ay.p = inst[24];
					ay.u = inst[23];
					ay.s = inst[22];
					ay.w = inst[21];
					ay.l = inst[20];
				end
			3'b101 :
				begin
					ay.l = inst[24];
					au.offset24 = inst[23:0];
				end
			3'b110 :
				begin
					ay.rn = inst[19:16];
					ay.crd = inst[15:12];
					ay.cphash = inst[11:8];
					ay.offset8 = inst[7:0];
					ay.p = inst[24];
					ay.u = inst[23];
					ay.n = inst[22];
					ay.w = inst[21];
					ay.l = inst[20];
				end
			3'b111 :
				begin
					if(inst[24] == 1'b0)
						begin
							if (inst[4] == 1'b0)
								begin
									ay.cp_opcode4 = inst[23:20];
									ay.crn = inst[19:16];
									ay.crd = inst[15:12];
									ay.cphash = inst[11:8];
									ay.cp = inst[7:5];
									ay.crm = inst[3:0];
								end
							else
								begin
									ay.cp_opcode3 = inst[23:21];
									ay.l = inst[20];
									ay.crn = inst[19:16];
									ay.crd = inst[15:12];
									ay.cphash = inst[11:8];
									ay.cp = inst[7:5];
									ay.crm = inst[3:0];
								end
						end
					else
						begin
							ay.ibc = inst[23:0];
						end

				end
			end
			if (!($cast(ay,k)))
				$fatal(1,"failed to cast transaction to leon's transaction");
			return k;
			endfunction

				endpackage