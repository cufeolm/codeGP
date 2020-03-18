package GUVM_testbench_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	typedef enum logic [31:0] { 
		LSB=32'b11xxxxx001001xxxxx1xxxxxxxxxxxxx,
		LUW=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx     // (NOP)
		} opcode;
	opcode si_a []; 
	integer supported_instructions;
  
	`include "GUVM_sequence.sv"
	`include "GUVM_sequence_item.sv"
  	`include "GUVM_driver.sv"
  	`include "GUVM_monitor.sv"
  	`include "GUVM_scoreboard.sv"
  	`include "GUVM_agent.sv"
  	`include "GUVM_env.sv"
	`include "GUVM_test.sv"
	

	function void fill_si_array( ); // fill supported instruction array 
		// this does NOT  affect generalism this makes sure you dont run 
		// the same function twice in a test bench 
		`ifndef SET_UP_INSTRUCTION_ARRAY
		`define SET_UP_INSTRUCTION_ARRAY
			opcode si_i ; // for iteration only
			supported_instructions = si_i.num() ;
			si_a=new [supported_instructions] ; 
			
			si_i = si_i.first();
			for (integer i=0 ; i < supported_instructions ; i++ )
			begin   
				si_a [i]= si_i ; 
				si_i=si_i.next();
				
			end 
			//$display("array is filled and ready to use");
		`endif  
	endfunction

endpackage
  