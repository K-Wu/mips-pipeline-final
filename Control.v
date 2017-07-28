module Control(Instruct, IRQ, PC_31,PCSrc, RegDst, RegWrite,ALUSrc1, ALUSrc2, ALUFun, Sign, MemWr, MemRd, MemToReg,EXTOp, LUOp);
input [31:0]Instruct;
input IRQ,PC_31;
output [2:0]PCSrc;
output [1:0]RegDst;
output [1:0]MemToReg;
output [5:0]ALUFun;
output RegWrite,ALUSrc1, ALUSrc2, Sign, MemWr, MemRd,EXTOp, LUOp;
wire [5:0] OpCode; 
assign OpCode = Instruct[31:26];
wire[5:0] Funct;
assign Funct = Instruct[5:0];
wire ill_operation,interuption;
//当PC_31为1的时候，不允许发生中断和异常
assign ill_operation = ~(((OpCode == 6'h23) || (OpCode == 6'h2b) || (OpCode == 6'h0f) || 
				(OpCode == 6'h08) || (OpCode == 6'h09) || (OpCode == 6'h0c) || (OpCode == 6'h20) || 
				(OpCode == 6'h0a) || (OpCode == 6'h0b) || (OpCode == 6'h04) || (OpCode == 6'h05) || 
				(OpCode == 6'h06) || (OpCode == 6'h07) || (OpCode == 6'h01) || (OpCode == 6'h02) || 
				(OpCode == 6'h03) || ((OpCode == 6'h00) && ((Funct == 6'h00) || (Funct == 6'h02) || 
				(Funct == 6'h03) || (Funct == 6'h22) || (Funct == 6'h23) || (Funct == 6'h08) || 
				(Funct == 6'h09) || (Funct == 6'h20) || (Funct == 6'h21) || (Funct == 6'h24) || 
				(Funct == 6'h25) || (Funct == 6'h26) || (Funct == 6'h27) || (Funct == 6'h2a) )))||PC_31); 

assign interuption = (~PC_31)&&IRQ;				

assign PCSrc[2:0]=
		(interuption)?5:
		(ill_operation)?4:
		((OpCode == 6'h04)||(OpCode == 6'h05)||(OpCode == 6'h06)||(OpCode == 6'h07))?1:
		((OpCode == 6'h02)||(OpCode == 6'h03))?2:
		((OpCode == 6'h00)&&((Funct==6'h08)||(Funct==6'h09)))?3:
		0;

assign RegDst[1:0] =
		(ill_operation||interuption)?3:
		(OpCode == 6'h03||(OpCode==0&&Funct==6'h09))?2:
		(OpCode == 0)?0:
		1;
		
assign RegWrite=
		(ill_operation||interuption)?1:
		((OpCode == 6'h2b)||(OpCode == 6'h04)||(OpCode == 6'h02)||(OpCode == 6'h06)||
		(OpCode == 6'h05)||(OpCode == 6'h07)||(OpCode == 6'h01)||(Instruct == 0)||
		((OpCode == 6'h00)&&(Funct==6'h08))||Instruct==0)?0:
		1;

assign ALUSrc1 = 
		((OpCode == 0)&&((Funct == 0)||(Funct == 6'h02)||Funct == 6'h03))?1:
		0;

assign ALUSrc2 = 
		(OpCode == 6'h00 || OpCode == 6'h04 || OpCode == 6'h05 || 
		OpCode == 6'h06 || OpCode == 6'h07 || OpCode == 6'h01)?0:
		1;
		
assign ALUFun = 
		((OpCode == 6'h25)||((OpCode == 0)&&(Funct == 6'h25)))?6'b011110:
		((OpCode == 0)&&((Funct == 6'h22)||(Funct == 6'h23)))?6'b000001:
		((OpCode == 6'h0c)||((OpCode == 0)&&(Funct == 6'h24)))?6'b011000:
		((OpCode == 0)&&(Funct == 6'h26))?6'b010110:
		((OpCode == 0)&&(Funct == 6'h27))?6'b010001:
		((OpCode == 0)&&(Funct == 0))?6'b100000:
		((OpCode == 0)&&(Funct == 6'h02))?6'b100001:
		((OpCode == 0)&&(Funct == 6'h03))?6'b100011:
		((OpCode == 6'h0a)||(OpCode == 6'h0b)||((OpCode == 0)&&(Funct == 6'h2a)))?6'b110101:
		(OpCode == 6'h04)?6'b110011:
		(OpCode == 6'h05)?6'b110001:
		(OpCode == 6'h06)?6'b111101:
		(OpCode == 6'h07)?6'b111111:
		(OpCode == 6'h01)?6'b111011:
		0;
		
assign Sign = 
		((OpCode == 6'h09 || OpCode == 6'h0b)||
		(OpCode == 6'h00 && (Funct == 6'h23 ||  Funct == 6'h21)))? 0:
		1;

assign MemRd = 
		(OpCode == 6'h23)?1:
		0;
		
assign MemWr = 
		(OpCode == 6'h2b)?1:
		0;
		
assign MemToReg = 
		(interuption||ill_operation)?2:
		(OpCode == 6'h23)?1:
		((OpCode == 6'h03)||((OpCode == 0)&&((Funct == 6'h08)||(Funct == 6'h09))))?2:
		0;
		
assign EXTOp = 
		(OpCode == 6'h0c)? 0:
		1;
		
assign LUOp = 
		(OpCode == 6'h0f)? 1:
		0;
		

endmodule