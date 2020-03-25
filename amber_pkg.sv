package amber_package;
   import uvm_pkg::*;
`include "uvm_macros.svh"
      typedef enum logic[31:0] {
      LSB=32'b11110000100000000001000000000010, //nop
      LSH=32'b11110000100000000001000000000010, //nop
      LUB=32'bxxxx01xxxxxxxxxxxxxxxxxxxxxxxxxx,
      LUH=32'b11110000100000000001000000000010,
       LW=32'bxxxx01xxxxxxxxxxxxxxxxxxxxxxxxxx,
      LUW=32'b11110000100000000001000000000010, //nop
      LDW=32'b11110000100000000001000000000010, //nop
   LSBfAs=32'b11110000100000000001000000000010, //nop
   LSHfAs=32'b11110000100000000001000000000010, //nop
   LUBfAs=32'b11110000100000000001000000000010, //nop
   LUHfAs=32'b11110000100000000001000000000010, //nop
    LWfAs=32'b11110000100000000001000000000010, //nop
    LDfAs=32'b11110000100000000001000000000010, //nop
      LFR=32'b11110000100000000001000000000010, //nop
     LDFR=32'b11110000100000000001000000000010, //nop
     LFSR=32'b11110000100000000001000000000010, //nop
      LCR=32'bxxxx110xxxxxxxxxxxxxxxxxxxxxxxxx,
     LDCR=32'b11110000100000000001000000000010, //nop
     LCSR=32'b11110000100000000001000000000010, //nop
  lmorfsm=32'bxxxx100xxxxxxxxxxxxxxxxxxxxxxxxx,
    lmfps=32'bxxxx100xxxxxxxxxxxxxxxxxxxxxxxxx,
 lmorPfsm=32'bxxxx100xxxxxxxxxxxxxxxxxxxxxxxxx,
       SB=32'bxxxx01xxxxx0xxxxxxxxxxxxxxxxxxxx,
    SBiAs=32'b11110000100000000001000000000010, //nop
       SH=32'b11110000100000000001000000000010, //nop
    SHiAs=32'b11110000100000000001000000000010, //nop
       SW=32'bxxxx01xxxxxxxxxxxxxxxxxxxxxxxxxx,
    SWiAs=32'b11110000100000000001000000000010, //nop
       SD=32'b11110000100000000001000000000010, //nop
    SDiAs=32'b11110000100000000001000000000010, //nop
       SF=32'b11110000100000000001000000000010, //nop
      SDF=32'b11110000100000000001000000000010, //nop
     SFSR=32'b11110000100000000001000000000010, //nop
    SDFdQ=32'b11110000100000000001000000000010, //nop
       SC=32'b11110000100000000001000000000010, //nop
      SDC=32'b11110000100000000001000000000010, //nop
     SCSR=32'b11110000100000000001000000000010, //nop
    SDCdQ=32'b11110000100000000001000000000010, //nop
       Sm=32'bxxxx100xxxx0xxxxxxxxxxxxxxxxxxxx,
      SBr=32'b11110000100000000001000000000010, //nop
     ALUB=32'b11110000100000000001000000000010, //nop
   ALUBas=32'b11110000100000000001000000000010, //nop
     SRwM=32'bxxxx00010x00xxxxxxxx00001001xxxx,
  Sabbram=32'bxxxx00010x00xxxxxxxx00001001xxxx,
   SRwMas=32'b11110000100000000001000000000010, //nop
        M=32'bxxxx00000011xxxxxxxxxxxx1001xxxx,
      UIM=32'b11110000100000000001000000000010, //nop
     UIMi=32'b11110000100000000001000000000010, //nop
   UIMami=32'b11110000100000000001000000000010, //nop
  UIMiami=32'b11110000100000000001000000000010, //nop
      SIM=32'b11110000100000000001000000000010, //nop
     SIMi=32'b11110000100000000001000000000010, //nop
   SIMami=32'b11110000100000000001000000000010, //nop
  SIMiami=32'b11110000100000000001000000000010, //nop
       Mh=32'b11110000100000000001000000000010, //nop
      Mhs=32'b11110000100000000001000000000010, //nop
      Mhu=32'b11110000100000000001000000000010, //nop
       MA=32'bxxxx00000011xxxxxxxxxxxx1001xxxx,
      UId=32'b11110000100000000001000000000010, //nop
     UIdi=32'b11110000100000000001000000000010, //nop
   UIdami=32'b11110000100000000001000000000010, //nop
  UIdiami=32'b11110000100000000001000000000010, //nop
      SId=32'b11110000100000000001000000000010, //nop
     SIdi=32'b11110000100000000001000000000010, //nop
   SIdami=32'b11110000100000000001000000000010, //nop
  SIdiami=32'b11110000100000000001000000000010, //nop
      Rem=32'b11110000100000000001000000000010, //nop
       Ru=32'b11110000100000000001000000000010, //nop
        A=32'bxxxx00x0100xxxxxxxxxxxxxxxxxxxxx,
       Ai=32'b11110000100000000001000000000010, //nop
     Aami=32'b11110000100000000001000000000010, //nop
    Aiami=32'b11110000100000000001000000000010, //nop
      Awc=32'bxxxx00x0101xxxxxxxxxxxxxxxxxxxxx,
     Aiwc=32'b11110000100000000001000000000010, //nop
   Awcami=32'b11110000100000000001000000000010, //nop
  Aiwcami=32'b11110000100000000001000000000010, //nop
    TAami=32'b11110000100000000001000000000010, //nop
   TAiami=32'b11110000100000000001000000000010, //nop
 TAmiatoo=32'b11110000100000000001000000000010, //nop
TAimiatoo=32'b11110000100000000001000000000010, //nop
       CN=32'bxxxx00x1011xxxxxxxxxxxxxxxxxxxxx,
        C=32'bxxxx00x1010xxxxxxxxxxxxxxxxxxxxx,
        S=32'bxxxx0010010xxxxxxxxxxxxxxxxxxxxx,
      Sim=32'b11110000100000000001000000000010, //nop
     Sami=32'b11110000100000000001000000000010, //nop
    Siami=32'b11110000100000000001000000000010, //nop
       Rs=32'bxxxx00x0011xxxxxxxxxxxxxxxxxxxxx,
      Swc=32'bxxxx0010110xxxxxxxxxxxxxxxxxxxxx,
     Siwc=32'b11110000100000000001000000000010, //nop
   Swcami=32'b11110000100000000001000000000010, //nop
  Siwcami=32'b11110000100000000001000000000010, //nop
     Rswc=32'bxxxx0010100xxxxxxxxxxxxxxxxxxxxx,
    Tsami=32'b11110000100000000001000000000010, //nop
   Tsiami=32'b11110000100000000001000000000010, //nop
 Tsmiatoo=32'b11110000100000000001000000000010, //nop
Tsimiatoo=32'b11110000100000000001000000000010, //nop
      BwA=32'bxxxx00x0000xxxxxxxxxxxxxxxxxxxxx,
      BAI=32'b11110000100000000001000000000010, //nop
   BAamti=32'b11110000100000000001000000000010, //nop
  BAIamti=32'b11110000100000000001000000000010, //nop
     BAwc=32'bxxxx00x1110xxxxxxxxxxxxxxxxxxxxx,
    BAIwc=32'b11110000100000000001000000000010, //nop
  BAwcami=32'b11110000100000000001000000000010, //nop
 BAIwcami=32'b11110000100000000001000000000010, //nop
       BX=32'bxxxx00x0001xxxxxxxxxxxxxxxxxxxxx,
      BXI=32'b11110000100000000001000000000010, //nop
   BXamti=32'b11110000100000000001000000000010, //nop
  BXIamti=32'b11110000100000000001000000000010, //nop
     BXwc=32'b11110000100000000001000000000010, //nop
    BXIwc=32'b11110000100000000001000000000010, //nop
  BXwcami=32'b11110000100000000001000000000010, //nop
 BXIwcami=32'b11110000100000000001000000000010, //nop
       BO=32'bxxxx00x1100xxxxxxxxxxxxxxxxxxxxx,
      BOI=32'b11110000100000000001000000000010, //nop
   BOamti=32'b11110000100000000001000000000010, //nop
  BOIamti=32'b11110000100000000001000000000010, //nop
     BOwc=32'b11110000100000000001000000000010, //nop
    BOIwc=32'b11110000100000000001000000000010, //nop
  BOwcami=32'b11110000100000000001000000000010, //nop
 BOIwcami=32'b11110000100000000001000000000010, //nop
      Sll=32'b11110000100000000001000000000010, //nop
      Srl=32'b11110000100000000001000000000010, //nop
      Sra=32'b11110000100000000001000000000010, //nop
     Slli=32'b11110000100000000001000000000010, //nop
     Srli=32'b11110000100000000001000000000010, //nop
     Srai=32'b11110000100000000001000000000010, //nop
      JaL=32'b11110000100000000001000000000010, //nop
     JaLr=32'b11110000100000000001000000000010, //nop
      RfT=32'b11110000100000000001000000000010, //nop
      CaL=32'b11110000100000000001000000000010, //nop
       BN=32'b11110000100000000001000000000010, //nop
       BA=32'b11110000100000000001000000000010, //nop
      BTA=32'bxxxx1011xxxxxxxxxxxxxxxxxxxxxxxx,
      BAL=32'bxxxx1011xxxxxxxxxxxxxxxxxxxxxxxx,
      Bie=32'b11110000100000000001000000000010, //nop
     Bine=32'b11110000100000000001000000000010, //nop
   Bigtoe=32'b11110000100000000001000000000010, //nop
   Biltoe=32'b11110000100000000001000000000010, //nop
  Bigtoeu=32'b11110000100000000001000000000010, //nop
  Biltoeu=32'b11110000100000000001000000000010, //nop
     Biei=32'b11110000100000000001000000000010, //nop
    Binei=32'b11110000100000000001000000000010, //nop
      BoG=32'b11110000100000000001000000000010, //nop
    BoLoE=32'b11110000100000000001000000000010, //nop
      BoL=32'b11110000100000000001000000000010, //nop
     BoGU=32'b11110000100000000001000000000010, //nop
  BoCSLtU=32'b11110000100000000001000000000010, //nop
      BoP=32'b11110000100000000001000000000010, //nop
      BoN=32'b11110000100000000001000000000010, //nop
     BoOC=32'b11110000100000000001000000000010, //nop
     BoOS=32'b11110000100000000001000000000010, //nop
    BoCCC=32'b11110000100000000001000000000010, //nop
     Sh2b=32'b11110000100000000001000000000010, //nop
      Sav=32'b11110000100000000001000000000010, //nop
       Si=32'b11110000100000000001000000000010, //nop
        R=32'b11110000100000000001000000000010, //nop
       Ri=32'b11110000100000000001000000000010, //nop
  //Mtrfc=32'bxxxx1110xxxxxxxxxxxxxxx1xxxx
  //Mtcfr=
       Mn=32'bxxxx00x1111xxxxxxxxxxxxxxxxxxxxx,
      Mov=32'bxxxx00x1101xxxxxxxxxxxxxxxxxxxxx,
       RY=32'b11110000100000000001000000000010, //nop
       RP=32'b11110000100000000001000000000010, //nop
       Rw=32'b11110000100000000001000000000010, //nop
       Rt=32'b11110000100000000001000000000010, //nop
       Ra=32'b11110000100000000001000000000010, //nop
    WfrtY=32'b11110000100000000001000000000010, //nop
    WfitY=32'b11110000100000000001000000000010, //nop
    Wfrtp=32'b11110000100000000001000000000010, //nop
    Wfitp=32'b11110000100000000001000000000010, //nop
    Wfrtw=32'b11110000100000000001000000000010, //nop
    Wfitw=32'b11110000100000000001000000000010, //nop
    Wfrtt=32'b11110000100000000001000000000010, //nop
    Wfitt=32'b11110000100000000001000000000010, //nop
      Swi=32'bxxxx1111xxxxxxxxxxxxxxxxxxxxxxxx,
        N=32'b11110000100000000001000000000010, //nop
      CO1=32'b11110000100000000001000000000010, //nop
      CO2=32'b11110000100000000001000000000010, //nop
       TA=32'b11110000100000000001000000000010, //nop
       TN=32'b11110000100000000001000000000010, //nop
     ToNE=32'b11110000100000000001000000000010, //nop
      ToE=32'b11110000100000000001000000000010, //nop
      ToG=32'b11110000100000000001000000000010, //nop
    ToLoE=32'b11110000100000000001000000000010, //nop
    ToGoE=32'b11110000100000000001000000000010, //nop
      ToL=32'b11110000100000000001000000000010, //nop
     ToGU=32'b11110000100000000001000000000010, //nop
   ToLoEU=32'b11110000100000000001000000000010, //nop
ToCCGtoEU=32'b11110000100000000001000000000010, //nop
  ToCSLTU=32'b11110000100000000001000000000010, //nop
      ToP=32'b11110000100000000001000000000010, //nop
      ToN=32'b11110000100000000001000000000010, //nop
     ToOC=32'b11110000100000000001000000000010, //nop
     ToOS=32'b11110000100000000001000000000010, //nop
       Ui=32'b11110000100000000001000000000010, //nop
      Fim=32'b11110000100000000001000000000010 //nop
	             } opcode;
   
   function GUVM_sequence_item get_format (logic [31:0] inst);
	amber_seq_item ay;
	GUVM_sequence_item k ;
	k = new("k");
   ay = new("ay");
	ay.cond = inst[31:28];
		case (inst[27:25])
			3'b000 :
					begin 
						if(inst[4] == 1'b0)
							begin
								if(inst[11:7] == 5'b00000)
									begin
										ay.rn = inst[19:16];
										ay.rd = inst[15:12];
										ay.rm = inst[3:0];
										ay.s = inst[20];
									end
								else
									begin
										ay.shift = inst[6:5];
										ay.shift_imm = inst[11:7];
										ay.rn = inst[19:16];
										ay.rd = inst[15:12];
										ay.rm = inst[3:0];
										ay.s = inst[20];
									end
							end
						else if (inst[7] == 1'b0)
							begin 
								ay.rn = inst[19:16];
								ay.rd = inst[15:12];
								ay.rm = inst[3:0];
								ay.s = inst[20];
								ay.shift = inst[6:5];
								ay.rs = inst[11:8];
							end
						else if (inst[24] == 1'b0)
							begin
								ay.rd = inst[19:16];
								ay.rn = inst[15:12];
								ay.rs = inst[11:8];
								ay.rm = inst[3:0];
								ay.s = inst[20];
								ay.a = inst[21];
							end
						else
							begin 
								ay.rn = inst[19:16];
								ay.rd = inst[15:12];
								ay.rm = inst[3:0];
								ay.b = inst[22];
							end
					end
			3'b001 :
					begin 
						ay.rn = inst[19:16];
						ay.rd = inst[15:12];
						ay.s = inst[20];
						ay.encode_imm = inst[11:8];
						ay.imm8 = inst[7:0];
					end
			3'b010 :
					begin
						ay.rn = inst[19:16];
						ay.rd = inst[15:12];
						ay.offset12 = inst[11:0];
						ay.p = inst[24];
						ay.u = inst[23];
						ay.b = inst[22];
						ay.w = inst[21];
						ay.l = inst[20];
					end
			3'b011 :
					begin
						ay.rn = inst[19:16];
						ay.rd = inst[15:12];
						ay.rm = inst[3:0];
						ay.p = inst[24];
						ay.u = inst[23];
						ay.b = inst[22];
						ay.w = inst[21];
						ay.l = inst[20];
						ay.shift = inst[6:5];
						ay.shift_imm = inst[11:7];
					end
			3'b100 :
					begin
						ay.rn = inst[19:16];
						ay.register_list = inst[15:0];
						ay.p = inst[24];
						ay.u = inst[23];
						ay.s = inst[22];
						ay.w = inst[21];
						ay.l = inst[20];
					end
			3'b101 :
					begin
						ay.l = inst[24];
						au.offset24 = inst[23:0];
					end
			3'b110 :
					begin
						ay.rn = inst[19:16];
						ay.crd = inst[15:12];
						ay.cphash = inst[11:8];
						ay.offset8 = inst[7:0];
						ay.p = inst[24];
						ay.u = inst[23];
						ay.n = inst[22];
						ay.w = inst[21];
						ay.l = inst[20];
					end
			3'b111 :
					begin
						if(inst[24] == 1'b0)
							begin
								if (inst[4] == 1'b0)
									begin
										ay.cp_opcode4 = inst[23:20];
										ay.crn = inst[19:16];
										ay.crd = inst[15:12];
										ay.cphash = inst[11:8];
										ay.cp = inst[7:5];
										ay.crm = inst[3:0];
									end
								else
									begin
										ay.cp_opcode3 = inst[23:21];
										ay.l = inst[20];
										ay.crn = inst[19:16];
										ay.crd = inst[15:12];
										ay.cphash = inst[11:8];
										ay.cp = inst[7:5];
										ay.crm = inst[3:0];
									end
							end
						else
							begin
								ay.ibc = inst[23:0];
							end
						
					end
			end		
		if (!($cast(ay,k))) 
			$fatal(1,"failed to cast transaction to leon's transaction"); 
		return k;
	endfunction 
	
endpackage