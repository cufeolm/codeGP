import os

s = """
[[[ welcome to GUVM user interface ]]]
please choose which dut to compile:
1- Riscy core (based on RISC-v ISA): enter --> 1 
2- Leon core: (based on Sparcv8 ISA): enter --> 2
3- Amber core: (based on ARM ISA): enter --> 3
DUT: """;

g = raw_input(s);
print g;
if g == "1":
  os.system("vsim -c -do riscy/run_riscy.do")
elif g == "2":
  os.system("vsim -c -do leon/run_leon.do")
elif g == "3":
  os.system("vsim -c -do amber/run_amber.do")
else:
  print("please enter a valid number")

input('Press any key to exit')