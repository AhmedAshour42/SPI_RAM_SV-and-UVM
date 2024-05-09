package SPI_seq_item_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class SPI_Seq_Item extends  uvm_sequence_item;
		`uvm_object_utils(SPI_Seq_Item)

		bit read_address_occ;
		bit first_wr_add_occ;
        logic [3:0] MOSI_count;
        bit Cmd_MOSI;
        bit first_MOSI_data;
        bit second_MOSI_data;
        logic MISO;
        rand logic MOSI;
        rand logic rst_n;
		rand logic SS_n;
        
        function void post_randomize();
            if (MOSI_count==1 && !SS_n) begin
                Cmd_MOSI = MOSI;
            end
            else if (MOSI_count==2 && !SS_n) begin
               first_MOSI_data  = MOSI;
            end
            else if (MOSI_count==3 && !SS_n) begin
               second_MOSI_data = MOSI;
            end

            if (SS_n || !rst_n) begin
            	MOSI_count = 0;
            end
            else begin
            	MOSI_count = MOSI_count + 1;
            end

            if (MOSI_count == 12) begin
            	if ({first_MOSI_data, second_MOSI_data} == 2'b10) begin
            		read_address_occ = 1;
            	end
            	else if ({first_MOSI_data, second_MOSI_data} == 2'b11) begin
            		read_address_occ = 0;
            	end
            	else if ({first_MOSI_data, second_MOSI_data} == 2'b00) begin
            		first_wr_add_occ = 1;
            	end
            end
        endfunction

		function new(string name = "SPI_Seq_Item");
			super.new(name);
			MOSI_count = 0;
            read_address_occ = 0;
            first_wr_add_occ = 0;
		endfunction : new

		constraint rst_SS_n {    rst_n  dist {1'b1:=99, 1'b0:=1};
		                     
		                     if (MOSI_count>=12) 
                                {SS_n   dist {1'b0:/5, 1'b1:/95};}
                             
		                     else 
                                {SS_n   dist {1'b0:/95, 1'b1:/5};}
                            } 

		constraint Write {  if (MOSI_count==1 && !SS_n) {
                                MOSI dist {1'b0:=100};
                            }
		                    else if (MOSI_count==2 && !SS_n) {
                                MOSI dist {Cmd_MOSI:=100};
                            }
                            else if (MOSI_count==3 && !SS_n) {
                                if  (!first_wr_add_occ) 
                                	{MOSI dist {1'b0:=100};}
                                else 
                                	{MOSI dist {1'b1:=50, 1'b0:=50};}
                            }
                        }

		constraint Read {  if (MOSI_count==1 && !SS_n) {
                                MOSI dist {1'b1:=100};
                            }
		                    else if (MOSI_count==2 && !SS_n) {
                                MOSI dist {Cmd_MOSI:=100};
                            }
                            else if (MOSI_count==3 && !SS_n) {
                                if (read_address_occ) {
                                    MOSI dist {1'b1:=100};
                                }
                                else if (!read_address_occ) {
                                    MOSI dist {1'b0:=100};  
                                }   
                            }
                        }

        constraint Main  {  if (MOSI_count==2 && !SS_n) {
                                MOSI dist {Cmd_MOSI:=100};
                            }
                            else if (MOSI_count==3 && !SS_n) {
                                if  (first_MOSI_data==1'b1) {
                                    if (read_address_occ) {
                                        MOSI dist {1'b1:=100};
                                    }
                                    else if (!read_address_occ) {
                                        MOSI dist {1'b0:=100};  
                                    }
                                }
                                else {MOSI dist {1'b1:=50, 1'b0:=50};}
                            }
                        }

		function string convert2string();
			return $sformatf("%s rst_n = %b, MOSI = %b, SS_n = %b, MISO = %b.", super.convert2string(), rst_n, MOSI, SS_n, MISO);
		endfunction : convert2string


		function string convert2string_stimulus();
			return $sformatf("%s rst_n = %b, MOSI = %b, SS_n = %b.", super.convert2string(), rst_n, MOSI, SS_n);
		endfunction : convert2string_stimulus
	
	endclass : SPI_Seq_Item
endpackage : SPI_seq_item_pkg