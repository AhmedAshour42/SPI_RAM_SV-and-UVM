vlib work
vlog -f src_files.txt
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all
add wave /top/My_if/*
add wave /top/DUT/check_asserts/toCHK_CMD_cp /top/DUT/check_asserts/toWRITE_cp /top/DUT/check_asserts/toREAD_cp /top/DUT/check_asserts/toIDLE_cp /top/DUT/check_asserts/Reset_cp
coverage save SPI.ucdb -onexit
run -all