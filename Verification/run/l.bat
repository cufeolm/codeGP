cls
vsim -c -do ../testing_leon/run_leon.do
vsim -c -do "vsim top +UVM_TESTNAME=subcc_test ; log /* -r ; run -all ; quit"
pause