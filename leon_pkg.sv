package leon_package;
   import uvm_pkg::*;
`include "uvm_macros.svh"
      typedef enum logic[31:0] {
      LSB=32'b11xxxxx001001xxxxx1xxxxxxxxxxxxx,
LSH=32'b11xxxxx001010xxxxx1xxxxxxxxxxxxx,
LUB=32'b11xxxxx000001xxxxx1xxxxxxxxxxxxx,
LUH=32'b11xxxxx000010xxxxx1xxxxxxxxxxxxx,
LW= 32'b11xxxxx000000xxxxx1xxxxxxxxxxxxx,
LUW=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx ,    // (NOP)
LDW= 32'b11xxxxx000011xxxxx1xxxxxxxxxxxxx,
LSBfAs=32'b11xxxxx011001xxxxx000001010xxxxx,
LSHfAs=32'b11xxxxx011010xxxxx0xxxxxxxxxxxxx,
LUBfAs=32'b11xxxxx010001xxxxx0xxxxxxxxxxxxx,
LUHfAs=32'b11xxxxx010010xxxxx0xxxxxxxxxxxxx,
LWfAs=32'b11xxxxx010000xxxxx0xxxxxxxxxxxxx,
LDfAs=32'b11xxxxx010011xxxxx0xxxxxxxxxxxxx,
LFR=32'b11xxxxx100000xxxxx1xxxxxxxxxxxxx,
LDFR=32'b11xxxxx100011xxxxx1xxxxxxxxxxxxx,
LFSR=32'b11xxxxx100001xxxxx1xxxxxxxxxxxxx,
LCR=32'b11xxxxx110000xxxxx1xxxxxxxxxxxxx,
LDCR=32'b11xxxxx110011xxxxx1xxxxxxxxxxxxx,
LCSR=32'b11xxxxx100011xxxxx1xxxxxxxxxxxxx,
lmorfsm=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx,    
lmfps=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx  ,    
lmorPfsm=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx,  
SB=32'b11xxxxx000101xxxxx1xxxxxxxxxxxxx, //(i=1)or
SB= 32'b11xxxxx000101xxxxx000000000xxxxx, //(i=0)
SBiAs=32'b11xxxxx010101xxxxx000001010xxxxx,
SH=32'b11xxxxx000110xxxxx1xxxxxxxxxxxx , //(i=1) or
SH=32'b11xxxxx100000xxxxx000000000xxxxx, //(i=0)
SHiAs=32'b11xxxxx010110xxxxx00001010xxxxx,
SW=32'b11xxxxx000100xxxxx1xxxxxxxxxxxxx, //(i=1)or
SW=32'b11xxxxx100000xxxxx000000000xxxxx,
SWiAs=32'b11xxxxx010100xxxxx000001010xxxxx,
SD=32'b11xxxxx000111xxxxx1xxxxxxxxxxxxx,//(i=1)or
SD=32'b11xxxxx100000xxxxx000000000xxxxx,  //(i=0)
SDiAs=32'b11xxxxx010111xxxxx000001010xxxxx,
SF=32'b11xxxxx100100xxxxx1xxxxxxxxxxxxx, //(i=1)or
SF=32'b11xxxxx100000xxxxx000000000xxxxx,  //(i=0)
SDF=32'b11xxxxx100111xxxxx1xxxxxxxxxxxxx,  //(i=1)or
SDF=32'b11xxxxx100111xxxxx000000000xxxxx,  //(i=0)
SFSR=32'b11xxxxx100101xxxxx1xxxxxxxxxxxxx, //(i=1)or
SFSR=32'b11xxxxx100101xxxxx000000000xxxxx,  //(i=0)
SDFdQ=32'b11xxxxx100110xxxxx1xxxxxxxxxxxxx,  //(i=1)or
SDFdQ=32'b11xxxxx100110xxxxx000000000xxxxx, //(i=0)
SC=32'b11xxxxx110100xxxxx1xxxxxxxxxxxxx, //(i=1)or
SC=32'b11xxxxx110100xxxxx000000000xxxxx, //(i=0)
SDC=32'b11xxxxx110111xxxxx1xxxxxxxxxxxxx, //(i=1)or
SDC=32'b11xxxxx110111xxxxx000000000xxxxx, //(i=0)
SCSR=32'b11xxxxx110101xxxxx1xxxxxxxxxxxxx,  //(i=1)or
SCSR=32'b11xxxxx110101xxxxx000000000xxxxx, //(i=0)
SDCdQ=32'b11xxxxx110110xxxxx1xxxxxxxxxxxxx, //(i=1)or
SDCdQ=32'b11xxxxx110110xxxxx000000000xxxxx, //(i=0)
Sm=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx,    //(nop)
SBr=32'b10xxxxx1010000111100000000000000,
ALUB=32'b11xxxxx001101xxxxx1xxxxxxxxxxxxx,
ALUBas=32'b11xxxxx011101xxxxx0xxxxxxxxxxxxx,
SRwM=32'b11xxxxx001111xxxxx1xxxxxxxxxxxxx,
Sabbram=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx,    
SRwMas=32'b11xxxxx011111xxxxx0xxxxxxxxxxxxx,
M=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx,    
UIM=32'b10xxxxx001010xxxxx000000000xxxxx,
UIMi=32'b10xxxxx001010xxxxx1xxxxxxxxxxxxx,
UIMami=32'b10xxxxx011010xxxxx000000000xxxxx,
UIMiami=32'b10xxxxx011010xxxxx1xxxxxxxxxxxxx,
SIM=32'b10xxxxx001011xxxxx000000000xxxxx,
SIMi=32'b10xxxxx001011xxxxx1xxxxxxxxxxxxx,
SIMami=32'b10xxxxx011011xxxxx000000000xxxxx,
SIMiami=32'b10xxxxx011011xxxxx1xxxxxxxxxxxxx,
Mh=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx ,   
Mhs=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx,    
Mhu=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx ,   
MA=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx   , 
UId=32'b10xxxxx001110xxxxx000000000xxxxx,
UIdi=32'b10xxxxx001110xxxxx1xxxxxxxxxxxxx,
UIdami=32'b10xxxxx011110xxxxx000000000xxxxx,
UIdiami=32'b10xxxxx011110xxxxx1xxxxxxxxxxxxx,
SId=32'b10xxxxx001111xxxxx000000000xxxxx,
SIdi=32'b10xxxxx001111xxxxx1xxxxxxxxxxxxx,
SIdami=32'b10xxxxx011111xxxxx000000000xxxxx,
SIdiami=32'b10xxxxx011111xxxxx1xxxxxxxxxxxxx,
Rem=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx ,   
Ru=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx ,   
A=32'b10xxxxx000000xxxxx000000000xxxxx,
Ai=32'b10xxxxx000000xxxxx1xxxxxxxxxxxxx,
Aami=32'b10xxxxx010000xxxxx000000000xxxxx,
Aiami=32'b10xxxxx010000xxxxx1xxxxxxxxxxxxx,
Awc=32'b10xxxxx001000xxxxx000000000xxxxx,
Aiwc=32'b10xxxxx001000xxxxx1xxxxxxxxxxxxx,
Awcami=32'b10xxxxx011000xxxxx000000000xxxxx,
Aiwcami=32'b10xxxxx011000xxxxx1xxxxxxxxxxxxx,
TAami=32'b10xxxxx100000xxxxx000000000xxxxx,
TAiami=32'b10xxxxx100000xxxxx1xxxxxxxxxxxxx,
TAmiatoo=32'b10xxxxx100010xxxxx000000000xxxxx,
TAimiatoo=32'b10xxxxx100010xxxxx1xxxxxxxxxxxxx,
CN=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx ,   
C=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx   , 
S=32'b10xxxxx000100xxxxx000000000xxxxx,
Sim=32'b10xxxxx000100xxxxx1xxxxxxxxxxxxx,
Sami=32'b10xxxxx010100xxxxx000000000xxxxx,
Siami=32'b10xxxxx010100xxxxx1xxxxxxxxxxxxx,
Rs=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx,    
Swc=32'b10xxxxx001100xxxxx000000000xxxxx,
Siwc=32'b10xxxxx001100xxxxx1xxxxxxxxxxxxx,
Swcami=32'b10xxxxx011100xxxxx000000000xxxxx,
Siwcami=32'b10xxxxx011100xxxxx1xxxxxxxxxxxxx,
Rswc=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx,    
Tsami=32'b10xxxxx100001xxxxx000000000xxxxx,
Tsiami=32'b10xxxxx100001xxxxx1xxxxxxxxxxxxx,
Tsmiatoo=32'b10xxxxx100011xxxxx000000000xxxxx,
Tsimiatoo=32'b10xxxxx100011xxxxx1xxxxxxxxxxxxx,
BwA=32'b10xxxxx000001xxxxx000000000xxxxx,
BAI=32'b10xxxxx000001xxxxx1xxxxxxxxxxxxx,
BAamti=32'b10xxxxx010001xxxxx000000000xxxxx,
BAIamti=32'b10xxxxx010001xxxxx1xxxxxxxxxxxxx,
BAwc=32'b10xxxxx000101xxxxx000000000xxxxx,
BAIwc=32'b10xxxxx000101xxxxx1xxxxxxxxxxxxx,
BAwcami=32'b10xxxxx010101xxxxx000000000xxxxx,
BAIwcami=32'b10xxxxx010101xxxxx1xxxxxxxxxxxxx,
BX=32'b10xxxxx000011xxxxx000000000xxxxx,
BXI=32'b10xxxxx000011xxxxx1xxxxxxxxxxxxx,
BXamti=32'b10xxxxx010011xxxxx000000000xxxxx,
BXIamti=32'b10xxxxx010011xxxxx1xxxxxxxxxxxxx,
BXwc=32'b10xxxxx000111xxxxx000000000xxxxx,
BXIwc=32'b10xxxxx000111xxxxx1xxxxxxxxxxxxx,
BXwcami=32'b10xxxxx010111xxxxx000000000xxxxx,
BXIwcami=32'b10xxxxx010111xxxxx1xxxxxxxxxxxxx,
BO=32'b10xxxxx000010xxxxx000000000xxxxx,
BOI=32'b10xxxxx000010xxxxx1xxxxxxxxxxxxx,
BOamti=32'b10xxxxx010010xxxxx000000000xxxxx,
BOIamti=32'b10xxxxx010010xxxxx1xxxxxxxxxxxxx,
BOwc=32'b10xxxxx000110xxxxx000000000xxxxx,
BOIwc=32'b10xxxxx000110xxxxx1xxxxxxxxxxxxx,
BOwcami=32'b10xxxxx010110xxxxx000000000xxxxx,
BOIwcami=32'b10xxxxx010110xxxxx1xxxxxxxxxxxxx,
Sll=32'b10xxxxx100101xxxxx000000000xxxxx,
Srl=32'b10xxxxx100110xxxxx000000000xxxxx,
Sra=32'b10xxxxx100111xxxxx000000000xxxxx,
Slli=32'b10xxxxx100101xxxxx100000000xxxxx,
Srli=32'b10xxxxx100110xxxxx100000000xxxxx,
Srai=32'b10xxxxx100111xxxxx100000000xxxxx,
JaL=32'b10xxxxx111000xxxxx1xxxxxxxxxxxxx, //(i=1)or
Jal=32'b10xxxxx111000xxxxx000000000xxxxx, //(i=0)
JaLr=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx ,   
RfT=32'b1000000111001xxxxx1xxxxxxxxxxxxx,  //(i=1)or
RfT=32'b1000000111001xxxxx000000000xxxxx, //(i=0)
//CaL=

/* note: Is unconditional branche such that
If its annul field (a) is 0, a BN (Branch Never)
 instruction acts like a
“NOP”. If its annul field is 1,
 the following (delay) instruction is
annulled (not executed). In neither
 case does a transfer of control take
 place.*/
BN=32'b0010000010xxxxxxxxxxxxxxxxxxxxxx,
BA=32'b0011000010xxxxxxxxxxxxxxxxxxxxxx,
BTA=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx,    
BAL=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx ,   
Bie=32'b0010001010xxxxxxxxxxxxxxxxxxxxxx,
Bine=32'b0011001010xxxxxxxxxxxxxxxxxxxxxx,
Bigtoe=32'b0011011010xxxxxxxxxxxxxxxxxxxxxx,
Biltoe=32'b0010010010xxxxxxxxxxxxxxxxxxxxxx,
Bigtoeu=32'b0011101010xxxxxxxxxxxxxxxxxxxxxx,
Biltoeu=32'b0010100010xxxxxxxxxxxxxxxxxxxxxx,
Biei=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx,    
Binei=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx ,
BoG=32'b0011010010xxxxxxxxxxxxxxxxxxxxxx,
BoLoE=32'b0010010010xxxxxxxxxxxxxxxxxxxxxx,
BoL=32'b0010011010xxxxxxxxxxxxxxxxxxxxxx,
BoGU=32'b0011100010xxxxxxxxxxxxxxxxxxxxxx,
BoCSLtU=32'b0010101010xxxxxxxxxxxxxxxxxxxxxx,
BoP=32'b0011110010xxxxxxxxxxxxxxxxxxxxxx,
BoN=32'b0010110010xxxxxxxxxxxxxxxxxxxxxx,
BoOC=32'b0011111010xxxxxxxxxxxxxxxxxxxxxx,
BoOS=32'b0010111010xxxxxxxxxxxxxxxxxxxxxx,
//BoCCC=
Sh2b=32'b00xxxxx100xxxxxxxxxxxxxxxxxxxxxx,
Sav=32'b10xxxxx111100xxxxx000000000xxxxx,
Si=32'b10xxxxx111100xxxxx1xxxxxxxxxxxxx,
R=32'b10xxxxx111101xxxxx000000000xxxxx,
Ri=32'b10xxxxx111101xxxxx1xxxxxxxxxxxxx,
Mtrfc=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx,    
Mtcfr=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx ,   
Mn=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx,    
Mov=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx  ,  
RY=32'b10xxxxx1010000000000000000000000,
RP=32'b10xxxxx101001?????00000000000000,
Rw=32'b10xxxxx101010?????00000000000000,
Rt=32'b10xxxxx101011?????00000000000000,
Ra=32'b10xxxxx101000xxxxx00000000000000,
WfrtY=32'b1000000110000xxxxx000000000xxxxx,
WfitY=32'b1000000110000xxxxx1xxxxxxxxxxxxx,
Wfrtp=32'b10?????110001xxxxx000000000xxxxx,
Wfitp=32'b10?????110001xxxxx1xxxxxxxxxxxxx,
Wfrtw=32'b10?????110010xxxxx000000000xxxxx,
Wfitw=32'b10?????110010xxxxx1xxxxxxxxxxxxx,
Wfrtt=32'b10?????110011xxxxx000000000xxxxx,
Wfitt=32'b10?????110011xxxxx1xxxxxxxxxxxxx,
Swi=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx ,
N=32'b0000000100xxxxxxxxxxxxxxxxxxxxxx  ,  
CO1=32'b10xxxxx110110xxxxxxxxxxxxxxxxxxx,
CO2=32'b10xxxxx110111xxxxxxxxxxxxxxxxxxx,
TA=32'b10?1000111010xxxxx1??????xxxxxxx,  //(i=1)or
TA=32'b10?1000111010xxxxx0????????xxxxx,  //(i=0)
TN=32'b10?0000111010xxxxx1??????xxxxxxx,  //(i=1)or
TN=32'b10?1000111010xxxxx0????????xxxxx,  //(i=0)
ToNE=32'b10?1001111010xxxxx1??????xxxxxxx,  //(i=1)or
ToNE=32'b10?1000111010xxxxx0????????xxxxx, //(i=0)
ToE=32'b10?0001111010xxxxx1??????xxxxxxx, //(i=1)or
ToE=32'b10?0001111010xxxxx0????????xxxxx, //(i=0)
ToG=32'b10?1010111010xxxxx1??????xxxxxxx , //(i=1)or
ToG=32'b10?1010111010xxxxx0????????xxxxx,  //(i=0)
ToLoE=32'b10?0010111010xxxxx1??????xxxxxxx, //(i=1)or
ToLoE=32'b10?0010111010xxxxx0????????xxxxx, //(i=0)
ToGoE=32'b10?1011111010xxxxx1??????xxxxxxx , //(i=1)or
ToGoE=32'b10?1011111010xxxxx0????????xxxxx,  //(i=0)
ToL=32'b10?0011111010xxxxx1??????xxxxxxx,  //(i=1)or
ToL=32'b10?0011111010xxxxx0????????xxxxx, //(i=0)
ToGU=32'b10?1100111010xxxxx1??????xxxxxxx,  //(i=1)or
ToGU=32'b10?1100111010xxxxx0????????xxxxx, //(i=0)
ToLoEU=32'b10?0100111010xxxxx1??????xxxxxxx,//(i=1)or
ToLoEU=32'b10?0100111010xxxxx0????????xxxxx, //(i=0)
ToCCGtoEU=32'b10?1101111010xxxxx1??????xxxxxxx, //(i=1)or
32'b10?1101111010xxxxx0????????xxxxx, //(i=0)
ToCSLTU=32'b10?0101111010xxxxx1??????xxxxxxx, //(i=1)or
ToCSLTU=32'b10?0101111010xxxxx0????????xxxxx, //(i=0)
ToP=32'b10?1110111010xxxxx1??????xxxxxxx, //(i=1)or
ToP=32'b10?1110111010xxxxx0????????xxxxx, //(i=0)
ToN=32'b10?0110111010xxxxx1??????xxxxxxx,  //(i=1)or
ToN=32'b10?0110111010xxxxx0????????xxxxx, //(i=0)
ToOC=32'b10?1111111010xxxxx1??????xxxxxxx,  //(i=1)or
ToOC=32'b10?1111111010xxxxx0????????xxxxx, //(i=0)
ToOS=32'b10?0111111010xxxxx1??????xxxxxxx, //(i=1)or
ToOS=32'b10?0111111010xxxxx0????????xxxxx, //(i=0)
Ui=32'b00?????000xxxxxxxxxxxxxxxxxxxxxx,
Fim=32'b1000000111011xxxxx1xxxxxxxxxxxxx, //(i=1)or
Fim=32'b1000000111011xxxxx000000000xxxxx //(i=0)
           
            } opcode;
   
endpackage