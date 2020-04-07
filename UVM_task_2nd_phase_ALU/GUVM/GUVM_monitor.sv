class GUVM_monitor extends uvm_component;
   `uvm_component_utils(GUVM_monitor);

   virtual GUVM_interface bfm;
   uvm_analysis_port #(GUVM_result_transaction) Mon2Sb_port;

   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
      if(!uvm_config_db #(virtual GUVM_interface)::get(null, "*","bfm", bfm))
        `uvm_fatal("DRIVER", "Failed to get BFM");
      Mon2Sb_port  = new("Mon2Sb_port",this);
   endfunction : build_phase

   function void connect_phase(uvm_phase phase);
      bfm.monitor_h = this;
   endfunction : connect_phase

   function void write_to_monitor(logic [31:0]r);
      GUVM_result_transaction result_t;
      result_t = new("result_t");
      result_t.result = r;
      Mon2Sb_port.write(result_t);
   endfunction : write_to_monitor
   
endclass : GUVM_monitor