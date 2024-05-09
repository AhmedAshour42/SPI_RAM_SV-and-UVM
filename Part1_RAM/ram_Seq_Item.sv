package RAM_seq_item_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class RAM_Seq_Item extends  uvm_sequence_item;
		`uvm_object_utils(RAM_Seq_Item)

		rand logic rst_n;
        rand logic [9:0] din;
		rand logic rx_valid;
		rand logic [7:0] dout;
		rand logic tx_valid;

		function new(string name = "RAM_Seq_Item");
			super.new(name);
		endfunction : new

		constraint Reset {rst_n      dist {1'b1:/98, 1'b0:/2};}

		constraint Write {din[9:8]   dist {2'b00:/50, 2'b01:/50};
		                  rx_valid   dist {1'b1:/70, 1'b0:/30};}

		constraint Read  {din[9:8]   dist {2'b10:/50, 2'b11:/50};
		                  rx_valid   dist {1'b1:/70, 1'b0:/30};}

		function string convert2string();
			return $sformatf("%s rst_n = %b, din = %b, rx_valid = %b, dout = %b, tx_valid = %b.", super.convert2string(), rst_n, din, rx_valid, dout, tx_valid);
		endfunction : convert2string


		function string convert2string_stimulus();
			return $sformatf("%s rst_n = %b, din = %b, rx_valid = %b.", super.convert2string(), rst_n, din, rx_valid);
		endfunction : convert2string_stimulus
	
	endclass : RAM_Seq_Item
endpackage : RAM_seq_item_pkg