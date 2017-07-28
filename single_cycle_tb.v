`timescale 1ns/1ps

module single_cycle_tb;
reg sysclk,reset;
wire [11:0] digi;
wire [7:0] led, switch;
single_cycle U_single_cycle(reset,sysclk,switch,digi,led);
initial fork
reset<=1; 
#5 reset<=0; 
#125 reset<=1;
sysclk<=0;
forever #2 sysclk<=~sysclk;
join


endmodule