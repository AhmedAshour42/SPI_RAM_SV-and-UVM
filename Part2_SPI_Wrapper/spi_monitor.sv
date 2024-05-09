package SPI_monitor_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import SPI_seq_item_pkg::*;
	

	class SPI_monitor extends  uvm_monitor;
		`uvm_component_utils(SPI_monitor)
		virtual SPI_if SPI_vif;
		SPI_Seq_Item rsp_seq_item;
		uvm_analysis_port #(SPI_Seq_Item) mon_ap;

		function new(string name = "SPI_monitor", uvm_component parent=null);
			super.new(name, parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			mon_ap = new("mon_ap", this);
		endfunction : build_phase

		task run_phase (uvm_phase phase);
			super.run_phase(phase);
			forever begin
				rsp_seq_item = SPI_Seq_Item::type_id::create("rsp_seq_item");
				@(negedge SPI_vif.clk);
				rsp_seq_item.rst_n  = SPI_vif.rst_n;
				rsp_seq_item.MOSI   = SPI_vif.MOSI;
				rsp_seq_item.SS_n   = SPI_vif.SS_n;
				rsp_seq_item.MISO   = SPI_vif.MISO;
				mon_ap.write(rsp_seq_item);
				`uvm_info("run_phase", rsp_seq_item.convert2string(), UVM_HIGH)
			end
		endtask : run_phase 
	
	endclass : SPI_monitor
endpackage : SPI_monitor_pkg