interface GUVM_interface;

    logic       i_clk;
    logic       i_irq;
    logic       i_firq;
    logic       i_system_rdy;

    logic [31:0] o_wb_adr;
    logic [15:0] o_wb_sel;
    logic o_wb_we;
    logic [127:0] i_wb_dat;
    logic [127:0] o_wb_dat;
    logic o_wb_cyc;
    logic o_wb_stb;
    logic i_wb_ack;
    logic i_wb_err;

    logic [3:0] Rd;
    logic [3:0] indicator;
    logic [31:0] data_in;

    initial begin
       i_clk = 0;
    end 

    task send_data(logic [31:0] data);
        data_in = data;
    endtask

    task send_inst(logic [31:0] inst);
        indicator = inst[31:28];
        Rd = inst[15:12];
        if (indicator == 4'b1111) begin
            i_wb_dat = {96'hF0801003F0801003F0801003, inst};
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
            i_wb_dat[31:0] = inst;
            i_wb_dat[127:32] = 96'hF0801003F0801003F0801003;
        end
    endtask

    function logic [127:0] receive_data();
        $display("result: %h", o_wb_dat);
        return o_wb_dat;
    endfunction

    task verify_inst(logic [31:0] inst);
        repeat(2*50) #10 i_clk=~i_clk;
        send_inst(inst) ; 
    endtask

    task setup_data();
        i_irq = 1'b0;
        i_firq = 1'b0;
        i_system_rdy = 1'b1;
        i_wb_ack = 1'b1;
        i_wb_err = 1'b0;
    endtask:setup_data

endinterface: GUVM_interface
