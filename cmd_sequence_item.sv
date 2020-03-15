class cmd_sequence_item extends uvm_sequence_item;

  `uvm_object_utils(cmd_sequence_item)
   rand logic [31:0] inst;
	
  function new (string name = "");
    super.new(name);
  endfunction

  //copied and edited portion of code 
  function bit do_compare(uvm_object rhs, uvm_comparer comparer);
	cmd_sequence_item tested;
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
	cmd_sequence_item RHS;
	assert(rhs != null) else
	  $fatal(1,"Tried to copy null transaction");
	super.do_copy(rhs);
	assert($cast(RHS,rhs)) else
	  $fatal(1,"Faied cast in do_copy");
	inst = RHS.inst;
 endfunction : do_copy

 function string convert2string();
	string            s;
	s = $sformatf("command sequence : inst =%d",
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
endclass: cmd_sequence_item