package SPI_env;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import SPI_cv_collector_pkg::*;
	import SPI_scoreboard_pkg::*;
	import SPI_agent_pkg::*;
	
	

	class SPI_env extends  uvm_env;
		`uvm_component_utils(SPI_env)

		SPI_scoreboard sb;
		SPI_coverage cov;
		SPI_agent agt;

		function new(string name = "SPI_env", uvm_component parent = null);
			super.new(name, parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			agt = SPI_agent::type_id::create("agt", this);
			sb = SPI_scoreboard::type_id::create("sb", this);
			cov = SPI_coverage::type_id::create("cov", this);
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			agt.agent_ap.connect(sb.sb_export);
			agt.agent_ap.connect(cov.cov_export);
		endfunction : connect_phase
		
	endclass : SPI_env
endpackage : SPI_env