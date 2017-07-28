
`timescale 1ns/1ps

module Muti_cycle_tb;
reg sysclk,reset;
wire [11:0] digi;
wire [7:0] led, switch;
wire uart_tx;
reg uart_rx;
initial begin
uart_rx = 1;
end
Muti_cycle U_single_cycle(reset,sysclk,switch,digi,led,uart_rx,uart_tx);
initial fork
reset<=1; 
uart_rx<=1;
#5 reset<=0; 
#125 reset<=1;
sysclk<=0;
forever #2 sysclk<=~sysclk;
join


endmodule