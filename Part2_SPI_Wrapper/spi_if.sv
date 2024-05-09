interface SPI_if (clk);
  input clk;
  logic rst_n ;
  logic SS_n;
  logic MOSI;
  
  logic MISO;

  logic [2:0] slave_state;
  logic miso_ref;

endinterface : SPI_if