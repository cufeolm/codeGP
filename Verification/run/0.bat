
::vsim -c -do "transcript file trans/run.txt;vsim top +UVM_TESTNAME=arith_flag_test +ARG_INST=ADDXCC; log /* -r ; run -all ; quit"
::vsim -c -do "transcript file trans/run.txt;vsim top +UVM_TESTNAME=add_test +ARG_INST=A ; log /* -r ; run -all ; quit"

::vsim -c -do "transcript file trans/run.txt;vsim top +UVM_TESTNAME=arith_flag_amber_test +ARG_INST=SUBBCC; log /* -r ; run -all ; quit"
::vsim -c -do "transcript file trans/run.txt;vsim top +UVM_TESTNAME=arith_flag_amber_test +ARG_INST=ADDXCC; log /* -r ; run -all ; quit"
vsim -c -do "transcript file trans/run#.txt;vsim top +UVM_TESTNAME=arith_flag_amber_test +ARG_INST=ADD; log /* -r ; run -all ; quit"
vsim -c -do "transcript file trans/run#.txt;vsim top +UVM_TESTNAME=arith_flag_amber_test +ARG_INST=ADDCC; log /* -r ; run -all ; quit"
vsim -c -do "transcript file trans/run#.txt;vsim top +UVM_TESTNAME=arith_flag_amber_test +ARG_INST=ADDX; log /* -r ; run -all ; quit"
vsim -c -do "transcript file trans/run#.txt;vsim top +UVM_TESTNAME=arith_flag_amber_test +ARG_INST=ADDXCC; log /* -r ; run -all ; quit"

vsim -c -do "transcript file trans/run#.txt;vsim top +UVM_TESTNAME=arith_flag_amber_test +ARG_INST=SUB; log /* -r ; run -all ; quit"
vsim -c -do "transcript file trans/run#.txt;vsim top +UVM_TESTNAME=arith_flag_amber_test +ARG_INST=SUBCC; log /* -r ; run -all ; quit"
vsim -c -do "transcript file trans/run#.txt;vsim top +UVM_TESTNAME=arith_flag_amber_test +ARG_INST=SUBX; log /* -r ; run -all ; quit"
vsim -c -do "transcript file trans/run#.txt;vsim top +UVM_TESTNAME=arith_flag_amber_test +ARG_INST=SUBXCC; log /* -r ; run -all ; quit"
