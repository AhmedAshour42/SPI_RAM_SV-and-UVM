vlib work
vlog -f src_files.txt
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all
add wave /top/My_if/*
add wave /top/RAM_if/*
add wave /top/DUT/check_asserts/toCHK_CMD_cp /top/DUT/check_asserts/toWRITE_cp /top/DUT/check_asserts/toREAD_cp /top/DUT/check_asserts/toIDLE_cp /top/DUT/check_asserts/Reset_cp
add wave /top/DUT/r1/Assrt1 /top/DUT/r1/Assrt2
coverage save SPI.ucdb -onexit
run -all