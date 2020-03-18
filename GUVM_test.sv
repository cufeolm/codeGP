`include "GUVM_sequence.sv"
`include "uvm_macros.svh"


class GUVM_test extends uvm_test;
 `uvm_component_utils(GUVM_test)
   
   GUVM_env env;
   //GUVM_sequence GUVM_seq;

   function new(string name, uvm_component parent);
     super.new(name, parent);
   endfunction
   
   function void build_phase(uvm_phase phase);
     env = GUVM_env::type_id::create("env", this);
     GUVM_seq = GUVM_sequence::type_id::create("GUVM_seq");
	endfunction

   function void end_of_elaboration_phase(uvm_phase phase);
     print();
   endfunction
   
   
   task run_phase(uvm_phase phase);
     
     // We raise objection to keep the test from completing
     phase.raise_objection(this);
     `uvm_warning("", "processor test!")
     #10;
    
     GUVM_seq.start(env.agent.sequencer);
     
     #1000;
     // We drop objection to allow the test to complete
     phase.drop_objection(this);
   endtask

endclass