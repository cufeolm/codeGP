class driver extends uvm_driver #(GUVM_sequence_item);
    `uvm_component_utils(driver)
    import GUVM_classes_pkg::*; // has GUVM_sequence

    virtual GUVM_interface bfm;

    uvm_analysis_port #(GUVM_sequence_item) Drv2Sb_port;

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    bit drv_clk;

    function void build_phase(uvm_phase phase);
        // Get interface reference from config database
        if(!uvm_config_db #(virtual GUVM_bfm)::get(this, "", "bfm", bfm)) begin
            `uvm_error("", "uvm_config_db::get failed")
        end
        drv_clk = 1'b0;
        Drv2Sb_port = new("Drv2Sb",this);
    endfunction

    task run_phase(uvm_phase phase);
        GUVM_sequence_item cmd;
        bfm.reset_dut();
        forever begin
            @(bfm.driver_if_mp.driver_cb)
                begin
                    seq_item_port.get_next_item(cmd);
                    bfm.driver_if_mp.driver_cb.inst_in <= cmd.instrn;
                    Drv2Sb_port.write(cmd.elrandom_data);
                    seq_item_port.item_done();
                end
        end
    endtask : run_phase

endclass : driver