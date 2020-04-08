# GUVM


---

## Table of Contents 

> If your `README` has a lot of info, section headers might be nice.

- [Installation](#Installation)
- [Features](#features)
- [Files](#Files)
- [Team](#team)

---

---

## Installation

- needed software 
>questasim V10.4e or higher,
>python v 2.7 or higher
### Clone

- Clone this repo to your local machine using `https://github.com/cufeolm/codeGP`

### Run

- open Run.py on your machine 

---

## Features
the testbench supports 1 instruction(add) to be tested across diffreant duts 
### DUTS 
1-riscy:based on RISC-v ISA  
2-leon :based on Sparcv8 ISA   
3-amber:based on ARM ISA   

---

## Files

a breif describtion of the Files in GUVM test bench
the test bench itself (uvm code) is inside GUVM file

### ROOT file (CodeGP)
- amber       : contains dut,interface,pakage,sequence item,top module and do files for amber
- doc         : contains documentation for the test bench
- full_pkgs   : still under development (not compiled currently) 
- GUVM        : contains generic UVM code that is responsible for testing the duts
- leon        : contains dut,interface,pakage,sequence item,top module and do files for leon
- riscy       : contains dut,interface,pakage,sequence item,top module and do files for riscy
- a.bat       : runs the test bench for amber dut on windows os
- GUVM.SV     : Contains the include files for GUVM test bench 
- l.bat       : runs the test bench for leon dut on windows os
- r.bat       : runs the test bench for riscy dut on windows os
- run.py      : runs the test bench for any chosen dut

### GUVM
	contains the generic uvm test bench
### Amber
- DUT    
	Amber verilog dut
- amber_interface.sv    
	amber interface used in UVM test bench    
	we are still trying to make some sort of as generic as possible interface    
	so currently we made an interface for each dut    
- amber_pkg.sv         
	contains the opcodes and instructions supported by amber DUT 
- amber_seq_item.sv    
	responsible for providing the instruction formats     
	that are supported by amber to the GUVM_Sequence   
- dut_amber.f     
	tells questasim where to find the dut       
- run_amber.do       
	resposible for compiling the whole testbench for amber dut     
- target_pkg.sv    
	determines which package to be be compiled ; in this case amber     
- target_sequence_item.sv    
	determines which sequence item to be be compiled ; in this case amber       
- top.sv    
	top module for the test bench ; in this case amber      
### Leon
- DUT    
	leon verilog dut
- leon_interface.sv    
	leon interface used in UVM test bench    
	we are still trying to make some sort of as generic as possible interface    
	so currently we made an interface for each dut    
- leon_pkg.sv         
	contains the opcodes and instructions supported by leon DUT 
- leon_seq_item.sv    
	responsible for providing the instruction formats     
	that are supported by leon to the GUVM_Sequence   
- dut_leon.f     
	tells questasim where to find the dut       
- run_leon.do       
	resposible for compiling the whole testbench for leon dut     
- target_pkg.sv    
	determines which package to be be compiled ; in this case leon     
- target_sequence_item.sv    
	determines which sequence item to be be compiled ; in this case leon       
- top.sv    
	top module for the test bench ; in this case leon   

### riscy
- DUT    
	riscy verilog dut
- riscy_interface.sv    
	riscy interface used in UVM test bench    
	we are still trying to make some sort of as generic as possible interface    
	so currently we made an interface for each dut    
- riscy_pkg.sv         
	contains the opcodes and instructions supported by riscy DUT 
- riscy_seq_item.sv    
	responsible for providing the instruction formats     
	that are supported by riscy to the GUVM_Sequence   
- dut_riscy.f     
	tells questasim where to find the dut       
- run_riscy.do       
	resposible for compiling the whole testbench for riscy dut     
- target_pkg.sv    
	determines which package to be be compiled ; in this case riscy     
- target_sequence_item.sv    
	determines which sequence item to be be compiled ; in this case riscy       
- top.sv    
	top module for the test bench ; in this case riscy 	

---

## Team

> Or Contributors
1. Kholoud Mahmoud    
2. Randa Ahmed     
3. Karim Ayman     
4. Mostafa Ayman     
5. Waleed Samy Taie     
6. Yasser Ibrahim     

---


---
