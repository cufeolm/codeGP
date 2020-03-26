if [file exists "work"] {vdel -all}
vlib work
#vcom -mixedsvvh leon/iface.vhd 
vcom -f DUT_LEON.f 



quit
