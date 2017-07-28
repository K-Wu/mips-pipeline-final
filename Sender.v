`timescale 1ns/1ns
module Sender(tx_data,tx_en,baudrate_clk,uart_tx,tx_status);
input [7:0] tx_data;
input tx_en,baudrate_clk;
output uart_tx,tx_status;
reg uart;
reg sending;
assign uart_tx = uart;
assign tx_status = ~sending;
reg en;
reg [3:0] counter;
reg [3:0] bits;
reg [9:0] tmp;
initial begin
	counter <= 0;
	tmp <= 0;
	uart <= 1;
	bits <= 0;
	en <= 0;
	sending <= 0;
end
always @(posedge baudrate_clk or posedge tx_en) begin
	if (tx_en) begin
		en <= 1;
	end
	else begin
	  	if (en) begin
		  	en <= 0;
			uart <= 0;
			sending <= 1;
			tmp <= {1'b1, tx_data[7:0], 1'b0};
			bits <= 1;
		end
		if (sending) begin
			if (counter == 15) begin
				if (bits == 10) begin
					sending <= 0;
					bits <= 0;
				end
				else begin
					uart <= tmp [bits];
					bits <= bits + 1;
				end
				counter <= 0;
			end
			else begin
				counter <= counter + 1;
			end
		end
	end
end
endmodule