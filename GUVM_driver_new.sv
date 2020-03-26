


class driver extends uvm_driver #(sequence_item);
   `uvm_component_utils(driver)
   import GUVM_classes_pkg::*; // has GUVM_sequence

   virtual GUVM_bfm bfm;
   
   uvm_analysis_port #(sequence_item) Drv2Sb_port;

   function void build_phase(uvm_phase phase);
      // Get interface reference from config database
      if(!uvm_config_db #(virtual GUVM_bfm)::get(this, "", "bfm", bfm)) begin
         `uvm_error("", "uvm_config_db::get failed")
      end
      drv_clk=1'b0;
      Drv2Sb_port = new("Drv2Sb",this);
   endfunction

   task run_phase(uvm_phase phase);
      forever begin
         @(processor_vif.driver_if_mp.driver_cb)
         begin 
            seq_item_port.get_next_item(req);
            bfm.driver_if_mp.driver_cb.inst_in <= req.instrn;
            Drv2Sb_port.write(req);
            seq_item_port.item_done();
         end
      end
   endtask : run_phase
   
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new
   
endclass : driver