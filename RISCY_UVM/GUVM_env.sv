class GUVM_env extends uvm_env;
    `uvm_component_utils(GUVM_env);

    GUVM_agent agent;
    GUVM_monitor monitor_h;
    GUVM_scoreboard sb;
    
    function new (string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        agent = GUVM_agent::type_id::create("agent", this);
        monitor_h = GUVM_monitor::type_id::create("monitor_h",this);
        sb = GUVM_scoreboard::type_id::create("sb",this);
    endfunction : build_phase

    //  Function: connect_phase
    function void connect_phase(uvm_phase phase);
        `uvm_info("", "Called env::connect_phase", UVM_NONE);
        agent.driver.Drv2Sb_port.connect(sb.Drv2Sb_port);
        monitor_h.Mon2Sb_port.connect(sb.Mon2Sb_port);
    endfunction
endclass : GUVM_env
