class GUVM_monitor extends uvm_monitor;

    `uvm_component_utils(GUVM_monitor)

    virtual GUVM_interface bfm;

    uvm_analysis_port #(GUVM_sequence_item) Mon2Sb_port; 
       
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
     
    function void build_phase(uvm_phase phase);
        if(!uvm_config_db#(virtual GUVM_interface)::get(this, "", "bfm", bfm)) begin
            `uvm_error("", "uvm_config_db::get failed")
        end
        Mon2Sb_port = new("Mon2Sb",this);
    endfunction

    task run_phase(uvm_phase phase);
        GUVM_sequence_item pros_trans;
        pros_trans = new ("trans");
        $display("monitor starts");
        pros_trans.receivedDATA = bfm.receive_data();
        $display("MONITOR OUTPUT IS: %b", pros_trans.receivedDATA);
    endtask : run_phase

endclass : GUVM_monitor
