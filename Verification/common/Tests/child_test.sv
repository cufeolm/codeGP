
class child_test extends GUVM_test;
    `uvm_component_utils(child_test);
    function new(string name = "child_test", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        cmdline_proc = uvm_cmdline_processor::get_inst();
        env_h   = GUVM_env::type_id::create("env_h",this);
        generic_sequence_h = child_sequence::type_id::create("generic_sequence_h");
    endfunction: build_phase 
   
endclass: child_test



/*
class child_test extends uvm_test;
    `uvm_component_utils(child_test);

    GUVM_env       env_h;
    child_sequence generic_sequence_h;

    function new(string name = "child_test", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        env_h   = GUVM_env::type_id::create("env_h",this);
        generic_sequence_h = child_sequence::type_id::create("generic_sequence_h");
    endfunction: build_phase 
    
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        $display("test have started ");
        generic_sequence_h.start(env_h.agent.sequencer);
        phase.drop_objection(this);
    endtask: run_phase
   
endclass: child_test
*/
