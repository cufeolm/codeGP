interface GUVM_interface(input clk);
    import iface::*;
    // import GUVM_classes_pkg::*;
    logic       clk;
    logic       rst;
    logic       pciclk;
    logic       pcirst;
    iu_in_type integer_unit_input; // to the core
    iu_out_type integer_unit_output; // from the core
    icache_out_type icache_output; // to the core
    dcache_out_type dcache_output; // to the core
    icdiag_in_type dcache_output_inside; // inside dcache_out_type package

    logic [31:0] inst;
    logic [31:0] out;

    initial begin
        ////////////// da mkan elsetup function //////////////////
        pciclk = 1'b0;
        pcirst = 1'b0;

        // iui
        integer_unit_input.irl = 4'b0000;

        // ico
        // icache_output.data = 32'h8E00C002;
        icache_output.exception = 1'b0;
        icache_output.hold = 1'b1;
        icache_output.flush = 1'b0; 
        icache_output.diagrdy = 1'b0;
        icache_output.diagdata = 32'h00000000; 
        icache_output.mds = 1'b0;

        // dco
        dcache_output.data = 32'h13; // Data bus address
        dcache_output.mexc = 1'b0; // memory exception
        dcache_output.hold = 1'b1;
        dcache_output.mds = 1'b0;
        dcache_output.werr = 1'b0; // memory write error
        dcache_output_inside.enable = 32'h0;
        dcache_output_inside.enable = 1'b0;
        dcache_output_inside.read = 1'b0;
        dcache_output_inside.tag = 1'b0;
        dcache_output_inside.flush = 1'b0;
    end

    clocking driver_cb @ (negedge clk);
        output inst;
    endclocking : driver_cb

    always @ (negedge clk) begin
        icache_output.data = inst;
        out = icache_output.dat;
    end

    clocking monitor_cb @ (negedge clk);
        input out;
        // lessa b2eet el7agat 
    endclocking : monitor_cb

    modport driver_if_mp (clocking driver_cb);
    modport monitor_if_mp (clocking monitor_cb);

    ////////////// elclock generation hatkoon fe eltop ///////////////////
    // always #5 clk = ~clk;
    // initial begin
    //     clk = 0;
    // end

    /*
    initial begin
        clk = 0;
        #10;
        clk = 1;
        #10;
    end
    */

    task reset_dut();
        rst = 1'b0;
        repeat (10) begin
            @(negedge clk);
        end
            rst = 1'b1;
    endtask : reset_dut

endinterface: GUVM_interface