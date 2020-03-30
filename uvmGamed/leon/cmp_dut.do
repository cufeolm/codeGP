if [file exists "work"] {vdel -all}
vlib work
onerror {quit}
#vcom -mixedsvvh leon/iface.vhd 

vcom -f leon/DUT_LEON.f 