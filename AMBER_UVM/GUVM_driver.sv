class GUVM_driver extends uvm_driver #(GUVM_sequence_item);
    `uvm_component_utils(GUVM_driver)

    virtual GUVM_interface bfm;

    uvm_analysis_port #(GUVM_sequence_item) Drv2Sb_port;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        // Get interface reference from config database
        if(!uvm_config_db#(virtual GUVM_interface)::get(this, "", "bfm", bfm)) begin
            `uvm_error("", "uvm_config_db::get failed")
        end
        Drv2Sb_port = new("Drv2Sb",this);
    endfunction

    task run_phase(uvm_phase phase);
        GUVM_sequence_item cmd;
        forever begin : cmd_loop
            //first load
            seq_item_port.get_next_item(cmd);
            $display("driver starts");
            bfm.setup_data();
            $display("driver is fetching");
            $display("driver is fetshing the first load");
            $display("inst = %b %b %b %b %b", cmd.inst[31:28], cmd.inst[27:20], cmd.inst[19:16], cmd.inst[15:12], cmd.inst[11:0]);
            $display("rs1 address = %0d and data = %0d", cmd.inst[15:12], cmd.data);  // rd addres
            bfm.send_inst(cmd.inst);
            bfm.send_data(cmd.data);
            seq_item_port.item_done();
            //second load
            seq_item_port.get_next_item(cmd);
            $display("driver is fetshing the second load");
            $display("inst = %b %b %b %b %b", cmd.inst[31:28], cmd.inst[27:20], cmd.inst[19:16], cmd.inst[15:12], cmd.inst[11:0]);
            $display("rs2 address = %0d and data = %0d", cmd.inst[15:12], cmd.data);  // rd addres
            bfm.send_inst(cmd.inst);
            bfm.send_data(cmd.data);
            seq_item_port.item_done();
            //instruction to be verified
            seq_item_port.get_next_item(cmd);
            $display("drive is fetching the instruction");
            $display("inst is %b %b %b %b %b %b %b %b", cmd.inst[31:28], cmd.inst[27:26], cmd.inst[25], cmd.inst[24:21], cmd.inst[20], cmd.inst[19:16], cmd.inst[15:12], cmd.inst[11:4], cmd.inst[3:0]);
            $display("rs1 address = %0d and rs2 address = %0d and rd address = %0d", cmd.inst[19:16], cmd.inst[3:0], cmd.inst[15:12]);
            bfm.verify_inst(cmd.inst);
            seq_item_port.item_done();
            //store result
            seq_item_port.get_next_item(cmd);
            $display("driver is fetshing the result");
            $display("inst = %b %b %b %b %b", cmd.inst[31:28], cmd.inst[27:20], cmd.inst[19:16], cmd.inst[15:12], cmd.inst[11:0]);
            $display("rd address = %0d", cmd.inst[15:12]);
            bfm.send_inst(cmd.inst);
            bfm.receive_data();
            seq_item_port.item_done();
        end : cmd_loop
    endtask : run_phase

endclass : GUVM_driver
