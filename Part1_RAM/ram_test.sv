package RAM_test_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import RAM_env::*;
	import RAM_cfgobj_pkg::*;
	import RAM_Sequences_pkg::*;

	class RAM_test extends  uvm_test;
		`uvm_component_utils(RAM_test)

		RAM_env env;
		RAM_cfg_object RAM_cfg_object_test;
		RAM_reset_seq reset_seq_RAM;
		RAM_write_seq write_seq_RAM;
		RAM_read_seq  read_seq_RAM;
		RAM_main_seq  main_seq_RAM;

		function new(string name = "RAM_test", uvm_component parent = null);
			super.new(name, parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			env = RAM_env::type_id::create("env", this);
			RAM_cfg_object_test = RAM_cfg_object::type_id::create("RAM_cfg_object", this);
			main_seq_RAM  = RAM_main_seq::type_id::create("main_seq_RAM", this);
			reset_seq_RAM = RAM_reset_seq::type_id::create("reset_seq_RAM", this);
			write_seq_RAM = RAM_write_seq::type_id::create("write_seq_RAM", this);
			read_seq_RAM  = RAM_read_seq::type_id::create("read_seq_RAM", this);
			RAM_cfg_object_test.active = UVM_ACTIVE;
			if (!uvm_config_db#(virtual RAM_if)::get(this, "", "RAM_if", RAM_cfg_object_test.config_vif)) begin
				`uvm_fatal("build_phase", "Test - Unable to get virtual interface");
			end
			uvm_config_db#(RAM_cfg_object)::set(this, "*", "CFG", RAM_cfg_object_test);
		endfunction : build_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			phase.raise_objection(this);
			`uvm_info("run_phase", "Reset Asserted.", UVM_LOW)
			reset_seq_RAM.start(env.agt.sqr);
			`uvm_info("run_phase", "Reset Deasserted.", UVM_LOW)

			`uvm_info("run_phase", "Write started.", UVM_LOW)
			write_seq_RAM.start(env.agt.sqr);
			`uvm_info("run_phase", "Write ended.", UVM_LOW)

			`uvm_info("run_phase", "Read started.", UVM_LOW)
			read_seq_RAM.start(env.agt.sqr);
			`uvm_info("run_phase", "Read ended.", UVM_LOW)

            `uvm_info("run_phase", "Main started.", UVM_LOW)
			main_seq_RAM.start(env.agt.sqr);
			`uvm_info("run_phase", "Main ended.", UVM_LOW)
			phase.drop_objection(this);
		endtask : run_phase

	endclass : RAM_test
endpackage : RAM_test_pkg