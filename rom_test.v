`timescale 1ns/1ps

module ROM (addr,data);
input [30:0] addr;
output [31:0] data;

localparam ROM_SIZE = 32;
(* rom_style = "distributed" *) reg [31:0] ROMDATA[ROM_SIZE-1:0];

assign data=(addr[30:2] < ROM_SIZE)?ROMDATA[addr[30:2]]:32'b0;

integer i;
initial begin
		ROMDATA[0] <= 32'h00000000;
		ROMDATA[1] <= 32'h00000000;
		ROMDATA[2] <= 32'h00000000;
		ROMDATA[3] <= 32'h00000000;
		ROMDATA[4] <= 32'h00000000;
		ROMDATA[5] <= 32'h3c118000;
		ROMDATA[6] <= 32'h241000aa;
		ROMDATA[7] <= 32'h26310004;
		ROMDATA[8] <= 32'hae200000;
		ROMDATA[9] <= 32'h0c00000a;
		//ROMDATA[5] <= 32'h00000000;
		ROMDATA[10] <= 32'h00112100; //sll $4 $17 0x00004 测 正确
		ROMDATA[11] <= 32'h001128C3; //sra $5 $17 0x00003 测 有符号 正确
		ROMDATA[12] <= 32'h00918825; //or $17 $4 $17 测 正确
		ROMDATA[13] <= 32'h00918820; //add $17 $4 $17 正确
	    ROMDATA[14] <= 32'hAE110003; //sw $17 0x0003($16)
		ROMDATA[15] <= 32'h0274882A; //slt $17 $19 $20 #测 变零 正确
		ROMDATA[16] <= 32'h10110001;
		ROMDATA[17] <= 32'h00858822;
		ROMDATA[18] <= 32'h00a48822;
		
		ROMDATA[19] <= 32'h8E140003; //lw $20 0x0003($16) 测 读到了 正确
		ROMDATA[20] <= 32'h08000001;
        
	    for (i=21;i<ROM_SIZE;i=i+1) begin
            ROMDATA[i] <= 32'b0;
        end
end
endmodule
