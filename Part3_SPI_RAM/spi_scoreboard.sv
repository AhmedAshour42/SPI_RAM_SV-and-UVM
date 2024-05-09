package SPI_scoreboard_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import SPI_seq_item_pkg::*;
	import SPI_cfgobj_pkg::*;
	
	
	
	class SPI_scoreboard extends  uvm_scoreboard;
		`uvm_component_utils(SPI_scoreboard)
		uvm_analysis_export #(SPI_Seq_Item) sb_export;
		uvm_tlm_analysis_fifo #(SPI_Seq_Item) sb_fifo;
		SPI_Seq_Item seq_item_sb;
		logic [10:0] MOSI_sequence;
		int MOSI_seq_count = 0;
		logic [7:0] Reference_memory [255:0];
		logic [7:0] dataout_ref;
		logic [7:0] dataout_check;
		logic tx_valid_ref;		logic [7:0] add_write_ref, add_read_ref;
		bit MISO_out_check;
		int MISO_Check_counter = 0;
		logic MISO_ref;
		SPI_cfg_object my_cfg;

		int error_count = 0;
		int correct_count = 0;
	
		function new(string name = "SPI_scoreboard", uvm_component parent=null);
			super.new(name, parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			uvm_config_db#(SPI_cfg_object)::get(this, "", "CFG", my_cfg);
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
				MISO_Check_Task ();
				my_cfg.config_vif.miso_ref = MISO_ref;
				SPI_ref (seq_item_sb);
			end
		endtask : run_phase 

		task MISO_Check_Task ();
			if (!seq_item_sb.rst_n) begin
				MISO_out_check = 0;
				MISO_ref = 0;
				MISO_Check_counter = 0;
				if (seq_item_sb.MISO != MISO_ref) begin
					`uvm_error("run_phase", $sformatf("Comparison failed transaction received : %s , while the reference MISO : %b", seq_item_sb.convert2string(), MISO_ref));
					error_count++;
				end
				else begin
					`uvm_info("run_phase", $sformatf("correct out : %s",seq_item_sb.convert2string()), UVM_HIGH);
					correct_count++;
				end
			end
			else if (MISO_out_check) begin
				MISO_ref = dataout_check[7-MISO_Check_counter];
				if (seq_item_sb.MISO != MISO_ref) begin
					`uvm_error("run_phase", $sformatf("Comparison failed transaction received : %s , while the reference MISO : %b", seq_item_sb.convert2string(), MISO_ref));
					error_count++;
				end
				else begin
					`uvm_info("run_phase", $sformatf("correct out : %s",seq_item_sb.convert2string()), UVM_HIGH);
					correct_count++;
				end

				if (MISO_Check_counter == 7) begin
					MISO_out_check = 0;
				end

				MISO_Check_counter = MISO_Check_counter + 1;
			end
			else begin
				MISO_Check_counter = 0;
				MISO_ref = 0;
			end
		endtask : MISO_Check_Task 

		task SPI_ref (SPI_Seq_Item seq_item_check);
			if ( ((!seq_item_check.SS_n) && (seq_item_check.rst_n == 1)) || ((seq_item_check.rst_n == 1)&&(MOSI_seq_count == 12)) ) begin
				if (MOSI_seq_count<12) begin
					MOSI_sequence ={MOSI_sequence[9:0], seq_item_check.MOSI};
				end

				MOSI_seq_count = MOSI_seq_count + 1;

				if (MOSI_seq_count == 13) begin
					if (MOSI_sequence[10:8] == 3'b111) begin
						ref_model_mem(1'b1, MOSI_sequence[9:0], 1'b1);
						dataout_check = dataout_ref;
						MISO_out_check = 1;
					end
					else if (MOSI_sequence[10:8] == 3'b110) begin
						ref_model_mem(1'b1, MOSI_sequence[9:0], 1'b1);
						MISO_out_check = 0;
					end
					else if (MOSI_sequence[10:9] == 2'b00) begin
						ref_model_mem(1'b1, MOSI_sequence[9:0], 1'b1);
					end

					if (seq_item_check.SS_n) begin
						MOSI_seq_count = 0;
						MOSI_sequence = 0;
					end
				end
			end
			else begin
				MOSI_seq_count = 0;
				MOSI_sequence = 0;
			end
		endtask : SPI_ref 

		task ref_model_mem(logic rst_n_mem, logic [9:0] din_mem, logic rx_valid);
			if(~rst_n_mem) begin
				dataout_ref = 0;
				tx_valid_ref = 0;
			end 
			else begin
				case (din_mem[9:8])
	    		2'b00: begin
	    			if (rx_valid) begin
	    				add_write_ref=din_mem[7:0];
	    				tx_valid_ref=0;
	    			end
	    			else begin
	    				tx_valid_ref=1'b0;
	    			end
	    		end
	    		2'b01: begin
	    			if (rx_valid) begin
	    				Reference_memory[add_write_ref] = din_mem[7:0];;
	    				tx_valid_ref=0;
	    			end
	    			else begin
	    				tx_valid_ref=1'b0;
	    			end
	    		end
	    		2'b10: begin
	    			if (rx_valid) begin
	    				add_read_ref=din_mem[7:0];
			    		tx_valid_ref=0;
			    	end
			    	else begin
			    		tx_valid_ref=1'b0;
			    	end
			    end
	  		    2'b11: begin
	  		  	    if (rx_valid) begin
			    		dataout_ref=Reference_memory[add_read_ref];
	    				tx_valid_ref=1'b1;
	  		  	    end
			    	else begin
	    				tx_valid_ref=1'b0;
	  		  	    end
			    end
	  		    endcase
			end
		endtask : ref_model_mem

		function void report_phase(uvm_phase phase);
			super.report_phase(phase);
			`uvm_info("report_phase", $sformatf("Total successful trx : %0d",correct_count), UVM_MEDIUM);
			`uvm_info("report_phase", $sformatf("Total failed     trx : %0d",error_count), UVM_MEDIUM);
		endfunction : report_phase
	endclass : SPI_scoreboard
endpackage : SPI_scoreboard_pkg