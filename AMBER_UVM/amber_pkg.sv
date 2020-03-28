package amber_package;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    typedef enum logic[31:0] {
        LW = 32'b111101101000xxxxxxxxxxxxxxxxxxxx,
        SW = 32'b111001011001xxxxxxxxxxxxxxxxxxxx,
        A  = 32'b111000001000xxxxxxxx00000000xxxx
    } opcode;

    opcode si_a[];
    integer supported_instructions;

    `include "GUVM_sequence_item.sv"
    `include "target_sequence_item.sv"
    `include "GUVM_sequence.sv"
    `include "GUVM_driver.sv"
    `include "GUVM_monitor.sv"
    `include "GUVM_scoreboard.sv"
    `include "GUVM_agent.sv"
    `include "GUVM_env.sv"
    `include "GUVM_test.sv"

    function void fill_si_array();
    // fill supported instruction array
    // this does NOT  affect generalism this makes sure you dont run
    // the same function twice in a test bench
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
                // $display("array is filled and ready to use");
        `endif
    endfunction

    function GUVM_sequence_item get_format (logic [31:0] inst);
        target_seq_item ay;
        GUVM_sequence_item k;
        k = new("k");
        ay = new("ay");
        ay.cond = inst[31:28];
        case (inst[27:25])
            3'b000:
                begin
                    if(inst[4] == 1'b0)
                        begin
                            if(inst[11:7] == 5'b00000)
                                begin
                                    ay.rs1 = inst[19:16];
                                    ay.rd = inst[15:12];
                                    ay.rs2 = inst[3:0];
                                    ay.s = inst[20];
                                end
                            else
                                begin
                                    ay.shift = inst[6:5];
                                    ay.shift_imm = inst[11:7];
                                    ay.rs1 = inst[19:16];
                                    ay.rd = inst[15:12];
                                    ay.rs2 = inst[3:0];
                                    ay.s = inst[20];
                                end
                        end
                    else if(inst[7] == 1'b0)
                        begin
                            ay.rs1 = inst[19:16];
                            ay.rd = inst[15:12];
                            ay.rs2 = inst[3:0];
                            ay.s = inst[20];
                            ay.shift = inst[6:5];
                            ay.rs = inst[11:8];
                        end
                    else if (inst[24] == 1'b0)
                        begin
                            ay.rd = inst[19:16];
                            ay.rs1 = inst[15:12];
                            ay.rs = inst[11:8];
                            ay.rs2 = inst[3:0];
                            ay.s = inst[20];
                            ay.a = inst[21];
                        end
                    else
                        begin
                            ay.rs1 = inst[19:16];
                            ay.rd = inst[15:12];
                            ay.rs2 = inst[3:0];
                            ay.b = inst[22];
                        end
                end
                3'b001:
                    begin
                        ay.rs1 = inst[19:16];
                        ay.rd = inst[15:12];
                        ay.s = inst[20];
                        ay.encode_imm = inst[11:8];
                        ay.imm8 = inst[7:0];
                    end
                3'b010:
                    begin
                        ay.rs1 = inst[19:16];
                        ay.rd = inst[15:12];
                        ay.offset12 = inst[11:0];
                        ay.p = inst[24];
                        ay.u = inst[23];
                        ay.b = inst[22];
                        ay.w = inst[21];
                        ay.l = inst[20];
                    end
                3'b011:
                    begin
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
                3'b100:
                    begin
                        ay.rs1 = inst[19:16];
                        ay.register_list = inst[15:0];
                        ay.p = inst[24];
                        ay.u = inst[23];
                        ay.s = inst[22];
                        ay.w = inst[21];
                        ay.l = inst[20];
                    end
                3'b101:
                    begin
                        ay.l = inst[24];
                        ay.offset24 = inst[23:0];
                    end
                3'b110:
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
                3'b111:
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
            endcase

            if(!($cast(k, ay)))
                $fatal(1, "failed to cast transaction to amber's transaction");
            return k;
    endfunction

endpackage