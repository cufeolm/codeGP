import os

s="""
welcome to GUVM user interface
please choose which dut to compile :
1-riscy:based on RISC-v ISA 
2-leon :based on Sparcv8 ISA 
3-amber:based on ARM ISA 
DUT: """;






g = raw_input(s) ;
print g ;
if g == "1":
  os.system("vsim -c -do riscy/run_riscy.do" )
elif g == "2":
  os.system("vsim -c -do leon/run_leon.do")
elif g == "3":
  os.system("vsim -c -do amber/run_amber.do")
else :
  print("please enter a valid number")
  
input('Press any key to exit')