class GUVM_test extends uvm_test;
    `uvm_component_utils(GUVM_test);

    GUVM_env       env_h;
    GUVM_sequence generic_sequence_h;

    function new(string name = "GUVM_test", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        env_h   = GUVM_env::type_id::create("env_h",this);
        generic_sequence_h = GUVM_sequence::type_id::create("generic_sequence_h");
    endfunction: build_phase 
    
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        $display("test have started ");
        generic_sequence_h.start(env_h.agent.sequencer);
        phase.drop_objection(this);
    endtask: run_phase
   
endclass: GUVM_test
