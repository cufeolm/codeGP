if [file exists "work"] {vdel -all}
vlib work
vcom -f DUT.f
#vcom [glob *.vhd ]
quit
