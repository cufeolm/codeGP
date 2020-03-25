class amber_seq_item extends GUVM_sequence_item;
	
	  `uvm_object_utils(amber_seq_item)
	  
	function new (string name = "");
		super.new(name);
	endfunction
  
		logic [3:0]cond;
		logic [3:0]opcode;
		logic [3:0]rn;
		logic [3:0]rd;
		logic [3:0]rs;
		logic [3:0]rm;
		logic [11:0]offset12;
		logic [15:0]register_list;
		logic [23:0]offset24;
		logic [3:0]crd;
		logic [3:0]cphash;
		logic [7:0]offset8;
		logic [3:0]crm;
		logic [3:0]crn;
		logic [3:0]cp_opcode4;
		logic [2:0]cp_opcode3;
		logic [2:0]cp;
		logic [23:0]ibc;
		logic [1:0]shift;
		logic [5:0]shift_imm;
		logic [7:0]imm8;
		logic [3:0]encode_imm;
		logic i;
		logic s;
		logic a;
		logic b;
		logic p;
		logic u;
		logic w;
		logic l;
		logic n;
	

endclass : amber_seq_item