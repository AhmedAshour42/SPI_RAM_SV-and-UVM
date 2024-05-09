package RAM_cfgobj_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class RAM_cfg_object extends  uvm_object;
	
		`uvm_object_utils(RAM_cfg_object)

		virtual RAM_if config_vif;
		uvm_active_passive_enum active;

		function new(string name = "RAM_cfg_object");
			super.new(name);
		endfunction : new
	
	endclass : RAM_cfg_object

endpackage : RAM_cfgobj_pkg