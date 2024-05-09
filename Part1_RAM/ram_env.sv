package RAM_env;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import RAM_cv_collector_pkg::*;
	import RAM_scoreboard_pkg::*;
	import RAM_agent_pkg::*;
	
	

	class RAM_env extends  uvm_env;
		`uvm_component_utils(RAM_env)

		RAM_scoreboard sb;
		RAM_coverage cov;
		RAM_agent agt;

		function new(string name = "RAM_env", uvm_component parent = null);
			super.new(name, parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			agt = RAM_agent::type_id::create("agt", this);
			sb = RAM_scoreboard::type_id::create("sb", this);
			cov = RAM_coverage::type_id::create("cov", this);
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			agt.agent_ap.connect(sb.sb_export);
			agt.agent_ap.connect(cov.cov_export);
		endfunction : connect_phase
		
	endclass : RAM_env
endpackage : RAM_env