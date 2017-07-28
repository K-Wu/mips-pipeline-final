`timescale 1ns/1ps

module ROM (addr,data);
input [30:0] addr;
output [31:0] data;

localparam ROM_SIZE = 64;
(* rom_style = "distributed" *) reg [31:0] ROMDATA[ROM_SIZE-1:0];

assign data=(addr[30:2] < ROM_SIZE)?ROMDATA[addr[30:2]]:32'b0;

integer i;
initial begin
		ROMDATA[0] <= 32'h00000000;//labelstart: sll $0 $0 0
		ROMDATA[1] <= 32'h00000000;//sll $0 $0 0
		ROMDATA[2] <= 32'h00000000;//sll $0 $0 0
		ROMDATA[3] <= 32'h00000000;//sll $0 $0 0
		ROMDATA[4] <= 32'h00000000;//sll $0 $0 0
		ROMDATA[5] <= 32'h21ef0001;//addi $15 $15 1
		ROMDATA[6] <= 32'h21ef0001;//addi $15 $15 1
		ROMDATA[7] <= 32'hae0f0000;//sw $15 0x0000($16)
		ROMDATA[8] <= 32'h21ce0001;//addi $14 $14 1
		ROMDATA[9] <= 32'h3c090001;//lui $9 0x0001
		ROMDATA[10] <= 32'h10000000;//beq $0 $0 labelb1
		ROMDATA[11] <= 32'h0c00000f;//labelb1: jal jdst1
		ROMDATA[12] <= 32'h8e090000;//lw $9 0x0000($16)
		ROMDATA[13] <= 32'h21290001;//addi $9 $9 1
		ROMDATA[14] <= 32'h21290001;//addi $9 $9 1
		ROMDATA[15] <= 32'h8e110000;//jdst1: lw $17 0x0000($16)
		ROMDATA[16] <= 32'h26310004;//addiu $17 $17 0x00004
		ROMDATA[17] <= 32'h241000aa;//addiu $16 $0 0x000AA
		ROMDATA[18] <= 32'hae110003;//sw $17 0x0003($16)
		ROMDATA[19] <= 32'h0c000014;//jal jadst1
		ROMDATA[20] <= 32'h00112100;//jadst1: sll $4 $17 0x00004
		ROMDATA[21] <= 32'h10000005;//beq $0 $0 labelb2
		ROMDATA[22] <= 32'h000e7040;//sll $14 $14 1
		ROMDATA[23] <= 32'h000e7040;//sll $14 $14 1
		ROMDATA[24] <= 32'h0800001c;//j jdst2
		ROMDATA[25] <= 32'h000f7840;//sll $15 $15 1
		ROMDATA[26] <= 32'h000f7840;//sll $15 $15 1
		ROMDATA[27] <= 32'h216b0001;//labelb2: addi $11 $11 1
		ROMDATA[28] <= 32'h001128c3;//jdst2: sra $5 $17 0x00003
		ROMDATA[29] <= 32'h00918825;//or $17 $4 $17
		ROMDATA[30] <= 32'h00918820;//add $17 $4 $17
		ROMDATA[31] <= 32'hae110003;//sw $17 0x0003($16)
		ROMDATA[32] <= 32'h0274882a;//slt $17 $19 $20
		ROMDATA[33] <= 32'h10110001;//beq $0 $17 labelb3
		ROMDATA[34] <= 32'h02938822;//sub $17 $20 $19
		ROMDATA[35] <= 32'h02748822;//labelb3: sub $17 $19 $20
		ROMDATA[36] <= 32'h8e140003;//lw $20 0x0003($16)
		ROMDATA[37] <= 32'h08000000;//j labelstart


		//ROMDATA[28] <= 32'h08000000;

        
	    for (i=38;i<ROM_SIZE;i=i+1) begin
            ROMDATA[i] <= 32'b0;
        end
end
endmodule
