`timescale 1ns/1ns
module Receiver(baudrate_clk,uart_rx,rx_data,rx_status);
input uart_rx,baudrate_clk;
output [7:0] rx_data;
output rx_status;
reg [7:0] data;
reg status;
assign rx_data = data;
assign rx_status = status;
reg sample;
reg sampled;
reg receiving;
reg [2:0] counter;
reg [3:0] bits;
reg [9:0] tmp;
initial begin
	sample <= 0;
	sampled <= 0;
	receiving <= 0;
	status <= 0;
	data <= 0;
	counter <= 0;
	tmp <= 0;
	bits <= 0;
end
always @(posedge baudrate_clk) begin
	if ((~receiving)&&(~uart_rx)) begin
		receiving <= 1;
		sample <= 0;
	end
	if (receiving) begin
		if (counter == 7) begin
			counter <= 0;
			sample <= ~sample;
		end
		else begin
			counter <= counter + 1;
		end
	end
	if (sample) begin
	   if (~sampled) begin
           tmp [bits] <= uart_rx;
           bits <= bits + 1;
           sampled <= 1;
	   end
	end
	else begin
	   if (sampled) begin 
           sampled <= 0;
       end
	end
	if (bits == 10) begin
		bits <= 0;
		receiving <= 0;
		if (tmp[9]) begin
			data[7:0] <= tmp[8:1];
			status <= 1;
		end
	end
	if (status) begin
		status <= 0;
	end
end
endmodule