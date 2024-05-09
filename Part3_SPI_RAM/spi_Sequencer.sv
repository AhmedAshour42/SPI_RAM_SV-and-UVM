package SPI_Sequencer_pkg ;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import SPI_seq_item_pkg::*;
	

	class SPI_sequencer extends  uvm_sequencer #(SPI_Seq_Item);
		`uvm_component_utils(SPI_sequencer)
	
		function new(string name = "SPI_sequencer", uvm_component parent=null);
			super.new(name, parent);
		endfunction : new
	
	endclass : SPI_sequencer
endpackage : SPI_Sequencer_pkg 