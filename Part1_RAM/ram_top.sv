import uvm_pkg::*;
`include "uvm_macros.svh"
import RAM_test_pkg::*;


module top ();

bit clk;

initial begin
	clk = 0;
	forever begin
		#1;
		clk = ~clk;
	end
end

RAM_if My_if (clk);
ram DUT (My_if.din, clk, My_if.rst_n, My_if.rx_valid, My_if.dout, My_if.tx_valid);

initial begin
	uvm_config_db#(virtual RAM_if)::set(null, "uvm_test_top", "RAM_if", My_if);
	run_test("RAM_test");
end

endmodule : top
