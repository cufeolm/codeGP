import uvm_pkg::*;
`include "uvm_macros.svh"
`include "GUVM_sequence.sv"

class GUVM_monitor extends uvm_monitor;
`uvm_component_utils(GUVM_monitor)                       // put monitor in a register in the uvm factory
virtual GUVM_interface GUVM_vif;                         // using virtual interface to monitor
uvm_analysis_port #(GUVM_sequence_item) Mon2Sb_port; // analysis port to scoreboard to sendd transactions

function new(string name, uvm_component parent);       // creating constructor of monitor class
     super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);            // Get interface reference from config database
if(!uvm_config_db#(virtual GUVM_interface)::get(this, "", "GUVM_vif", GUVM_vif)) begin
   `uvm_error("", "uvm_config_db::get failed")
end
Mon2Sb_port = new("Mon2Sb",this);     // create port with scoreboard
endfunction



/////////// monitor main task "converting signal into transaction then write to scoreboard" ////////////////
int count;
logic[31:0] mon_idata;
logic[31:0] mon_wdata;
logic[31:0] mon_instr;
logic[31:0] mon_addr;

//mon_wdata=GUVM_vif.data_wdata_o;
//GUVM_vif.OUTPUTDATA(mon_idata,mon_wdata,mon_instr,mon_addr);


task run_phase(uvm_phase phase);
  GUVM_sequence_item pros_trans;                                                   // creating new sequence class with its constructor
  pros_trans = new ("trans");
  count = 0;
  //fork
  
  forever begin @(GUVM_vif.OUTPUTDATA(mon_idata,mon_wdata,mon_instr,mon_addr))       // while there's dataout from dut on the bus , monitor is operating
      begin
	     if(count<32)                                                          // counting on bits number of instruction inpit to dut
	        begin
	        count++;
		end
	     else
	begin
	//	pros_trans.wdata= mon_wdata;   //Set transaction from interface data
		
		Mon2Sb_port.write(pros_trans); // writing data monitored into scoreboard
	end
      end
		 end
  
  count=0;
  //join
  endtask:run_phase
  endclass: GUVM_monitor