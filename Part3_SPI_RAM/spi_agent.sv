package SPI_agent_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import SPI_cfgobj_pkg::*;
	import SPI_driver_pkg::*;
	import SPI_Sequencer_pkg::*;
	import SPI_monitor_pkg::*;
	import SPI_seq_item_pkg::*;
	
	

	class SPI_agent extends  uvm_agent;
		`uvm_component_utils(SPI_agent)
		SPI_sequencer sqr;
		SPI_driver drv;
		SPI_monitor mon;
		SPI_cfg_object SPI_cfg;
		uvm_analysis_port #(SPI_Seq_Item) agent_ap;
	
		function new(string name = "SPI_agent", uvm_component parent=null);
			super.new(name, parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			SPI_cfg = SPI_cfg_object::type_id::create("SPI_cfg_object", this);
			if(!uvm_config_db#(SPI_cfg_object)::get(this, "", "CFG", SPI_cfg)) begin
				`uvm_fatal("build_phase", "Driver - Unable to get configuration object")
			end
			if (SPI_cfg.active == UVM_ACTIVE) begin
				sqr = SPI_sequencer::type_id::create("sqr", this);
				drv = SPI_driver::type_id::create("drv", this);
			end
			mon = SPI_monitor::type_id::create("mon", this);
			agent_ap = new("agent_ap", this);
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			if (SPI_cfg.active == UVM_ACTIVE) begin
				drv.seq_item_port.connect(sqr.seq_item_export);
				drv.SPI_driver_vif  = SPI_cfg.config_vif;
			end
			mon.SPI_vif         = SPI_cfg.config_vif;
			mon.mon_ap.connect(agent_ap);
		endfunction : connect_phase
	
	endclass : SPI_agent

endpackage : SPI_agent_pkg