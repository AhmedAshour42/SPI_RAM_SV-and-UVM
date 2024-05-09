package RAM_agent_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import RAM_cfgobj_pkg::*;
	import RAM_driver_pkg::*;
	import RAM_Sequencer_pkg::*;
	import RAM_monitor_pkg::*;
	import RAM_seq_item_pkg::*;
	
	

	class RAM_agent extends  uvm_agent;
		`uvm_component_utils(RAM_agent)
		RAM_sequencer sqr;
		RAM_driver drv;
		RAM_monitor mon;
		RAM_cfg_object RAM_cfg;
		uvm_analysis_port #(RAM_Seq_Item) agent_ap;
	
		function new(string name = "RAM_agent", uvm_component parent=null);
			super.new(name, parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			RAM_cfg = RAM_cfg_object::type_id::create("RAM_cfg_object", this);
			if(!uvm_config_db#(RAM_cfg_object)::get(this, "", "RAM_CFG", RAM_cfg)) begin
				`uvm_fatal("build_phase", "Driver - Unable to get configuration object")
			end
			if (RAM_cfg.active == UVM_ACTIVE) begin
				sqr = RAM_sequencer::type_id::create("sqr", this);
				drv = RAM_driver::type_id::create("drv", this);
			end
			mon = RAM_monitor::type_id::create("mon", this);
			agent_ap = new("agent_ap", this);
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			if (RAM_cfg.active == UVM_ACTIVE) begin
				drv.seq_item_port.connect(sqr.seq_item_export);
				drv.RAM_driver_vif  = RAM_cfg.config_vif;
			end
			mon.RAM_vif         = RAM_cfg.config_vif;
			mon.mon_ap.connect(agent_ap);
		endfunction : connect_phase
	
	endclass : RAM_agent

endpackage : RAM_agent_pkg