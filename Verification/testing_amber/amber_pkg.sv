package target_package;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // instructions opcodes verified in  this core 
    typedef enum logic[31:0] { 
        A  = 32'b1110000010000xxx0xxx000000000xxx,
        // A  = 32'b111000001000xxxxxxxx00000000xxxx,
        ADDX=   32'b1110000010100xxx0xxx000000000xxx, // add with carry 
        ADDCC = 32'b1110000010010xxx0xxx000000000xxx,// ADD and change flags
        ADDXCC=   32'b1110000010110xxx0xxx000000000xxx,//ADD with carry and change flags
         
        SUBCC =   32'b1110000001010xxx0xxx000000000xxx,// SUB and change flags
        SUB=      32'b1110000001000xxx0xxx000000000xxx,// subtract
        SUBX=     32'b1110000011000xxx0xxx000000000xxx,
        SUBXCC =  32'b1110000011010xxx0xxx000000000xxx,
        
        Rs=     32'b1110000001100xxx0xxx000000000xxx,// reverse subtract
       // Swc=32'b1110000011000xxx0xxx000000000xxx, // sub with carry

        C=32'b1110000101010xxx0xxx000000000xxx,     // //Compare and update flags
        CN=32'b1110_0001_0111_0xxx_0xxx_0000_0000_0xxx, //Compare NOT and update flags
        BIEF=32'b00001010xxxxxxxxxxxxxxxxxxxxxxxx,
        BA = 32'b11101010xxxxxxxxxxxxxxxxxxxxxxxx,
        
        BwA=32'b1110000000000xxx0xxx000000000xxx, // bitwise and
        BAwc=32'b1110000111000xxx0xxx000000000xxx, // bitwise and with complement
        BX=32'b1110000000100xxx0xxx000000000xxx, // xor
        BO=32'b1110000110000xxx0xxx000000000xxx,

        //BR =32'b11101010xxxxxxxxxxxxxxxxxxxxxxxx,
        BRL=32'b11101011xxxxxxxxxxxxxxxxxxxxxxxx,

        Mov=32'b1110000110100xxx0xxx000000000xxx,  // Move from reg to reg or from imm to reg
        Mn=32'b1110000111100xxx0xxx000000000xxx,   // Move complement from reg to reg or from imm to reg

        M=32'b1110000000000xxx00000xxx10010xxx,
        MA=32'b1110000000100xxx0xxx0xxx10010xxx, // multiply accumlate

        // NOP = 32'b111101101000xxxxxxxxxxxxxxxxxxxx,
        NOP = 32'b11110000100000000000000000000000,
        // NOP = 32'b00000000000000000000000000000000,
        Store = 32'b1110010110000000xxxx000000000000, // VITAL WARNING , mostafa made it 4 unknowns
        SWZE   =32'b1110010110000xxx0xxxxxxxxxxxxxxx, // store word reg-imm zero extend
        SWZERR= 32'b1110011110000xxx0xxx000000000xxx, // store word reg-reg zero extend
        SBZE   =32'b1110010111000xxx0xxxxxxxxxxxxxxx, // store byte reg-imm zero extend
        SBZERR= 32'b1110011111000xxx0xxx000000000xxx, // store byte reg-reg zero extend

        Load =  32'b11100101100100000xxx000000000000,
        LWMAZE  = 32'b1110010110010xxx0xxxxxxxxxxxxxxx, // load word with misaligned feat. reg-imm zero extend
        LWMAZERR= 32'b1110011110010xxx0xxx000000000xxx, // load word with misaligned feat. reg-reg zero extend
        LBMAZE  = 32'b1110010111010xxx0xxxxxxxxxxxxxxx, // load byte with misaligned feat. reg-imm zero extend
        LBMAZERR= 32'b1110011111010xxx0xxx000000000xxx, // load byte with misaligned feat. reg-reg zero extend
        RDPSR =  32'b11100101100000001111000000000000,
        SRwMw   =32'b1110000100000xxx0xxx000010010xxx, // SWAP register with memory
		Sabbram= 32'b1110000101000xxx0xxx000010010xxx  // Swaps a byte between register and memory
    } opcode; 
    // mutual instructions between cores have the same name so we can verify all cores using one scoreboard

       //FLAG PLACE DECLARATION
        parameter LOC_ZF = 30;
        parameter LOC_CF = 29;
        parameter LOC_VF = 28;
        parameter LOC_NF = 31;
    
        //INSTRUCTION FORMAT (for arithmatic)
        parameter RDU = 15;
        parameter   RDL = 12;
        parameter   RS1U = 19;
        parameter   RS1L = 16;
        parameter   RS2U = 3;
        parameter   RS2L = 0;
        
    opcode si_a[];  // opcodes array to store enums so we can randomize and use them
    integer supported_instructions; // number of instructions in the array
    `include "amber_defines.sv"
    `include "GUVM.sv"   // including GUVM classes 
    

    // fill supported instruction array
    function void fill_si_array();
    // this does NOT affect generalism
        `ifndef SET_UP_INSTRUCTION_ARRAY
        `define SET_UP_INSTRUCTION_ARRAY
            opcode si_i; // for iteration only
            supported_instructions = si_i.num();
            si_a = new[supported_instructions];

            si_i = si_i.first();
            for(integer i=0; i < supported_instructions; i++)
                begin
                    si_a[i] = si_i;
                    si_i = si_i.next();
                end
        `endif
    endfunction
    
    function logic update_borrrow_flag(logic carry);
        return !carry ; 
    endfunction


    // function to determine format of verfied instruction and fill its operands
    
    // used in if conditions to compare between (x) and (1 or 0)
    function bit xis1 (logic[31:0] a,logic[31:0] b); 
        logic x;
        // $display("xis1:                 a=%h,b=%h",a,b);
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
    endfunction: xis1

    function opcode findOP(string s);//returns the op code corresponding to string s from package
        foreach(si_a[i]) // supported instruction is number of instructions in opcodes array of the core
        begin
            if(si_a[i].name == s) return si_a[i] ;
        end
        $display("couldnt find %s inside instruction package",s);
        return NOP ; 
    endfunction

endpackage