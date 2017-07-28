`timescale 1ns/1ns
module Generator(clk,baudrate_clk);
input clk;
output baudrate_clk;
reg baud_clk;
reg [8:0] baud_count;
assign baudrate_clk = baud_clk;
initial begin
  baud_clk <= 0;
  baud_count <= 0;
end
always @(posedge clk) begin
	if (baud_count == 325) begin
		baud_count <= 0;
		baud_clk <= ~baud_clk;
	end
	else begin
		baud_count <= baud_count + 1;
	end
end
endmodule