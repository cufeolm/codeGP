#if [file exists "work"] {vdel -all}
#vlib work
transcript file trans/compileTB.txt
onerror {quit}

#vcom -f ../testing_leon/DUT_LEON.f 
vlog +incdir+../testing_leon+../common+../common/inst_h+../common/Tests+../common/sequences ../testing_leon/target_pkg.sv
vlog ../testing_leon/leon_interface.sv
vlog ../testing_leon/top.sv

#+incdir+leon/DUT

#vsim top

#log /* -r
#run -all

quit
