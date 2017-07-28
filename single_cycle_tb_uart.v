
`timescale 1ns/1ps
module single_cycle_tb_with_uart  ; 


  reg    uart_rx   ; 
  wire  [7:0]  led   ;
  wire  [11:0]  digi   ; 
  reg    sysclk   ; 
  reg  [7:0]  switch   ; 
  wire    uart_tx   ; 
  reg    reset   ; 
  single_cycle  
   DUT  ( 
       .uart_rx (uart_rx ) ,
      .led (led ) ,
      .digi (digi ) ,
      .sysclk (sysclk ) ,
      .switch (switch ) ,
      .uart_tx (uart_tx ) ,
      .reset (reset ) ); 

initial fork
reset<=1; 
#5 reset<=0; 
#10 reset<=1;
join
initial begin
  switch <= 0;
  sysclk <= 0;
  uart_rx <= 1;
end
initial begin 
  forever #5 sysclk <= ~sysclk;
end
initial begin 
  #104167 uart_rx <= 0;
  #104167 uart_rx <= 1;
  #104167 uart_rx <= 1;
  #104167 uart_rx <= 1;
  #104167 uart_rx <= 1;
  #104167 uart_rx <= 0;
  #104167 uart_rx <= 0;
  #104167 uart_rx <= 0;
  #104167 uart_rx <= 0;
  #104167 uart_rx <= 1;
  
  #1041670 uart_rx <= 0;
  #104167 uart_rx <= 0;
  #104167 uart_rx <= 0;
  #104167 uart_rx <= 0;
  #104167 uart_rx <= 0;
  #104167 uart_rx <= 1;
  #104167 uart_rx <= 1;
  #104167 uart_rx <= 1;
  #104167 uart_rx <= 1;
  #104167 uart_rx <= 1;
end
endmodule