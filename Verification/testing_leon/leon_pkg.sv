package target_package;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    // instructions opcodes verified in this core 
    typedef enum logic [31:0] {
        LSBMA=32'b11xxxxx001001xxxxx1xxxxxxxxxxxxx, // load signed byte with misalignment feat. reg-imm
        LSH=32'b11xxxxx001010xxxxx1xxxxxxxxxxxxx, // load signed half word reg-imm
        LUBMA=32'b11xxxxx000001xxxxx1xxxxxxxxxxxxx, // load unsigned byte with misalignment feat. reg-imm
        LUH=32'b11xxxxx000010xxxxx1xxxxxxxxxxxxx, // load unsigned half word reg-imm
        LDD= 32'b1100010000011xxxxx10000000000110, // load double word reg-imm
        LWRR=32'b11xxxxx010000xxxxx0xxxxxxxxxxxxx, // load word reg-reg (from alternate space)
        LDDRR=32'b1100010010011xxxxx0xxxxxxxxxxxxx, // load double word reg-reg
        LSBMARR=32'b11xxxxx011001xxxxx000001010xxxxx, // load signed byte reg-reg
        LSHRR=32'b11xxxxx011010xxxxx0xxxxxxxxxxxxx, // load signed half word reg-reg
        LUBRR=32'b11xxxxx010001xxxxx0xxxxxxxxxxxxx, // load unsigned byte reg-reg
        LUHRR=32'b11xxxxx010010xxxxx0xxxxxxxxxxxxx, // load unsigned half word reg-reg

        SB=32'b11xxxxx000101xxxxx1xxxxxxxxxxxxx, // store least significant byte reg-imm
        SBRR=32'b11xxxxx010101xxxxx000001010xxxxx, // store least significant byte reg-reg
        SH=32'b11xxxxx000110xxxxx1xxxxxxxxxxxxx, // store least significant half word reg-imm
        SHRR=32'b11xxxxx010110xxxxx00001010xxxxxx, // store least significant half word reg-reg
        SWRR=32'b11xxxxx010100xxxxx000001010xxxxx, // store word reg-reg
        SD=32'b11xxxxx000111xxxxx1xxxxxxxxxxxxx, // store double word reg-imm
        SDRR=32'b11xxxxx010111xxxxx000001010xxxxx, // store double word reg-reg

        A=32'b10xxxxx000000xxxxx000000000xxxxx,
        ADDCC=32'b10xxxxx010000xxxxx000000000xxxxx,
        ADDX =32'b10xxxxx001000xxxxx000000000xxxxx,
        ADDXCC=32'b10xxxxx011000xxxxx000000000xxxxx,

        Ai=32'b10xxxxx000000xxxxx1xxxxxxxxxxxxx,
        Jalr_cpc=32'b10xxxxx111000xxxxx10000000001100,
        Jalrr=32'b10xxxxx111000xxxxx000000000xxxxx,
        NOP=32'b00000001000000000000000000000000,
        SUB=32'b10xxxxx000100xxxxx000000000xxxxx,
        SUBX=32'b10xxxxx001100xxxxx000000000xxxxx,
        SUBCC=32'b10xxxxx010100xxxxx000000000xxxxx,
        SUBXCC=32'b10xxxxx011100xxxxx000000000xxxxx,

        UMULR=32'b10xxxxx001010xxxxx000000000xxxxx, // multiply reg-reg
        UDIVR=32'b10xxxxx001110xxxxx000000000xxxxx,

        BIEF=32'b00x0001010xxxxxxxxxxxxxxxxxxxxxx,
        BCSF = 32'b00x0101010xxxxxxxxxxxxxxxxxxxxxx,
        BNEGF = 32'b00x0110010xxxxxxxxxxxxxxxxxxxxxx,
        BVSF = 32'b00x0111010xxxxxxxxxxxxxxxxxxxxxx,

        BA= 32'b00x1000010xxxxxxxxxxxxxxxxxxxxxx,

        RDPSR=32'b10xxxxx101001xxxxx00000000000000,
        //BIEF=32'b0010001010xxxxxxxxxxxxxxxxxxxxxx,
        Store =32'b11xxxxx0001000000010000000000000,
        SW=32'b11xxxxx000100xxxxx1xxxxxxxxxxxxx, // store word reg-imm
        Load = 32'b11xxxxx0000000000010000000000000,
        LW= 32'b11xxxxx000000xxxxx1xxxxxxxxxxxxx // load word reg-imm
    } opcode;
    

    //FLAG PLACE DECLARATION
    parameter LOC_ZF = 22;
    parameter LOC_CF = 20;
    parameter LOC_VF = 21;
    parameter LOC_NF = 23;
    //INSTRUCTION FORMAT 
    parameter RDU = 29;
    parameter   RDL = 25;
    parameter   RS1U = 18;
    parameter   RS1L = 14;
    parameter   RS2U = 4;
    parameter   RS2L = 0;
    
    // mutual instructions between cores have the same name so we can verify all cores using one scoreboard

    opcode si_a [] ;    // opcodes array to store enums so we can randomize and use them
    integer supported_instructions ;    // number of instructions in the array
    `include "leon_defines.sv"
    `include"GUVM.sv"   // including GUVM classes 
    

    function logic update_borrrow_flag(logic carry);
        return carry ; 
    endfunction

    // fill supported instruction array
    function void fill_si_array();
    // this does NOT  affect generalism
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
    `endif
    endfunction
        // used in if conditions to compare between (x) and (1 or 0)
    function bit xis1 (logic[31:0] a,logic[31:0] b);
        logic x;
        x = (a == b);
        if(x==1) return 1 ;
        else if (x === 1'bx)
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