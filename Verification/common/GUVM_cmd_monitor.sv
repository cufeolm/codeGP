class command_monitor extends uvm_component;
   `uvm_component_utils(command_monitor);

   virtual GUVM_interface bfm; // stores core interface 
   uvm_analysis_port #(GUVM_sequence_item) Drv2Sb_port;   // defining port between monitor and scoreboard

   function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
        if(!uvm_config_db#(virtual GUVM_interface)::get(this, "", "bfm", bfm)) begin // getting interface in bfm
            `uvm_fatal("Driver", "Failed to get BFM");
        end
        Drv2Sb_port = new("Drv2Sb", this);
    endfunction

   function void connect_phase(uvm_phase phase);
      bfm.command_monitor_h = this;
   endfunction : connect_phase

   /*function void write_to_cmd_monitor(logic [31:0]inst,logic [31:0]op1,logic [31:0]op2,logic [31:0]simm,logic [31:0]data=0);
      GUVM_sequence_item cmd;
      cmd = new("cmd");
      cmd.inst = inst;
      cmd.data = data;
      cmd.simm = simm;
      cmd.operand1 = op1;
      cmd.operand2 = op2;
      cmd.current_pc = bfm.get_cpc(); // getting current instruction pc 
      Drv2Sb_port.write(cmd); 
   endfunction : write_to_cmd_monitor*/

   function void write_to_cmd_monitor(GUVM_sequence_item cmd);
      //$display("cmd_monitor********************rd= %0d",cmd.rd);
      if (cmd.SOM == SB_HISTORY_MODE)
      begin	
         cmd.current_pc = bfm.get_cpc(); // getting current instruction pc 
      end
      Drv2Sb_port.write(cmd); 
   endfunction : write_to_cmd_monitor


endclass : command_monitor


  