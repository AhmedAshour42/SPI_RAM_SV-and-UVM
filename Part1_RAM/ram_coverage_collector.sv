package RAM_cv_collector_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import RAM_seq_item_pkg::*;
	

	class RAM_coverage extends  uvm_component;
		`uvm_component_utils(RAM_coverage)
		uvm_analysis_export #(RAM_Seq_Item) cov_export;
		uvm_tlm_analysis_fifo #(RAM_Seq_Item) cov_fifo;
		RAM_Seq_Item Seq_Item_cov;

		covergroup RAM_cvr_gp();
			RAM_command_cp       : coverpoint Seq_Item_cov.din[9:8] iff(Seq_Item_cov.rst_n && Seq_Item_cov.rx_valid) {
                                       bins write_address = {2'b00};
                                       bins write_data    = {2'b01};
                                       bins read_address  = {2'b10};
                                       bins read_data     = {2'b11};
			                        }
			RAM_din7to0_cp       : coverpoint Seq_Item_cov.din[7:0] ;
			rx_valid_cp          : coverpoint Seq_Item_cov.rx_valid;
			tx_valid_cp          : coverpoint Seq_Item_cov.tx_valid;
            rx_tx_cross          : cross rx_valid_cp, tx_valid_cp ;
            write_address_cp     : cross RAM_command_cp, RAM_din7to0_cp {
                                       ignore_bins data_w = binsof(RAM_command_cp.write_data);
                                       ignore_bins data_r = binsof(RAM_command_cp.read_data);
                                       ignore_bins addr_r = binsof(RAM_command_cp.read_address);
                                    }
            read_address_cp      : cross RAM_command_cp, RAM_din7to0_cp {
                                       ignore_bins data_w1 = binsof(RAM_command_cp.write_data);
                                       ignore_bins data_r1 = binsof(RAM_command_cp.read_data);
                                       ignore_bins addr_w = binsof(RAM_command_cp.write_address);
                                    }
		endgroup : RAM_cvr_gp
	
		function new(string name = "RAM_coverage", uvm_component parent=null);
			super.new(name, parent);
			RAM_cvr_gp = new();
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			cov_export = new("cov_export", this);
			cov_fifo   = new("cov_fifo"  , this);
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			cov_export.connect(cov_fifo.analysis_export);
		endfunction : connect_phase

		task run_phase (uvm_phase phase);
			super.run_phase(phase);
			forever begin
				cov_fifo.get(Seq_Item_cov);
				RAM_cvr_gp.sample();
			end

		endtask : run_phase 
	
	endclass : RAM_coverage
endpackage : RAM_cv_collector_pkg