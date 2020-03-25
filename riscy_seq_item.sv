class target_seq_item extends GUVM_sequence_item;
	
	  `uvm_object_utils(target_seq_item)
	  
	function new (string name = "");
		super.new(name);
	endfunction
  
		logic [6:0]funct7;
		logic [4:0]rs2;
		logic [4:0]rs1;
		logic [2:0]funct3;
		logic [4:0]rd;
		logic [6:0]opcode;
		logic [11:0]immb11_0;
		logic [6:0]immb11_5;
		logic [4:0]immb4_0;
		logic immb11;
		logic [3:0]immb4_1;
		logic [5:0]immb10_5;
		logic immb12;
		logic [19:0]immb31_12;
		logic [7:0]immb19_12;
		logic [9:0]immb10_1;
		logic immb20;
		logic [4:0]shamt;
		logic [3:0]pred;
		logic [3:0]succ;
		logic [11:0]csr;

endclass : riscy_seq_item