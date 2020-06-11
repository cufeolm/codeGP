
//GUVM_sequence_item is the sequence that is acted upon in our test bench 
//acts as a parent to all the target sequence items 


class GUVM_sequence_item extends uvm_sequence_item;	
  `uvm_object_utils(GUVM_sequence_item)
   rand logic [31:0] inst;
   rand logic [31:0] data;// the effective data that should be stored inside memory 
   rand logic [31:0] data2;// the effective data that should be stored inside memory in case of double load
   logic [31:0] zimm,simm,current_pc,updated_flags;// the 2 operands that shoould be at the registers
   logic [4:0]rs1,rs2,rd,store_add;
   logic update_result=0;
   //logic v=0; // should be deleted
   GUVM_TB_SOM SOM = SB_HISTORY_MODE ;//score board operation mode

   
   protected function logic [31:0] generate_instruction(opcode target_instruction );
		//this function generates an instruction based on the op code given in the target_package
		// the target pacakge tells us whhich fields need to be constant and the rrest is randomized
		for (integer i =0;i<32;i++)
		begin 
			if ((target_instruction[i]===1 )||(target_instruction[i]===0 )) 
			inst[i]=target_instruction[i];
		end
		return inst;
	endfunction 

	function void rf_load();//for debuggging purposes only 
		inst=0;
	endfunction

	function void ran_constrained(opcode con);
		//randomizes the non op-code fields for a certain instruction
		inst = $random();
		data = $random();
		inst = generate_instruction(con);
	endfunction 

	function void ran();
		// this function generates a random instruction from the supported instructions 
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
	data = RHS.data ;
	store_add = RHS.store_add;
	data2 = RHS.data2 ; 
	zimm=RHS.zimm; 
	simm=RHS.simm;
	current_pc=RHS.current_pc;
	rs1=RHS.rs1;
	rs2=RHS.rs2;
	rd=RHS.rd;
	SOM = RHS.SOM ; 
 endfunction : do_copy

 function string convert2string();// for debugging purposes 
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