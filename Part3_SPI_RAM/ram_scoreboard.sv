package RAM_scoreboard_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import RAM_seq_item_pkg::*;
	
	
	
	class RAM_scoreboard extends  uvm_scoreboard;
		`uvm_component_utils(RAM_scoreboard)
		uvm_analysis_export #(RAM_Seq_Item) sb_export;
		uvm_tlm_analysis_fifo #(RAM_Seq_Item) sb_fifo;
		RAM_Seq_Item seq_item_sb;
		logic [7:0] dataout_ref;
		logic tx_valid_ref;
		logic [7:0] add_write_ref, add_read_ref;
		logic [7:0] RAM_GoldenModel [255:0];
		logic rst_n_ref;
		logic rx_valid_ref;
		logic [9:0] din_ref;

		int error_count = 0;
		int correct_count = 0;
	
		function new(string name = "RAM_scoreboard", uvm_component parent=null);
			super.new(name, parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			sb_export = new("sb_export", this);
			sb_fifo   = new("sb_fifo",   this);
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			sb_export.connect(sb_fifo.analysis_export);
		endfunction : connect_phase

		task run_phase (uvm_phase phase);
			super.run_phase(phase);
			forever begin
				sb_fifo.get(seq_item_sb);
				rst_n_ref    = seq_item_sb.rst_n;
				ref_model(seq_item_sb);
				rx_valid_ref = seq_item_sb.rx_valid;
				din_ref      = seq_item_sb.din;
				if ( (seq_item_sb.dout != dataout_ref) || (seq_item_sb.tx_valid != tx_valid_ref)) begin
					`uvm_error("run_phase", $sformatf("Comparison failed transaction received : %s , while the reference out : %b and ref_tx_valid : %b", seq_item_sb.convert2string(), dataout_ref, tx_valid_ref));
					error_count++;
				end
				else begin
					`uvm_info("run_phase", $sformatf("correct out : %s",seq_item_sb.convert2string()), UVM_HIGH);
					correct_count++;
				end
			end
		endtask : run_phase 

		task ref_model(RAM_Seq_Item seq_item_check);
			if(~rst_n_ref) begin
				dataout_ref = 0;
				tx_valid_ref = 0;
			end 
			else begin
				case (din_ref[9:8])
	    		2'b00: begin
	    			if (rx_valid_ref) begin
	    				add_write_ref=din_ref[7:0];
	    				tx_valid_ref=0;
	    			end
	    			else begin
	    				tx_valid_ref=1'b0;
	    			end
	    		end
	    		2'b01: begin
	    			if (rx_valid_ref) begin
	    				RAM_GoldenModel[add_write_ref] = din_ref[7:0];;
	    				tx_valid_ref=0;
	    			end
	    			else begin
	    				tx_valid_ref=1'b0;
	    			end
	    		end
	    		2'b10: begin
	    			if (rx_valid_ref) begin
	    				add_read_ref=din_ref[7:0];
			    		tx_valid_ref=0;
			    	end
			    	else begin
			    		tx_valid_ref=1'b0;
			    	end
			    end
	  		  2'b11: begin
	  		  	if (rx_valid_ref) begin
			    		dataout_ref=RAM_GoldenModel[add_read_ref];
	    				tx_valid_ref=1'b1;
	  		  	end
			    	else begin
	    				tx_valid_ref=1'b0;
	  		  	end
			    end
	  		endcase
			end
		endtask : ref_model

		function void report_phase(uvm_phase phase);
			super.report_phase(phase);
			`uvm_info("report_phase", $sformatf("Total successful trx : %0d",correct_count), UVM_MEDIUM);
			`uvm_info("report_phase", $sformatf("Total failed     trx : %0d",error_count), UVM_MEDIUM);
		endfunction : report_phase
	endclass : RAM_scoreboard
endpackage : RAM_scoreboard_pkg