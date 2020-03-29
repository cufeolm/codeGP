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
        //$display("monitor starts");
        //#10000 // ay time 3la 7asab elcritical path llduts
        fork
	   forever begin@(bfm.out)
       begin
        pros_trans.receivedDATA = bfm.out;
       // $display("monitor out is %0d", pros_trans.receivedDATA);
        Mon2Sb_port.write(pros_trans);

        end
      end
        join
        
    endtask : run_phase

endclass : GUVM_monitor