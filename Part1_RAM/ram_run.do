vlib work
vlog -f src_files.txt
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all
add wave /top/My_if/*
add wave /top/DUT/Assrt1 /top/DUT/Assrt2
coverage save RAM.ucdb -onexit
run -all