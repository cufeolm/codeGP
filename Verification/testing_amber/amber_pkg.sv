package target_package;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // instructions opcodes verified in this core 
    typedef enum logic[31:0] { 
        LW = 32'b111101101001xxxxxxxxxxxxxxxxxxxx,
        SW = 32'b111001011000xxxxxxxxxxxxxxxxxxxx,
        A  = 32'b1110000010000xxx0xxx000000000xxx,
        Store = 32'b11100101100000000xxx000000000000,
        Load =  32'b1111011010010xxx0xxx000000000xxx 
    } opcode; 
    // mutual instructions between cores have the same name so we can verify all cores using one scoreboard
    
    opcode si_a[];  // opcodes array to store enums so we can randomize and use them
    integer supported_instructions; // number of instructions in the array
    `include "amber_defines.sv"
    `include "GUVM.sv"   // including GUVM classes 
    

    // fill supported instruction array
    function void fill_si_array();
    // this does NOT affect generalism
        `ifndef SET_UP_INSTRUCTION_ARRAY
        `define SET_UP_INSTRUCTION_ARRAY
            opcode si_i; // for iteration only
            supported_instructions = si_i.num();
            si_a = new[supported_instructions];

            si_i = si_i.first();
            for(integer i=0; i < supported_instructions; i++)
                begin
                    si_a[i] = si_i;
                    si_i = si_i.next();
                end
        `endif
    endfunction


    // function to determine format of verfied instruction and fill its operands
    function GUVM_sequence_item get_format (logic [31:0] inst); 
        target_seq_item ay;
        GUVM_sequence_item k;
        k = new("k");
        ay = new("ay");
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
                            ay.rs1 = inst[15:12];
                            ay.rs = inst[11:8];
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

            if(!($cast(k, ay)))
                $fatal(1, "failed to cast transaction to amber's transaction");
            return k;
    endfunction


    // used in if conditions to compare between (x) and (1 or 0)
    function bit xis1 (logic[31:0] a,logic[31:0] b); 
        logic x;
        x = (a == b);
        if (x === 1'bx)
            begin
                return 1'b1;
            end
        else
            begin
                return 1'b0;
            end
    endfunction: xis1

endpackage