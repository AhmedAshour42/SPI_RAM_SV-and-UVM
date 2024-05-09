package SPI_Sequences_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import SPI_seq_item_pkg::*;

	class SPI_reset_seq extends  uvm_sequence #(SPI_Seq_Item);
		`uvm_object_utils(SPI_reset_seq)
		SPI_Seq_Item seq_item;

		function new(string name = "SPI_reset_seq");
			super.new(name);
		endfunction : new

		task body ();
			seq_item = SPI_Seq_Item::type_id::create("seq_item");
			start_item(seq_item);
			seq_item.rst_n = 0;
			seq_item.MOSI  = 0;
			seq_item.SS_n  = 1;
			finish_item(seq_item);
		endtask : body 
	
	endclass : SPI_reset_seq



	class SPI_write_seq extends  uvm_sequence #(SPI_Seq_Item);
		`uvm_object_utils(SPI_write_seq)
		SPI_Seq_Item seq_item;

		function new(string name = "SPI_write_seq");
			super.new(name);
		endfunction : new

		task body ();
			seq_item = SPI_Seq_Item::type_id::create("seq_item");
			repeat (150000) begin
				start_item(seq_item);
				seq_item.constraint_mode (0);
				seq_item.rst_SS_n.constraint_mode (1);
				seq_item.Write.constraint_mode (1);
				assert(seq_item.randomize());
				finish_item(seq_item);
			end
		endtask : body 
	
	endclass : SPI_write_seq



	class SPI_read_seq extends  uvm_sequence #(SPI_Seq_Item);
		`uvm_object_utils(SPI_read_seq)
		SPI_Seq_Item seq_item;

		function new(string name = "SPI_read_seq");
			super.new(name);
		endfunction : new

		task body ();
			seq_item = SPI_Seq_Item::type_id::create("seq_item");
			repeat (150000) begin
				start_item(seq_item);
				seq_item.constraint_mode (0);
				seq_item.rst_SS_n.constraint_mode (1);
				seq_item.Read.constraint_mode (1);
				assert(seq_item.randomize());
				finish_item(seq_item);
			end
		endtask : body 
	
	endclass : SPI_read_seq



	class SPI_main_seq extends  uvm_sequence #(SPI_Seq_Item);
		`uvm_object_utils(SPI_main_seq)
		SPI_Seq_Item seq_item;

		function new(string name = "SPI_main_seq");
			super.new(name);
		endfunction : new

		task body ();
			seq_item = SPI_Seq_Item::type_id::create("seq_item");
			repeat (100000) begin
				start_item(seq_item);
				seq_item.constraint_mode (0);
				seq_item.rst_SS_n.constraint_mode (1);
				seq_item.Main.constraint_mode (1);
				assert(seq_item.randomize());
				finish_item(seq_item);
			end
		endtask : body 
	
	endclass : SPI_main_seq
	
endpackage : SPI_Sequences_pkg