module top;

    logic i_clk; 
    GUVM_interface bfm(i_clk);
    a23_core dut(
        .i_clk(bfm.i_clk),
        .i_irq(bfm.i_irq),
        .i_firq(bfm.i_firq),
        .i_system_rdy(bfm.i_system_rdy),
        .i_wb_dat(bfm.i_wb_dat),
        .o_wb_dat(bfm.o_wb_dat),
        .o_wb_adr(bfm.o_wb_adr),
        .o_wb_sel(bfm.o_wb_sel),
        .i_wb_ack(bfm.i_wb_ack),
        .i_wb_err(bfm.i_wb_err),
        .o_wb_cyc(bfm.o_wb_cyc),
        .o_wb_stb(bfm.o_wb_stb),
        .o_wb_we(bfm.o_wb_we)
    );




    initial begin
      

        bfm.setup_data();
        bfm.send_data(32'h00000005);
        bfm.send_inst(32'hF0800003); //r0
        #20
        bfm.send_data(32'h00000002); 
        bfm.send_inst(32'hF0801003); //r1
        #20
       // bfm.send_inst(32'hE0802001); // r2
        //#20
        bfm.send_inst(32'hEA00000a); // branch
        #20
        bfm.send_inst(32'hF0023091); // nop
        #20
        bfm.send_inst(32'hF5801000);
        #100
        bfm.receive_data();
        $display("output=%0d",bfm.receive_data());
    end
    
    always begin
        i_clk = 0; 
        forever begin 
            #10 i_clk=~i_clk;
        end
    end


endmodule: top
