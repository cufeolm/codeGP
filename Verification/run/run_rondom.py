import os
import random
while (1):
	s = """
[[[ welcome to GUVM user interface ]]]
Compile DUT + Test Bench :  
1- Riscy core (based on RISC-v ISA): enter --> 1 
2- Leon core (based on Sparcv8 ISA): enter --> 2
3- Amber core (based on ARM ISA): enter --> 3
if u want to skip compiling DUT and compile test bench only
Compile Test Bench only :
1- Riscy core (based on RISC-v ISA): enter --> 11 
2- Leon core (based on Sparcv8 ISA): enter --> 22
3- Amber core (based on ARM ISA): enter --> 33
if u want to skip all compiling DUT determine which DUT u want to simulate on
Run Test   :
1- Riscy core (based on RISC-v ISA): enter --> 111
2- Leon core (based on Sparcv8 ISA): enter --> 222
3- Amber core (based on ARM ISA): enter --> 333
any other input will terminate simulation compilation the simulation
DUT: """;
	g = raw_input(s);
	print g;
	if g == "1":
		os.system("vsim -c -do ../testing_riscy/run_riscy.do")
		x=("vsim -c -do \"vsim -novopt top +UVM_TESTNAME=")
	elif g == "2":
		os.system("vsim -c -do ../testing_leon/run_leon.do")
		x=("vsim -c -do \"vsim -novopt top +UVM_TESTNAME=")
	elif g == "3":
		os.system("vsim -c -do ../testing_amber/run_amber.do")
		x=("vsim -c -do \"vsim  top +UVM_TESTNAME=")
	elif g == "11":
		os.system("vsim -c -do ../testing_riscy/run_tb.do")
		x=("vsim -c -do \"vsim -novopt top +UVM_TESTNAME=")
	elif g == "22":
		os.system("vsim -c -do ../testing_leon/run_tb.do")
		x=("vsim -c -do \"vsim -novopt top +UVM_TESTNAME=")
	elif g == "33":
		os.system("vsim -c -do ../testing_amber/run_tb.do")
		x=("vsim -c -do \"vsim -novopt top +UVM_TESTNAME=")
	elif g == "111":
		x=("vsim -c -do \"vsim -novopt top +UVM_TESTNAME=")
	elif g == "222":
		x=("vsim -c -do \"vsim top +UVM_TESTNAME=")
	elif g == "333":
		x=("vsim -c -do \"vsim -novopt top +UVM_TESTNAME=")
	elif g == "w1":
		os.system("vsim -view vsim.wlf -do ../testing_riscy/wave.do")
		break
	elif g == "w2":
		os.system("vsim -view vsim.wlf -do ../testing_leon/wave.do")
		break
	elif g == "w3":
		os.system("vsim -view vsim.wlf -do ../testing_amber/wave.do")
		break
	else:
		print("please enter a valid number")
		break

	s="""
please choose which test to simulate:
1- add_test (based on RISC-v ISA, Sparcv8 ISA, ARM v2a ISA): enter --> 1 
2- branch with flags bief_test (based on sparcv8 ISA,ARM v2a ISA): enter --> 2  
load --> load --> change flag --> branch --> arithmatic command --> store(2)
3- A_type_test (based on RISC-v ISA, Sparcv8 ISA, ARM v2a ISA): enter --> 3     
load --> load --> command --> store(2)
4- load_double_test (based on sparcv8 ISA): enter --> 4
load --> load --> load(2) --> store(2)
5- arithmatic with and without flag arith_flag_test (based on RISC-v ISA, Sparcv8 ISA) -->5
load --> load --> change flag --> command --> check flag --> store 
6- store_test (based on RISC-v ISA, Sparcv8 ISA,ARM v2a ISA) -->6
load --> load --> store(2)
7- mul_test (based on RISC-v ISA, Sparcv8 ISA) -->7
load --> load --> mul(35) --> store(2)
any other input wil terminate the simulation
DUT: """;
	g = raw_input(s);
	print g;
	if g == "1":
		y=("add_test")
		os.system(x+y+" +ARG_INST=A; log /* -r ; run -all ; quit\"")
################################################################################################################
	elif g == "2":
		y=("bief_test")
		instructions_list = ['BIEF','BNEGF','BCSF','BVSF']
		os.system(x+y+" +ARG_INST="+random.choice(instructions_list)+"; log /* -r ; run -all ; quit\"")

################################################################################################################
	elif g == "3":
		y=("A_type_test")
		instructions_list = ['A', 'BIER', 'BIGTOER', 'BILTR', 'BIGTOERU', 'BILTRU' ,'LSBMA','LSHMA','LUBMA', 'LUHMA','LWMA','LW','LDW','LWRR','LSBMARR','LSHMARR','LUBMARR','LUHMARR','LWMARR','LWMAZE','LWMAZERR','LBMAZE','LBMAZERR','SRwMas','SRwM','Sabbram','SRwMw','C','CN','Mov','Mn']    
		os.system(x+y+" +ARG_INST="+random.choice(instructions_list)+"; log /* -r ; run -all ; quit\"")
################################################################################################################
	elif g == "4":
		y=("load_double_test")
		instructions_list = ['LDD', 'LDDRR']
		os.system(x+y+" +ARG_INST="+random.choice(instructions_list)+"; log /* -r ; run -all ; quit\"")
################################################################################################################
	elif g == "5":
		y=("arith_flag_test")
		instructions_list = ['A', 'ADDCC','ADDX','ADDXCC']
		os.system(x+y+" +ARG_INST="+random.choice(instructions_list)+"; log /* -r ; run -all ; quit\"")
		
################################################################################################################
	elif g == "6":
		y=("store_test")
		instructions_list = ['SBMA', 'SHMA', 'SWMA', 'SB', 'SH', 'SW' ,'SBRR','SHRR','SWRR', 'SWZE','SWZERR','SBZE','SBZERR']    
            
		os.system(x+y+" +ARG_INST="+random.choice(instructions_list)+"; log /* -r ; run -all ; quit\"")
################################################################################################################
	elif g == "7": 
		y=("mul_test")
		instructions_list = ['UMULR','MHSR','MHSUR','MHUR']
		os.system(x+y+" +ARG_INST="+random.choice(instructions_list)+"; log /* -r ; run -all ; quit\"")
################################################################################################################
	
################################################################################################################	
	
################################################################################################################
	
			
	else:
		print("please enter a valid number")
		break
	raw_input('Press any key to start again')
	os.system("cls")
