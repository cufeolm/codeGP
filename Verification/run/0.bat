
vsim -c -do "transcript file trans/run.txt;vsim top +UVM_TESTNAME=arith_flag_test +ARG_INST=A ; log /* -r ; run -all ; quit"
