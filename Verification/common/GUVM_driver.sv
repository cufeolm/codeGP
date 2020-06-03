class GUVM_driver extends uvm_driver #(target_seq_item);

    // register the driver in the UVM factory
    `uvm_component_utils(GUVM_driver)

    virtual GUVM_interface bfm; // stores core interface 

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db#(virtual GUVM_interface)::get(this, "", "bfm", bfm)) begin // getting interface in bfm
            `uvm_fatal("Driver", "Failed to get BFM");
        end
    endfunction

    task run_phase(uvm_phase phase);
        target_seq_item cmd;

       // $display("driver has started");
        //bfm.reset_dut(); // resetting core 
        //bfm.set_Up();   // setting up core's inputs with costant values
        //$display("driver started fetching");

        forever begin: cmd_loop

            seq_item_port.get_next_item(cmd); //getting first instrucion in sequence (1st load)
            //bfm.monitor_cmd(cmd);
            //bfm.load(cmd.inst, cmd.data); // drive it to dut through interface
            if (cmd.SOM==SB_RESET_MODE)begin
                bfm.reset_dut(); // resetting core 
                bfm.set_Up();   // setting up core's inputs with costant values
                bfm.update_command_monitor(cmd);
                bfm.update_result_monitor();
            end
            else
            begin
                bfm.send_data(cmd.data);
                bfm.send_inst(cmd.inst);
                bfm.update_command_monitor(cmd);
                bfm.update_result_monitor();
                bfm.toggle_clk(1);
            end
            
            seq_item_port.item_done();
            /*
            //first load
            seq_item_port.get_next_item(cmd); //getting first instrucion in sequence (1st load)
            bfm.monitor_cmd(cmd);
            bfm.load(cmd.inst, cmd.data); // drive it to dut through interface
            seq_item_port.item_done();

            //second load
            seq_item_port.get_next_item(cmd); //getting second instrucion in sequence (2nd load)
            bfm.monitor_cmd(cmd);
            bfm.load(cmd.inst, cmd.data); // drive it to dut through interface
            seq_item_port.item_done();

            //instruction to be verified
            seq_item_port.get_next_item(cmd); //getting third instrucion in sequence (verified instruction)

             
            bfm.monitor_cmd(cmd);
            bfm.verify_inst(cmd.inst,cmd.operand1,cmd.operand2,cmd.simm); // drive it to dut through interface
            seq_item_port.item_done();

            //store result
            seq_item_port.get_next_item(cmd); //getting fourth instrucion in sequence (store)
            bfm.monitor_cmd(cmd);
            bfm.store(cmd.inst); // drive it to dut through interface
            seq_item_port.item_done();
            */

        end: cmd_loop
    endtask: run_phase

endclass: GUVM_driver