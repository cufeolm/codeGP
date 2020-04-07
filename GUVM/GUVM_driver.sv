class GUVM_driver extends uvm_driver #(target_seq_item);

    // register the driver in the UVM factory
    `uvm_component_utils(GUVM_driver)

    virtual GUVM_interface bfm; // stores core interface 
    uvm_analysis_port #(target_seq_item) Drv2Sb_port;   // defining port between monitor and scoreboard

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db#(virtual GUVM_interface)::get(this, "", "bfm", bfm)) begin // getting interface in bfm
            `uvm_fatal("Driver", "Failed to get BFM");
        end
        Drv2Sb_port = new("Drv2Sb", this);
    endfunction

    task run_phase(uvm_phase phase);
        target_seq_item cmd;
        forever begin: cmd_loop
            $display("driver has started");
            bfm.reset_dut(); // resetting core 
            bfm.set_Up();   // setting up core's inputs with costant values
            $display("driver starting fetching");
            
            //first load
            seq_item_port.get_next_item(cmd); //getting first instrucion in sequence (1st load)
                $display("driver first load fetch");
                $display("inst is %b %b %b %b %b %b %b %b", cmd.inst[31:28], cmd.inst[27:24], cmd.inst[23:20], cmd.inst[19:16], cmd.inst[15:12], cmd.inst[11:8], cmd.inst[7:4], cmd.inst[3:0]);
            bfm.load(cmd.inst, cmd.data); // drive it to dut through interface
            seq_item_port.item_done();

            //second load
            seq_item_port.get_next_item(cmd); //getting second instrucion in sequence (2nd load)
                $display("driver second load fetch");
                $display("inst is %b %b %b %b %b %b %b %b", cmd.inst[31:28], cmd.inst[27:24], cmd.inst[23:20], cmd.inst[19:16], cmd.inst[15:12], cmd.inst[11:8], cmd.inst[7:4], cmd.inst[3:0]);
            bfm.load(cmd.inst, cmd.data); // drive it to dut through interface
            seq_item_port.item_done();

            //instruction to be verified
            seq_item_port.get_next_item(cmd); //getting third instrucion in sequence (verified instruction)
                $display("driver instruction fetch");
                $display("inst is %b %b %b %b %b %b %b %b", cmd.inst[31:28], cmd.inst[27:24], cmd.inst[23:20], cmd.inst[19:16], cmd.inst[15:12], cmd.inst[11:8], cmd.inst[7:4], cmd.inst[3:0]);
                $display("rs1 address = %0d and rs2 address = %0d and rd address = %0d", cmd.rs1, cmd.rs2, cmd.rd);
                $display("op1= %0d op2= %0d",cmd.operand1,cmd.operand2);
            bfm.verify_inst(cmd.inst); // drive it to dut through interface
            Drv2Sb_port.write(cmd); // send verified instruction sequence item to scoreboard
            seq_item_port.item_done();

            //store result
            seq_item_port.get_next_item(cmd); //getting fourth instrucion in sequence (store)
                $display("driver store fetch");
                $display("inst is %b %b %b %b %b %b %b %b",cmd.inst[31:28],cmd.inst[27:24],cmd.inst[23:20],cmd.inst[19:16],cmd.inst[15:12],cmd.inst[11:8],cmd.inst[7:4],cmd.inst[3:0]);
            bfm.store(cmd.inst); // drive it to dut through interface
            seq_item_port.item_done();
        end: cmd_loop
    endtask: run_phase

endclass: GUVM_driver