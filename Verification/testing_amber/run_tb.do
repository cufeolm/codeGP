onerror {quit}
transcript file trans/compileTB.txt
vlog +incdir+../testing_amber+../common+../common/inst_h+../common/Tests+../common/sequences ../testing_amber/target_pkg.sv

vlog ../testing_amber/amber_interface.sv
vlog ../testing_amber/top.sv

#vsim -novopt top

#log /* -r

#run -all
quit