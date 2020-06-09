class arith_flag_amber_test extends GUVM_test;
    `uvm_component_utils(arith_flag_amber_test);
    function new(string name = "arith_flag_amber_test", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        cmdline_proc = uvm_cmdline_processor::get_inst();
        env_h   = GUVM_env::type_id::create("env_h",this);
        generic_sequence_h = arith_flag_amber_sequence::type_id::create("generic_sequence_h");
    endfunction: build_phase 
   
endclass: arith_flag_amber_test
