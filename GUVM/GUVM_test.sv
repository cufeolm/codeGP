class GUVM_test extends uvm_test;
   `uvm_component_utils(GUVM_test)
   
   GUVM_env env;
   GUVM_sequence processor_seq;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction
   
   function void build_phase(uvm_phase phase);
      env = GUVM_env::type_id::create("env", this);
      processor_seq = GUVM_sequence::type_id::create("processor_seq");
   endfunction

   function void end_of_elaboration_phase(uvm_phase phase);
      print();
   endfunction

   task run_phase(uvm_phase phase);
     
     // We raise objection to keep the test from completing
     phase.raise_objection(this);
     `uvm_warning("", "processor test!")
     #10;
    
     processor_seq.start(env.agent.sequencer);
     
     #1000;
     // We drop objection to allow the test to complete
     phase.drop_objection(this);
   endtask

endclass