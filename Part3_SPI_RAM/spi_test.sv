package SPI_test_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import SPI_env::*;
	import SPI_cfgobj_pkg::*;
	import SPI_Sequences_pkg::*;
	import RAM_env::*;
	import RAM_cfgobj_pkg::*;

	class SPI_test extends  uvm_test;
		`uvm_component_utils(SPI_test)

		RAM_env ram_env;
		RAM_cfg_object RAM_cfg_object_test;
		SPI_env env;
		SPI_cfg_object SPI_cfg_object_test;
		SPI_reset_seq reset_seq_SPI;
		SPI_write_seq write_seq_SPI;
		SPI_read_seq  read_seq_SPI;
		SPI_main_seq  main_seq_SPI;

		function new(string name = "SPI_test", uvm_component parent = null);
			super.new(name, parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			ram_env = RAM_env::type_id::create("ram_env", this);
			env = SPI_env::type_id::create("env", this);
			RAM_cfg_object_test = RAM_cfg_object::type_id::create("RAM_cfg_object", this);
			SPI_cfg_object_test = SPI_cfg_object::type_id::create("SPI_cfg_object", this);
			main_seq_SPI  = SPI_main_seq::type_id::create("main_seq_SPI", this);
			reset_seq_SPI = SPI_reset_seq::type_id::create("reset_seq_SPI", this);
			write_seq_SPI = SPI_write_seq::type_id::create("write_seq_SPI", this);
			read_seq_SPI  = SPI_read_seq::type_id::create("read_seq_SPI", this);
			RAM_cfg_object_test.active = UVM_PASSIVE;
			SPI_cfg_object_test.active = UVM_ACTIVE;
			if (!uvm_config_db#(virtual SPI_if)::get(this, "", "SPI_if", SPI_cfg_object_test.config_vif)) begin
				`uvm_fatal("build_phase", "Test - Unable to get virtual interface");
			end
			if (!uvm_config_db#(virtual RAM_if)::get(this, "", "RAM_if", RAM_cfg_object_test.config_vif)) begin
				`uvm_fatal("build_phase", "Test - Unable to get virtual interface");
			end
			uvm_config_db#(SPI_cfg_object)::set(this, "*", "CFG", SPI_cfg_object_test);
			uvm_config_db#(RAM_cfg_object)::set(this, "*", "RAM_CFG", RAM_cfg_object_test);
		endfunction : build_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			phase.raise_objection(this);
			`uvm_info("run_phase", "Reset Asserted.", UVM_LOW)
			reset_seq_SPI.start(env.agt.sqr);
			`uvm_info("run_phase", "Reset Deasserted.", UVM_LOW)

			`uvm_info("run_phase", "Write started.", UVM_LOW)
			write_seq_SPI.start(env.agt.sqr);
			`uvm_info("run_phase", "Write ended.", UVM_LOW)

			`uvm_info("run_phase", "Read started.", UVM_LOW)
			read_seq_SPI.start(env.agt.sqr);
			`uvm_info("run_phase", "Read ended.", UVM_LOW)

            `uvm_info("run_phase", "Main started.", UVM_LOW)
			main_seq_SPI.start(env.agt.sqr);
			`uvm_info("run_phase", "Main ended.", UVM_LOW)
			phase.drop_objection(this);
		endtask : run_phase

	endclass : SPI_test
endpackage : SPI_test_pkg