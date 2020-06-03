interface GUVM_interface(input logic i_clk);

    // logic       i_clk;
    logic       i_irq;
    logic       i_firq;
    logic       i_system_rdy;

    logic [31:0] o_wb_adr;
    logic [15:0] o_wb_sel;
    logic o_wb_we;
    logic [127:0] i_wb_dat;
    wire [127:0] o_wb_dat;
    logic o_wb_cyc;
    logic o_wb_stb;
    logic i_wb_ack;
    logic i_wb_err;

    logic [127:0] in;
    logic [127:0] out;

    logic [3:0] Rd;
    logic [3:0] indicator;
    logic [31:0] data_in;

    function void send_data(logic [31:0] data);
        data_in = data;
    endfunction

    function void send_inst(logic [127:0] inst);
        /*indicator = inst[31:28];
        Rd = inst[15:12];
        if (indicator == 4'b1111) begin
            i_wb_dat = 128'hF0801003F0801003F0801003F0801003;
            case(Rd)
                4'b0000: dut.u_execute.u_register_bank.r0 = data_in;
                4'b0001: dut.u_execute.u_register_bank.r1 = data_in;
                4'b0010: dut.u_execute.u_register_bank.r2 = data_in;
                4'b0011: dut.u_execute.u_register_bank.r3 = data_in;
                4'b0100: dut.u_execute.u_register_bank.r4 = data_in;
                4'b0101: dut.u_execute.u_register_bank.r5 = data_in;
                4'b0111: dut.u_execute.u_register_bank.r6 = data_in;
                4'b1000: dut.u_execute.u_register_bank.r6 = data_in;
                4'b1001: dut.u_execute.u_register_bank.r7 = data_in;
                default: $display("Error in SEL");
            endcase
        end else begin
            i_wb_dat = inst;
        end*/
        in = inst[31:0];
    endfunction

    /*function logic [31:0] receive_data();
        // return out[31:0];
        return dut.u_execute.u_register_bank.r15;
    endfunction*/

    function void set_Up();
        i_irq = 1'b0;
        i_firq = 1'b0;
        i_system_rdy = 1'b1;
        i_wb_ack = 1'b1;
        i_wb_err = 1'b0;
    endfunction: set_Up

endinterface: GUVM_interface