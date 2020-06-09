package target_package;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

    // instructions opcodes verified in this core 
	typedef enum logic[31:0] {
		//LW = 32'bxxxxxxxxxxxxxxxxx010xxxxx0000011,
		A = 32'b0000000xxxxxxxxxx000xxxxx0110011,
		//SW = 32'bxxxxxxxxxxxxxxxxx010xxxxx0100011,
		LSBMA=32'bxxxxxxxxxxxxxxxxx000xxxxx0000011, // load signed byte with misalignment feat. reg-imm
		LSHMA=32'bxxxxxxxxxxxxxxxxx001xxxxx0000011, // load signed half with misalignment feat. word reg-imm
		LUBMA=32'bxxxxxxxxxxxxxxxxx100xxxxx0000011, // load unsigned byte with misalignment feat. reg-imm
		LUHMA=32'bxxxxxxxxxxxxxxxxx101xxxxx0000011, // load unsigned half with misalignment feat. word reg-imm
		LSBMARR=32'b0000000xxxxxxxxxx111xxxxx0000011, // load signed byte with misalignment feat. reg-reg
		LSHMARR=32'b0001000xxxxxxxxxx111xxxxx0000011, // load signed half with misalignment feat. word reg-reg
		LUBMARR=32'b0100000xxxxxxxxxx111xxxxx0000011, // load unsigned byte with misalignment feat. reg-reg
		LUHMARR=32'b0101000xxxxxxxxxx111xxxxx0000011, // load unsigned half word with misalignment feat. reg-reg
		LWMARR=32'b0010000xxxxxxxxxx111xxxxx0000011, // load word with misalignment feat. reg-reg

		SBMA=32'bxxxxxxxxxxxxxxxxx000xxxxx0100011, // store least significant byte reg-imm
		SHMA=32'bxxxxxxxxxxxxxxxxx001xxxxx0100011, // store least significant half word reg-imm
		
		UMULR =32'b0000001xxxxxxxxxx000xxxxx0110011, // multiply reg-reg
		MHSR  =32'b0000001xxxxxxxxxx001xxxxx0110011, // multiply signed and get the upper half of result 
		MHSUR =32'b0000001xxxxxxxxxx010xxxxx0110011, // multiply signed-unsigned and get the upper half of result
		MHUR  =32'b0000001xxxxxxxxxx011xxxxx0110011, // multiply unsigned and get the upper half of result

		NOP=32'h0000001B,
		Jal=32'bxxxxxxxxxxxxxxxxxxxxxxxxx1101111,
		BIGTOER=32'bxxxxxxxxxxxxxxxxx101xxxxx1100011,// branch if greater than or equal reg-reg (signed)
		BILTR=32'bxxxxxxxxxxxxxxxxx100xxxxx1100011,// branch if less reg-reg (signed)
		BIGTOERU=32'bxxxxxxxxxxxxxxxxx111xxxxx1100011,// branch if greater than or equal reg-reg (unsigned)
		BILTRU=32'bxxxxxxxxxxxxxxxxx110xxxxx1100011,// branch if less reg-reg (unsigned)
		Jalr=32'bxxxxxxxxxxxxxxxxx000xxxxx1100111,// jump and link register-imm
		BIER=32'bxxxxxxxxxxxxxxxxx000xxxxx1100011,// branch if equal reg-reg
		Store =32'b0000000xxxxx00000010000000100011,
		SWMA =32'bxxxxxxxxxxxxxxxxx010xxxxx0100011, // store word reg-imm
        Load = 32'b00000000000000000010xxxxx0000011,
		LWMA= 32'bxxxxxxxxxxxxxxxxx010xxxxx0000011 // load word with misalignment feat. reg-imm
	} opcode;
	// mutual instructions between cores have the same name so we can verify all cores using one scoreboard
	
       //FLAG PLACE DECLARATION
	parameter LOC_ZF = 0;
	parameter LOC_CF = 0;
	parameter LOC_VF = 0;
	parameter LOC_NF = 0;
	//INSTRUCTION FORMAT 
    parameter RDU = 11;
    parameter   RDL = 7;
    parameter   RS1U = 19;
    parameter   RS1L = 15;
    parameter   RS2U = 24;
    parameter   RS2L = 20;

	opcode si_a [];	// opcodes array to store enums so we can randomize and use them
    integer supported_instructions;	 // number of instructions in the array
	`include "riscy_defines.sv"
	`include "GUVM.sv"	// including GUVM classes 
   

    // fill supported instruction array
	function void fill_si_array();
		// this does NOT  affect generalism this makes sure you dont run
		// the same function twice in a test bench
		`ifndef SET_UP_INSTRUCTION_ARRAY
		`define SET_UP_INSTRUCTION_ARRAY
			opcode si_i ; // for iteration only
			supported_instructions = si_i.num();
			si_a = new [supported_instructions];
			si_i = si_i.first();
			for(integer i=0; i<supported_instructions; i++) begin
				si_a[i] = si_i;
				si_i = si_i.next();
			end
		`endif
	endfunction


    // function to determine format of verfied instruction and fill its operands


    // used in if conditions to compare between (x) and (1 or 0)
	function bit xis1 (logic[31:0] a,logic[31:0] b);
		logic x;
		x = (a == b);
		if(x==1) return 1 ;
		if (x === 1'bx)
			begin
				return 1'b1;
			end
		else
			begin
				return 1'b0;
			end
	   endfunction : xis1

		function opcode findOP(string s);//returns the op code corresponding to string s from package
            foreach(si_a[i]) // supported instruction is number of instructions in opcodes array of the core
            begin
                if(si_a[i].name == s) return si_a[i] ;
            end
            $display("couldnt find %s inside instruction package",s);
            return NOP ; 
        endfunction
endpackage