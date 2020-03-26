`timescale 10ns/1ns
`include "uvm_macros.svh"
`include "GUVM_testbench_pkg.sv"

module top;
    import uvm_pkg::*;
    import GUVM_testbench_pkg::*;

    bit clk;

    //clock generation
    always #10 clk = ~clk;

    initial begin
        clk = 0;
    end

    // Instantiate the interface
    GUVM_interface processor_if(clk);
    // Instantiate dut
        //AMBER 
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
        // Place the interface into the UVM configuration database
        fill_si_array( ); // what is that?!
        uvm_config_db#(virtual GUVM_interface)::set(null, "*", "processor_vif", processor_if);
        // Start the test
        run_test();
    end

    initial begin
        $vcdpluson();
    end

endmodule
