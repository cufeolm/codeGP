class GUVM_sequence_item extends uvm_sequence_item;

  `uvm_object_utils(GUVM_sequence_item)
   rand logic [31:0] inst;
   rand logic [31:0] data;// the effective data that should be stored inside memory 
   logic [31:0] op1,op2;// the 2 operands that shoould be at the registers 

   protected function logic [31:0] generate_instruction(opcode target_instruction );
		//logic [31:0] rand_inst;
		//rand_inst = $random();
		for (integer i =0;i<32;i++)
		begin 
			if ((target_instruction[i]===1 )||(target_instruction[i]===0 )) 
			inst[i]=target_instruction[i];
		end
		return inst;
	endfunction 

	function void rf_load();
		inst=0;
	endfunction

	function void ran_constrained(opcode con);//resiricted randomization 
		inst = $random();
		inst = generate_instruction(con);
	endfunction 

	function void ran();
		//randomize();
		integer i = $urandom() % supported_instructions;
		opcode con = si_a[i]; // con is a constraint
		inst = $random();
		inst = generate_instruction(con);
	endfunction


  function new (string name = "");
    super.new(name);
  endfunction

  //copied and edited portion of code 
  function bit do_compare(uvm_object rhs, uvm_comparer comparer);
	GUVM_sequence_item tested;
	bit               same;
	
	if (rhs==null) `uvm_fatal(get_type_name(), 
							  "Tried to do comparison to a null pointer");
	
	if (!$cast(tested,rhs))
	  same = 0;
	else
	  same = super.do_compare(rhs, comparer) && 
			 (tested.inst == inst) ;
	return same;
 endfunction : do_compare

 function void do_copy(uvm_object rhs);
	GUVM_sequence_item RHS;
	assert(rhs != null) else
	  $fatal(1,"Tried to copy null transaction");
	super.do_copy(rhs);
	assert($cast(RHS,rhs)) else
	  $fatal(1,"Faied cast in do_copy");
	inst = RHS.inst;
 endfunction : do_copy

 function string convert2string();
	string            s;
	s = $sformatf("command sequence : inst =%b",
				  inst);
	return s;
 endfunction : convert2string
  /*
  function randomize ();
	logic [31:0]temp;
	bit t = 1;
	while (t)
		temp = super.new randomize();
		case (temp)
			//valid instruction case statements is t = 0
		end
	end
	*/
endclass: GUVM_sequence_item