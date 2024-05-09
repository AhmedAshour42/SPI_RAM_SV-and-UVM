package RAM_Sequences_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import RAM_seq_item_pkg::*;

	class RAM_reset_seq extends  uvm_sequence #(RAM_Seq_Item);
		`uvm_object_utils(RAM_reset_seq)
		RAM_Seq_Item seq_item;

		function new(string name = "RAM_reset_seq");
			super.new(name);
		endfunction : new

		task body ();
			seq_item = RAM_Seq_Item::type_id::create("seq_item");
			start_item(seq_item);
			seq_item.rst_n    = 1;
			seq_item.din      = 0;
			seq_item.rx_valid = 0;
			finish_item(seq_item);
		endtask : body 
	
	endclass : RAM_reset_seq



	class RAM_write_seq extends  uvm_sequence #(RAM_Seq_Item);
		`uvm_object_utils(RAM_write_seq)
		RAM_Seq_Item seq_item;

		function new(string name = "RAM_write_seq");
			super.new(name);
		endfunction : new

		task body ();
			repeat (10000) begin
				seq_item = RAM_Seq_Item::type_id::create("seq_item");
				start_item(seq_item);
				seq_item.constraint_mode (0);
				seq_item.Reset.constraint_mode (1);
				seq_item.Write.constraint_mode (1);
				assert(seq_item.randomize());
				finish_item(seq_item);
			end
		endtask : body 
	
	endclass : RAM_write_seq



	class RAM_read_seq extends  uvm_sequence #(RAM_Seq_Item);
		`uvm_object_utils(RAM_read_seq)
		RAM_Seq_Item seq_item;

		function new(string name = "RAM_read_seq");
			super.new(name);
		endfunction : new

		task body ();
			repeat (10000) begin
				seq_item = RAM_Seq_Item::type_id::create("seq_item");
				start_item(seq_item);
				seq_item.constraint_mode (0);
				seq_item.Reset.constraint_mode (1);
				seq_item.Read.constraint_mode (1);
				assert(seq_item.randomize());
				finish_item(seq_item);
			end
		endtask : body 
	
	endclass : RAM_read_seq



	class RAM_main_seq extends  uvm_sequence #(RAM_Seq_Item);
		`uvm_object_utils(RAM_main_seq)
		RAM_Seq_Item seq_item;

		function new(string name = "RAM_main_seq");
			super.new(name);
		endfunction : new

		task body ();
			repeat (5000) begin
				seq_item = RAM_Seq_Item::type_id::create("seq_item");
				start_item(seq_item);
				seq_item.constraint_mode (0);
				seq_item.Reset.constraint_mode (1);
				assert(seq_item.randomize());
				finish_item(seq_item);
			end
		endtask : body 
	
	endclass : RAM_main_seq
	
endpackage : RAM_Sequences_pkg