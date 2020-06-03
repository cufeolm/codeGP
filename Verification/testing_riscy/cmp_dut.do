if [file exists "work"] {vdel -all}
vlib work
onerror {quit}


vlog -f ../testing_riscy/DUT_riscy.f 