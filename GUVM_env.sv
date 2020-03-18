class GUVM_env extends uvm_env;
    `uvm_component_utils(GUVM_env)
    
    GUVM_agent agent;
    GUVM_monitor mon;
    GUVM_scoreboard sb;

    function new(string name, uvm_component parent);
      	super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      	agent = GUVM_agent::type_id::create("agent", this);
      	mon   = GUVM_monitor::type_id::create("mon",this);
      	sb    = GUVM_scoreboard::type_id::create("sb",this);
    endfunction
  
    // connect ports of various TB components here
    function void connect_phase(uvm_phase phase);
      	`uvm_info("", "Called env::connect_phase", UVM_NONE);
      
      	// connect driver's analysis port to scoreboard's analysis
      	// implementation port
      	agent.driver.Drv2Sb_port.connect(sb.Drv2Sb_port);
      
      	// connect monitor's analysis port to scoreboard's analysis
      	// implementation port
      	mon.Mon2Sb_port.connect(sb.Mon2Sb_port);
   	endfunction: connect_phase
endclass