`timescale 1ns/1ps
module multi_cycle_tb_with_uart; 
  reg uart_rx;
  wire [7:0] led;
  wire [11:0] digi;
  reg sysclk;
  reg [7:0] switch;
  wire uart_tx;
  reg reset; 
  Muti_cycle DUT (.reset(reset),.sysclk(sysclk),.switch(switch),.digi(digi),.led(led),.uart_rx(uart_rx),.uart_tx(uart_tx));


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

