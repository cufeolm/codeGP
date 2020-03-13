interface GUVM_interface;
    import iface::*;
    // import GUVM_classes_pkg::*;
    bit       clk;
    bit       rst;
    bit       pciclk;
    bit       pcirst;
    iu_in_type integer_unit_input; // to the core
    iu_out_type integer_unit_output; // from the core
    icache_out_type icache_output; // to the core
    dcache_out_type dcache_output; // to the core
    icdiag_in_type dcache_output_inside; // inside dcache_out_type package

    initial begin
        clk = 0;
        #10;
        clk = 1;
        #10;
    end

    task reset_dut();
        rst = 1'b0;
        repeat (10) begin
            @(negedge clk);
        end
            rst = 1'b1;
    endtask : reset_dut

    task input_inst (logic [31:0] inst);
        icache_output.data = inst;
    endtask : input_inst

    function automatic logic [31:0] OUTPUT_DATA(
        ref logic [31:0] idata,
        ref logic [31:0] wdata,
        ref logic [31:0] instr,
        ref logic [31:0] addr);  

        idata = data_rdata_i;
        wdata = data_wdata_o;
        instr = icache_output.data;
        addr = data_addr_o;
        
    endfunction : OUTPUT_DATA 

    function void setup_data();
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

    endfunction: setup_data

endinterface: GUVM_interface