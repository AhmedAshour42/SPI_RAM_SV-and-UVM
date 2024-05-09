package RAM_Sequencer_pkg ;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import RAM_seq_item_pkg::*;
	

	class RAM_sequencer extends  uvm_sequencer #(RAM_Seq_Item);
		`uvm_component_utils(RAM_sequencer)
	
		function new(string name = "RAM_sequencer", uvm_component parent=null);
			super.new(name, parent);
		endfunction : new
	
	endclass : RAM_sequencer
endpackage : RAM_Sequencer_pkg 