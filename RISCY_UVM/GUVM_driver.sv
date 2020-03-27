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
            $display("driver have started");
            bfm.reset_dut();
            bfm.setup_data();
            $display("driver starting fetching");
            //first load
            seq_item_port.get_next_item(cmd);
            $display("driver starting fetching");
            $display("inst is: %b %b %b %b %b", cmd.inst[31:20], cmd.inst[19:15], cmd.inst[14:12], cmd.inst[11:7], cmd.inst[6:0]);
            $display("rs1 address = %0d and data = %0d", cmd.inst[19:15], cmd.data);
            bfm.send_inst(cmd.inst); 
            bfm.send_data(cmd.data);
            seq_item_port.item_done();

            //second load
            seq_item_port.get_next_item(cmd);
            $display("driver second load fetch");
            $display("inst is: %b %b %b %b %b", cmd.inst[31:20], cmd.inst[19:15],cmd.inst[14:12],cmd.inst[11:7],cmd.inst[6:0]);
            $display("rs1 address = %0d and data = %0d", cmd.inst[19:15], cmd.data);
            bfm.send_inst(cmd.inst);
            bfm.send_data(cmd.data);
            seq_item_port.item_done();

            //instruction to be verified
            seq_item_port.get_next_item(cmd);
            $display("driver instruction fetch");
            $display("inst is: %b %b %b %b %b", cmd.inst[31:26], cmd.inst[25:20], cmd.inst[19:15],cmd.inst[14:12],cmd.inst[11:7],cmd.inst[6:0]);
            $display("rs1 address = %0d and rs2 address = %0d and rd address = %0d",cmd.inst[19:15],cmd.inst[25:20] ,cmd.inst[11:7]);
            $display("is immediate ?? %b",cmd.inst[13]);
            bfm.verify_inst(cmd.inst);
            seq_item_port.item_done();

            //store result
            seq_item_port.get_next_item(cmd);
            $display("driver store fetch");
            $display("inst is: %b %b %b %b %b", cmd.inst[31:26], cmd.inst[25:20], cmd.inst[19:15],cmd.inst[14:12],cmd.inst[11:7],cmd.inst[6:0]);
            $display("rd address = %0d",cmd.inst[11:7]);
            bfm.send_inst(cmd.inst);
            bfm.receive_data();
            seq_item_port.item_done();
        end : cmd_loop
    endtask : run_phase

endclass : GUVM_driver