package SPI_cv_collector_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import SPI_seq_item_pkg::*;
	import SPI_cfgobj_pkg::*;
	
	
	parameter IDLE      = 3'b000;
   parameter READ_DATA = 3'b001;
   parameter READ_ADD  = 3'b010;
   parameter CHK_CMD   = 3'b011;
   parameter WRITE     = 3'b100;

	class SPI_coverage extends  uvm_component;
		`uvm_component_utils(SPI_coverage)
		uvm_analysis_export #(SPI_Seq_Item) cov_export;
		uvm_tlm_analysis_fifo #(SPI_Seq_Item) cov_fifo;
		SPI_Seq_Item Seq_Item_cov;
		SPI_cfg_object SPI_cfg_object_cv;

		covergroup SPI_cvr_gp();
			cs_cp  : coverpoint SPI_cfg_object_cv.config_vif.slave_state      {
                    bins IDLE_to_CHK_CMD       = (IDLE=>CHK_CMD);
                    bins CHK_CMD_to_WRITE      = (CHK_CMD=>WRITE);
                    bins CHK_CMD_to_READ_DATA  = (CHK_CMD=>READ_DATA);
                    bins CHK_CMD_to_READ_ADD   = (CHK_CMD=>READ_ADD);
                    bins CHK_CMD_to_IDLE   = (CHK_CMD=>IDLE);
                    bins WRITE_to_IDLE         = (WRITE=>IDLE);
                    bins READ_DATA_to_IDLE     = (READ_DATA=>IDLE);
                    bins READ_ADD_to_IDLE      = (READ_ADD=>IDLE);
                    bins IDLE_state      = {IDLE};
                    bins CHK_CMD_state   = {CHK_CMD};
                    bins WRITE_state     = {WRITE};
                    bins READ_ADD_state  = {READ_ADD};
                    bins READ_DATA_state = {READ_DATA};
                    }
			MOSI_cp   : coverpoint Seq_Item_cov.MOSI;
			SS_n_cp   : coverpoint Seq_Item_cov.SS_n; 

            MOSI_cross_cs : cross MOSI_cp, cs_cp {
                    ignore_bins cs_transition1 = binsof(cs_cp.IDLE_to_CHK_CMD);
                    ignore_bins cs_transition2 = binsof(cs_cp.CHK_CMD_to_WRITE);
                    ignore_bins cs_transition3 = binsof(cs_cp.CHK_CMD_to_READ_DATA);
                    ignore_bins cs_transition4 = binsof(cs_cp.CHK_CMD_to_READ_ADD);
                    ignore_bins cs_transition5 = binsof(cs_cp.WRITE_to_IDLE);
                    ignore_bins cs_transition6 = binsof(cs_cp.READ_DATA_to_IDLE);
                    ignore_bins cs_transition7 = binsof(cs_cp.READ_ADD_to_IDLE);
                    ignore_bins cs_transition8 = binsof(cs_cp.CHK_CMD_to_IDLE);
                    } 
            SS_n_cross_cs : cross SS_n_cp, cs_cp {
                    ignore_bins cs_transition11 = binsof(cs_cp.IDLE_to_CHK_CMD);
                    ignore_bins cs_transition22 = binsof(cs_cp.CHK_CMD_to_WRITE);
                    ignore_bins cs_transition33 = binsof(cs_cp.CHK_CMD_to_READ_DATA);
                    ignore_bins cs_transition44 = binsof(cs_cp.CHK_CMD_to_READ_ADD);
                    ignore_bins cs_transition55 = binsof(cs_cp.WRITE_to_IDLE);
                    ignore_bins cs_transition66 = binsof(cs_cp.READ_DATA_to_IDLE);
                    ignore_bins cs_transition77 = binsof(cs_cp.READ_ADD_to_IDLE);
                    ignore_bins cs_transition88 = binsof(cs_cp.CHK_CMD_to_IDLE);
                    }
            MOSI_cross_SS_n     : cross MOSI_cp, SS_n_cp;
		endgroup : SPI_cvr_gp
	
		function new(string name = "SPI_coverage", uvm_component parent=null);
			super.new(name, parent);
			SPI_cvr_gp = new();
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			uvm_config_db#(SPI_cfg_object)::get(this, "", "CFG", SPI_cfg_object_cv);
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
				SPI_cvr_gp.sample();
			end

		endtask : run_phase 
	
	endclass : SPI_coverage
endpackage : SPI_cv_collector_pkg