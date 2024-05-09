import uvm_pkg::*;
`include "uvm_macros.svh"
import SPI_test_pkg::*;


module top ();

bit clk;

initial begin
	clk = 0;
	forever begin
		#1;
		clk = ~clk;
	end
end

RAM_if RAM_if (clk);
SPI_if My_if (clk);
SPI_Wrapper DUT (My_if.MOSI, My_if.MISO, My_if.SS_n, clk, My_if.rst_n);
bind SPI_Wrapper SPI_Asrts check_asserts (clk, My_if.MOSI, My_if.SS_n, My_if.rst_n, DUT.s1.cs);
assign My_if.slave_state = DUT.s1.cs;
assign RAM_if.rst_n = DUT.r1.rst_n;;
assign RAM_if.rx_valid = DUT.r1.rx_valid;
assign RAM_if.tx_valid = DUT.r1.tx_valid;
assign RAM_if.din = DUT.r1.din;
assign RAM_if.dout = DUT.r1.dout;

initial begin
	uvm_config_db#(virtual SPI_if)::set(null, "uvm_test_top", "SPI_if", My_if);
	uvm_config_db#(virtual RAM_if)::set(null, "uvm_test_top", "RAM_if", RAM_if);
	run_test("SPI_test");
end

endmodule : top
