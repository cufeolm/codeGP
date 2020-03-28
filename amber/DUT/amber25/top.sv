module top;

    logic i_clk; 
    GUVM_interface bfm(i_clk);
    
    a25_core dut(
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
      /*  bfm.set_UP();
        bfm.send_data(128'hF0801003F0801003F0801003E5800000, 32'h00000005);
        bfm.send_inst(128'hF0801003F0801003F0801003F0801003);
        #1000
        bfm.send_data(128'hF0801003F0801003F0801003E5802000, 32'h00000001);
        bfm.send_inst(128'hF0801003F0801003F0801003F0801003);
        #1000
        bfm.send_inst(128'hF0801003F0801003F0801003E0801002);
        #1000
        bfm.send_inst(128'hF0801003F0801003F0801003E5801000);
        #200
        bfm.receive_data();*/

        bfm.set_UP();
        bfm.send_data(32'h00000005);
        bfm.send_inst(128'hF0801003F0801003F0801003F0800003);
        #1000
        bfm.send_data(32'h00000001);
        bfm.send_inst(128'hF0801003F0801003F0801003F0802003);
        #1000
        bfm.send_inst(128'hF0801003F0801003F0801003E0801002);
        #1000
        bfm.send_inst(128'hF0801003F0801003F0801003E5801000);
        #200
        bfm.receive_data();
    end
    
    always begin
        i_clk = 0; 
        forever begin 
            #10 i_clk=~i_clk;
        end
    end


endmodule: top
