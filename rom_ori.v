`timescale 1ns/1ps

module ROM (addr,data);
input [30:0] addr;
output [31:0] data;

localparam ROM_SIZE = 32;
(* rom_style = "distributed" *) reg [31:0] ROMDATA[ROM_SIZE-1:0];

assign data=(addr < ROM_SIZE)?ROMDATA[addr[30:2]]:32'b0;

integer i;
initial begin
		ROMDATA[0] <= 32'h00000000;
		ROMDATA[1] <= 32'h00000000;
		ROMDATA[2] <= 32'h00000000;
		ROMDATA[3] <= 32'h00000000;
		ROMDATA[4] <= 32'h00000000;
		ROMDATA[5] <= 32'h3c114000;
		ROMDATA[6] <= 32'h26310004;
		ROMDATA[7] <= 32'h241000aa;
		ROMDATA[8] <= 32'hae200000;
		ROMDATA[9] <= 32'h08100000;
		ROMDATA[10] <= 32'h0c000000;
		ROMDATA[11] <= 32'h00000000;
		ROMDATA[12] <= 32'h3402000a;
		ROMDATA[13] <= 32'h0000000c;
		ROMDATA[14] <= 32'h0000_0000;
		ROMDATA[15]<= 32'h0274_8825;
		ROMDATA[16] <= 32'h0800_0015;
		ROMDATA[17] <= 32'h0274_8820;
		ROMDATA[18] <= 32'h0800_0015;
		ROMDATA[19] <= 32'h0274_882A;
		ROMDATA[20] <= 32'h1011_0002;
		ROMDATA[21] <= 32'h0293_8822;
		ROMDATA[22] <= 32'h0800_0015;
		ROMDATA[23] <= 32'h0274_8822;
		ROMDATA[24] <= 32'h0800_0015; 
		ROMDATA[25] <= 32'h0274_8824;
		ROMDATA[26] <= 32'hae11_0003;
		ROMDATA[27] <= 32'h0800_0001;
       
	    for (i=28;i<ROM_SIZE;i=i+1) begin
            ROMDATA[i] <= 32'b0;
        end
end
endmodule
