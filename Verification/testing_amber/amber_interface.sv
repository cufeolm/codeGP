interface GUVM_interface(input clk);
    import target_package::*; // importing amber core package

    // core interface ports
    logic       clk_pseudo;
    logic       i_irq;
    logic       i_firq;
    logic       i_system_rdy;

    logic [31:0] o_wb_adr;
    logic [3:0] o_wb_sel;
    logic o_wb_we;
    logic [31:0] i_wb_dat;
    logic [31:0] o_wb_dat;

    logic o_wb_cyc;
    logic o_wb_stb;
    logic i_wb_ack;
    logic i_wb_err;

    // temp. registers
    logic [3:0] Rd;
    logic [31:0] same_inst;
    logic [31:0] data_in;



    logic [31:0] next_pc=0;
    // declaring the monitor
    GUVM_result_monitor result_monitor_h;

    command_monitor command_monitor_h;

    bit allow_pseudo_clk;

    // initializing the clk_pseudo signal
    initial begin
        clk_pseudo=0;
        allow_pseudo_clk=0;
    end

    always @(clk) begin
        if (allow_pseudo_clk)begin
            clk_pseudo = clk;
        end
    end

    task toggle_clk(integer i);
        allow_pseudo_clk=1;
        repeat(i) @(posedge clk_pseudo);
        allow_pseudo_clk=0;
    endtask

    // sending data to the core
    task send_data(logic [31:0] data);
        data_in = data;
        // dcache_wb_cached_rdata = data;
    endtask

    // sending instructions to the core
    task send_inst(logic [31:0] inst);
        same_inst = inst;
        Rd = inst[15:12]; // destination register address bits: 4 bits
        $display("inst = %h", inst);
        if(inst == {16'haaaa, Rd, 12'haaa}) begin // accessing the register file by forcing
            i_wb_dat = {32'hF0800000};
            case(Rd)
                4'b0000: dut.u_execute.u_register_bank.r0 = data_in;
                4'b0001: dut.u_execute.u_register_bank.r1 = data_in;
                4'b0010: dut.u_execute.u_register_bank.r2 = data_in;
                4'b0011: dut.u_execute.u_register_bank.r3 = data_in;
                4'b0100: dut.u_execute.u_register_bank.r4 = data_in;
                4'b0101: dut.u_execute.u_register_bank.r5 = data_in;
                4'b0110: dut.u_execute.u_register_bank.r6 = data_in;
                4'b0111: dut.u_execute.u_register_bank.r7 = data_in;
                default: $display("Error in SEL");
            endcase
        end else begin
            i_wb_dat = inst;
        end
    endtask

    function void update_command_monitor(GUVM_sequence_item cmd);
        command_monitor_h.write_to_cmd_monitor(cmd);
    endfunction

    task update_result_monitor();
        // result_monitor_h.write_to_monitor(o_wb_dat, next_pc);
        /*if(same_inst == {{16'haaaa}, {Rd}, {12'haaa}}) begin
            o_wb_dat=0;
            result_monitor_h.write_to_monitor(o_wb_dat, next_pc);
        end else begin
            result_monitor_h.write_to_monitor(o_wb_dat, next_pc);
        end*/
        if(o_wb_we==1)
            result_monitor_h.write_to_monitor(o_wb_dat, o_wb_adr,o_wb_sel);
        else
            result_monitor_h.write_to_monitor(0,0,o_wb_sel);
    endtask

    function logic[31:0] get_cpc();
        $display("current_pc = %h       %t", dut.u_execute.u_register_bank.o_pc, $time);
        return dut.u_execute.u_register_bank.o_pc;
    endfunction

    // initializing the core
    task set_Up();
        i_irq = 1'b0;
        i_firq = 1'b0;
        i_system_rdy = 1'b1;
        i_wb_ack = 1'b1;
        i_wb_err = 1'b0;
    endtask: set_Up

    task reset_dut();
        i_irq = 1'b0;
        i_firq = 1'b0;
        i_system_rdy = 1'b1;
        i_wb_ack = 1'b1;
        i_wb_err = 1'b0;
        i_wb_dat = {32'h00000000};
        dut.u_execute.u_register_bank.r0 = 32'd0;
        dut.u_execute.u_register_bank.r1 = 32'd0;
        dut.u_execute.u_register_bank.r2 = 32'd0;
        dut.u_execute.u_register_bank.r3 = 32'd0;
        dut.u_execute.u_register_bank.r4 = 32'd0;
        dut.u_execute.u_register_bank.r5 = 32'd0;
        dut.u_execute.u_register_bank.r6 = 32'd0;
        dut.u_execute.u_register_bank.r7 = 32'd0;
        dut.u_execute.u_register_bank.r8 = 32'd0;
        dut.u_execute.u_register_bank.r9 = 32'd0;
        dut.u_execute.u_register_bank.r10 = 32'd0;
        dut.u_execute.u_register_bank.r11 = 32'd0;
        dut.u_execute.u_register_bank.r12 = 32'd0;
        dut.u_execute.u_register_bank.r13 = 32'd0;
        dut.u_execute.u_register_bank.r14 = 32'd0;
        dut.u_execute.u_register_bank.r15 = 0;
        //force dut.u_execute.u_register_bank.i_mode_idec
        // force dut.cache_flush = 1;
        // toggle_clk(2);
        // force dut.cache_flush = 0;
        toggle_clk(5);
        // release dut.cache_flush;
        // amber does not have a reset signal in the core interface
    endtask : reset_dut

endinterface: GUVM_interface
