
# GUVM

> Subtitle or Short Description Goes Here

> ideally one sentence

> include terms/tags that can be searched


---

## Table of Contents (Optional)

> If your `README` has a lot of info, section headers might be nice.

- [Installation](#Installation)
- [Features](#features)
- [Files](#Files)
- [Team](#team)
- [FAQ](#faq)

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
- full_pkgs   : still under development (not compiled currently) 
- GUVM        : contains generic UVM code that is responsible for testing the duts
- leon        : contains dut,interface,pakage,sequence item,top module and do files for leon
- riscy       : contains dut,interface,pakage,sequence item,top module and do files for riscy
- a.bat       : runs the test bench for amber dut on windows os
- GUVM.SV     : Contains the include files for GUVM test bench 
- l.bat       : runs the test bench for leon dut on windows os
- r.bat       : runs the test bench for riscy dut on windows os
- run.py      : runs the test bench for any chosen dut


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
### Step 3

- ðŸ”ƒ Create a new pull request using <a href="https://github.com/joanaz/HireDot2/compare/" target="_blank">`https://github.com/joanaz/HireDot2/compare/`</a>.

---

## Team

> Or Contributors/People

| <a href="http://fvcproductions.com" target="_blank">**FVCproductions**</a> | <a href="http://fvcproductions.com" target="_blank">**FVCproductions**</a> | <a href="http://fvcproductions.com" target="_blank">**FVCproductions**</a> |
| :---: |:---:| :---:|
| [![FVCproductions](https://avatars1.githubusercontent.com/u/4284691?v=3&s=200)](http://fvcproductions.com)    | [![FVCproductions](https://avatars1.githubusercontent.com/u/4284691?v=3&s=200)](http://fvcproductions.com) | [![FVCproductions](https://avatars1.githubusercontent.com/u/4284691?v=3&s=200)](http://fvcproductions.com)  |
| <a href="http://github.com/fvcproductions" target="_blank">`github.com/fvcproductions`</a> | <a href="http://github.com/fvcproductions" target="_blank">`github.com/fvcproductions`</a> | <a href="http://github.com/fvcproductions" target="_blank">`github.com/fvcproductions`</a> |

- You can just grab their GitHub profile image URL
- You should probably resize their picture using `?s=200` at the end of the image URL.

---

## FAQ

- **How do I do *specifically* so and so?**
    - No problem! Just do this.

---
