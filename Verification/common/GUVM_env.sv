class GUVM_env extends uvm_env;
    `uvm_component_utils(GUVM_env);

    GUVM_agent agent;
    GUVM_result_monitor monitor_h;
    GUVM_scoreboard sb;
    command_monitor command_monitor_h;
    
    function new (string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        agent = GUVM_agent::type_id::create("agent", this);
        monitor_h = GUVM_result_monitor::type_id::create("monitor_h",this);
        command_monitor_h = command_monitor::type_id::create("command_monitor_h",this);
        sb = GUVM_scoreboard::type_id::create("sb",this);
    endfunction : build_phase

    //  Function: connect_phase
    function void connect_phase(uvm_phase phase);
        `uvm_info("", "Called env::connect_phase", UVM_NONE);
        command_monitor_h.Drv2Sb_port.connect(sb.Drv2Sb_port);
        monitor_h.Mon2Sb_port.connect(sb.Mon2Sb_port);
    endfunction
endclass : GUVM_env
