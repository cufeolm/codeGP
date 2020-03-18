class driver extends uvm_driver #(GUVM_sequence_item);
   `uvm_component_utils(driver)
   import GUVM_classes_pkg::*; //has GUVM_sequence
   
   virtual GUVM_interface bfm;

   // uvm_analysis_port #(GUVM_sequence_item) Drv2Sb_port;
 
   function void build_phase(uvm_phase phase);
      if(!uvm_config_db #(virtual tinyalu_bfm)::get(null, "*","bfm", bfm))
        `uvm_fatal("DRIVER", "Failed to get BFM")
      // Drv2Sb_port = new("Drv2Sb",this);
   endfunction : build_phase

   task run_phase(uvm_phase phase);
      GUVM_sequence_item cmd;
      bfm.reset();
      bfm.setup_data();
      forever begin : cmd_loop
         seq_item_port.get_next_item(cmd);
         bfm.input_inst(cmd.instrn);
         // Drv2Sb_port.write(cmd.instrn);
         seq_item_port.item_done();
      end : cmd_loop
   endtask : run_phase
   
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new
   
endclass : drive