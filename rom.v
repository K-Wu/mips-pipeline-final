`timescale 1ns/1ps

module ROM5 (addr,data);
input [30:0] addr;
output [31:0] data;

localparam ROM_SIZE = 256;
(* rom_style = "distributed" *) reg [31:0] ROMDATA[ROM_SIZE-1:0];

assign data=(addr[30:2] < ROM_SIZE)?ROMDATA[addr[30:2]]:32'b0;

integer i;
initial begin
ROMDATA[0] <= 32'h0800006d;//j Start
ROMDATA[1] <= 32'h08000069;//j ill_handler
ROMDATA[2] <= 32'h08000003;//j IRQ
ROMDATA[3] <= 32'h3c194000;//IRQ: lui $t9 0x4000
ROMDATA[4] <= 32'h8f310008;//lw $s1 8($t9)
ROMDATA[5] <= 32'h32380004;//andi $t8 $s1 4
ROMDATA[6] <= 32'h3231fff9;//andi $s1 $s1 0xfff9
ROMDATA[7] <= 32'haf310008;//sw $s1 8($t9)
ROMDATA[8] <= 32'h17000012;//bne $t8 $zero Timer
ROMDATA[9] <= 32'h8f310020;//lw $s1 32($t9)
ROMDATA[10] <= 32'h322f0008;//andi $t7 $s1 8
ROMDATA[11] <= 32'h3231fff0;//andi $s1 $s1 0xfff0
ROMDATA[12] <= 32'haf310020;//sw $s1 32($t9)
ROMDATA[13] <= 32'h15e00054;//bne $t7 $zero Read
ROMDATA[14] <= 32'h10020002;//beq $zero $v0 Return
ROMDATA[15] <= 32'haf220018;//sw $v0 24($t9)
ROMDATA[16] <= 32'h20020000;//addi $v0 $zero 0
ROMDATA[17] <= 32'h8f310008;//Return: lw $s1 8($t9)
ROMDATA[18] <= 32'h20180002;//addi $t8 $zero 2
ROMDATA[19] <= 32'h02388825;//or $s1 $s1 $t8
ROMDATA[20] <= 32'haf310008;//sw $s1 8($t9)
ROMDATA[21] <= 32'h8f310020;//lw $s1 32($t9)
ROMDATA[22] <= 32'h20180003;//addi $t8 $zero 3
ROMDATA[23] <= 32'h02388825;//or $s1 $s1 $t8
ROMDATA[24] <= 32'haf310020;//sw $s1 32($t9)
ROMDATA[25] <= 32'h235afffc;//addi $k0 $k0 -4
ROMDATA[26] <= 32'h03400008;//jr $k0
ROMDATA[27] <= 32'h8f320014;//Timer: lw $s2 20($t9)
ROMDATA[28] <= 32'h324f0f00;//andi $t7 $s2 0x0f00
ROMDATA[29] <= 32'h200a0700;//addi $t2 $zero 0x0700
ROMDATA[30] <= 32'h20090b00;//addi $t1 $zero 0x0b00
ROMDATA[31] <= 32'h11ea000a;//beq $t7 $t2 Second
ROMDATA[32] <= 32'h200a0b00;//addi $t2 $zero 0x0b00
ROMDATA[33] <= 32'h20090d00;//addi $t1 $zero 0x0d00
ROMDATA[34] <= 32'h11ea0009;//beq $t7 $t2 Third
ROMDATA[35] <= 32'h200a0d00;//addi $t2 $zero 0x0d00
ROMDATA[36] <= 32'h20090e00;//addi $t1 $zero 0x0e00
ROMDATA[37] <= 32'h11ea0009;//beq $t7 $t2 Fourth
ROMDATA[38] <= 32'h20090700;//addi $t1 $zero 0x0700
ROMDATA[39] <= 32'h30ce00f0;//andi $t6 $a2 0x00f0
ROMDATA[40] <= 32'h000e7102;//srl $t6 $t6 4
ROMDATA[41] <= 32'h08000031;//j Decode
ROMDATA[42] <= 32'h30ce000f;//Second: andi $t6 $a2 0x000f
ROMDATA[43] <= 32'h08000031;//j Decode
ROMDATA[44] <= 32'h30ee00f0;//Third: andi $t6 $a3 0x00f0
ROMDATA[45] <= 32'h000e7102;//srl $t6 $t6 4
ROMDATA[46] <= 32'h08000031;//j Decode
ROMDATA[47] <= 32'h30ee000f;//Fourth: andi $t6 $a3 0x000f
ROMDATA[48] <= 32'h08000031;//j Decode
ROMDATA[49] <= 32'h200d0000;//Decode: addi $t5 $zero 0
ROMDATA[50] <= 32'h200c00c0;//addi $t4 $zero 0xc0
ROMDATA[51] <= 32'h11ae002b;//beq $t5 $t6 Digi
ROMDATA[52] <= 32'h200d0001;//addi $t5 $zero 1
ROMDATA[53] <= 32'h200c00f9;//addi $t4 $zero 0xf9
ROMDATA[54] <= 32'h11ae0028;//beq $t5 $t6 Digi
ROMDATA[55] <= 32'h200d0002;//addi $t5 $zero 2
ROMDATA[56] <= 32'h200c00a4;//addi $t4 $zero 0xa4
ROMDATA[57] <= 32'h11ae0025;//beq $t5 $t6 Digi
ROMDATA[58] <= 32'h200d0003;//addi $t5 $zero 3
ROMDATA[59] <= 32'h200c00b0;//addi $t4 $zero 0xb0
ROMDATA[60] <= 32'h11ae0022;//beq $t5 $t6 Digi
ROMDATA[61] <= 32'h200d0004;//addi $t5 $zero 4
ROMDATA[62] <= 32'h200c0099;//addi $t4 $zero 0x99
ROMDATA[63] <= 32'h11ae001f;//beq $t5 $t6 Digi
ROMDATA[64] <= 32'h200d0005;//addi $t5 $zero 5
ROMDATA[65] <= 32'h200c0092;//addi $t4 $zero 0x92
ROMDATA[66] <= 32'h11ae001c;//beq $t5 $t6 Digi
ROMDATA[67] <= 32'h200d0006;//addi $t5 $zero 6
ROMDATA[68] <= 32'h200c0082;//addi $t4 $zero 0x82
ROMDATA[69] <= 32'h11ae0019;//beq $t5 $t6 Digi
ROMDATA[70] <= 32'h200d0007;//addi $t5 $zero 7
ROMDATA[71] <= 32'h200c00f8;//addi $t4 $zero 0xf8
ROMDATA[72] <= 32'h11ae0016;//beq $t5 $t6 Digi
ROMDATA[73] <= 32'h200d0008;//addi $t5 $zero 8
ROMDATA[74] <= 32'h200c0080;//addi $t4 $zero 0x80
ROMDATA[75] <= 32'h11ae0013;//beq $t5 $t6 Digi
ROMDATA[76] <= 32'h200d0009;//addi $t5 $zero 9
ROMDATA[77] <= 32'h200c0090;//addi $t4 $zero 0x90
ROMDATA[78] <= 32'h11ae0010;//beq $t5 $t6 Digi
ROMDATA[79] <= 32'h200d000a;//addi $t5 $zero 10
ROMDATA[80] <= 32'h200c0088;//addi $t4 $zero 0x88
ROMDATA[81] <= 32'h11ae000d;//beq $t5 $t6 Digi
ROMDATA[82] <= 32'h200d000b;//addi $t5 $zero 11
ROMDATA[83] <= 32'h200c0083;//addi $t4 $zero 0x83
ROMDATA[84] <= 32'h11ae000a;//beq $t5 $t6 Digi
ROMDATA[85] <= 32'h200d000c;//addi $t5 $zero 12
ROMDATA[86] <= 32'h200c00c6;//addi $t4 $zero 0xc6
ROMDATA[87] <= 32'h11ae0007;//beq $t5 $t6 Digi
ROMDATA[88] <= 32'h200d000d;//addi $t5 $zero 13
ROMDATA[89] <= 32'h200c00a1;//addi $t4 $zero 0xa1
ROMDATA[90] <= 32'h11ae0004;//beq $t5 $t6 Digi
ROMDATA[91] <= 32'h200d000e;//addi $t5 $zero 14
ROMDATA[92] <= 32'h200c0086;//addi $t4 $zero 0x86
ROMDATA[93] <= 32'h11ae0001;//beq $t5 $t6 Digi
ROMDATA[94] <= 32'h200c008e;//addi $t4 $zero 0x8e
ROMDATA[95] <= 32'h01899020;//Digi: add $s2 $t4 $t1
ROMDATA[96] <= 32'haf320014;//sw $s2 20($t9)
ROMDATA[97] <= 32'h08000011;//j Return
ROMDATA[98] <= 32'h10800004;//Read: beq $a0 $zero Firstpara
ROMDATA[99] <= 32'h10a00001;//beq $a1 $zero Secondpara
ROMDATA[100] <= 32'h08000011;//j Return
ROMDATA[101] <= 32'h8f25001c;//Secondpara: lw $a1 28($t9)
ROMDATA[102] <= 32'h08000011;//j Return
ROMDATA[103] <= 32'h8f24001c;//Firstpara: lw $a0 28($t9)
ROMDATA[104] <= 32'h08000011;//j Return
ROMDATA[105] <= 32'h08000069;//ill_handler: j ill_handler
ROMDATA[106] <= 32'h001ff840;//Next: sll $ra $ra 1
ROMDATA[107] <= 32'h001ff842;//srl $ra $ra 1
ROMDATA[108] <= 32'h03e00008;//jr $ra
ROMDATA[109] <= 32'h0c00006a;//Start: jal Next
ROMDATA[110] <= 32'h3c194000;//lui $t9 0x4000
ROMDATA[111] <= 32'haf200008;//sw $zero 8($t9)
ROMDATA[112] <= 32'h3c18ffff;//lui $t8 0xffff
ROMDATA[113] <= 32'h2018d8ef;//addi $t8 $zero 0xd8ef
ROMDATA[114] <= 32'haf380000;//sw $t8 0($t9)
ROMDATA[115] <= 32'h3c18ffff;//lui $t8 0xffff
ROMDATA[116] <= 32'h2018ffff;//addi $t8 $zero 0xffff
ROMDATA[117] <= 32'haf380004;//sw $t8 4($t9)
ROMDATA[118] <= 32'haf380014;//sw $t8 20($t9)
ROMDATA[119] <= 32'h20180003;//addi $t8 $zero 3
ROMDATA[120] <= 32'haf380008;//sw $t8 8($t9)
ROMDATA[121] <= 32'h1080ffff;//Wait: beq $a0 $zero Wait
ROMDATA[122] <= 32'h10a0fffe;//beq $a1 $zero Wait
ROMDATA[123] <= 32'h00803020;//add $a2 $a0 $zero
ROMDATA[124] <= 32'h00a03820;//add $a3 $a1 $zero
ROMDATA[125] <= 32'h0085402a;//Check: slt $t0 $a0 $a1
ROMDATA[126] <= 32'h15000004;//bne $t0 $zero Less
ROMDATA[127] <= 32'h00852022;//More: sub $a0 $a0 $a1
ROMDATA[128] <= 32'h1480fffc;//bne $a0 $zero Check
ROMDATA[129] <= 32'h00052020;//add $a0 $zero $a1
ROMDATA[130] <= 32'h08000085;//j Result
ROMDATA[131] <= 32'h00a42822;//Less: sub $a1 $a1 $a0
ROMDATA[132] <= 32'h14a0fff8;//bne $a1 $zero Check
ROMDATA[133] <= 32'h00801020;//Result: add $v0 $a0 $zero
ROMDATA[134] <= 32'haf22000c;//sw $v0 12($t9)
ROMDATA[135] <= 32'haf220018;//sw $v0 24($t9)
ROMDATA[136] <= 32'h20040000;//addi $a0 $zero 0
ROMDATA[137] <= 32'h20050000;//addi $a1 $zero 0
ROMDATA[138] <= 32'h20020000;//addi $v0 $zero 0
ROMDATA[139] <= 32'h08000079;//j Wait



	    //for (i=128;i<ROM_SIZE;i=i+1) begin
        //    ROMDATA[i] <= 32'b0;
        //end
end
endmodule
