class GUVM_monitor extends uvm_monitor;
    // register the monitor in the UVM factory
    `uvm_component_utils(GUVM_monitor)
    int count;
    //Declare virtual interface
    virtual GUVM_interface processor_vif;

    // Analysis port to broadcast results to scoreboard 
    uvm_analysis_port #(GUVM_sequence_item) Mon2Sb_port; 
       
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
     
    function void build_phase(uvm_phase phase);
        // Get interface reference from config database
        if(!uvm_config_db#(virtual GUVM_interface)::get(this, "", "processor_vif", processor_vif)) begin
            `uvm_error("", "uvm_config_db::get failed")
        end
        Mon2Sb_port = new("Mon2Sb",this);
    endfunction

    task run_phase(uvm_phase phase);
        GUVM_sequence_item pros_trans;
        pros_trans = new ("trans");
        count = 0;
        fork
            forever begin
                @(processor_vif.monitor_if_mp.monitor_cb.out) // data out de heya eldata elly mn elregister
                begin
                    if(count<32)
                    begin
                        count++;
                    end
                    else begin
                        //Set transaction from interface data                    
                        pros_trans.output_reg = processor_vif.monitor_if_mp.monitor_cb.wdata;            
                        //Send transaction to Scoreboard
                        Mon2Sb_port.write(pros_trans);    
                        count = 0;             
                    end
                end
           end
        join
    endtask : run_phase

endclass : processor_monitor
