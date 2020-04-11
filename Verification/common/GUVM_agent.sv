class GUVM_agent extends uvm_agent;

    // register the agent in the UVM factory
    `uvm_component_utils(GUVM_agent)

    GUVM_driver driver; // defining driver
    uvm_sequencer #(target_seq_item) sequencer; // defining sequencer 

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        driver = GUVM_driver::type_id::create("driver", this);
        sequencer = uvm_sequencer#(target_seq_item)::type_id::create("sequencer", this);
    endfunction

    // In UVM connect phase, we connect the sequencer to the driver.
    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction

endclass