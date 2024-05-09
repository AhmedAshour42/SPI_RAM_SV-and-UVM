package SPI_cfgobj_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class SPI_cfg_object extends  uvm_object;
	
		`uvm_object_utils(SPI_cfg_object)

		virtual SPI_if config_vif;
		uvm_active_passive_enum active;

		function new(string name = "SPI_cfg_object");
			super.new(name);
		endfunction : new
	
	endclass : SPI_cfg_object

endpackage : SPI_cfgobj_pkg