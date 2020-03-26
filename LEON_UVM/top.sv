module top;
   import uvm_pkg::*;
   import leon_package::*;
   import iface::*;

`include "uvm_macros.svh"

	GUVM_interface bfm();
    proc dut(
        .clk(bfm.clk),
        .rst(bfm.rst),
        .pciclk(bfm.pcirst),
        .iui(bfm.integer_unit_input),
        .iuo(bfm.integer_unit_output),
        .ico(bfm.icache_output),
        .ici(bfm.icache_input),
        .dci(bfm.dcache_input),
        .dco(bfm.dcache_output)
    );

initial begin
   uvm_config_db#(virtual GUVM_interface)::set(null, "*", "bfm", bfm);
   fill_si_array();
   run_test("GUVM_test");
end

endmodule : top

     
   