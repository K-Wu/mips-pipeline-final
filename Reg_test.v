
`timescale 1ps/1ps

module Reg_tb;



reg clk,Reset;
reg [2:0] PCSrc_in;

reg RegWr_in, MemWr_in,MemRd_in;
reg [1:0] MemToReg_in;

reg [31:0] NewPC_in, ALUResult_in, RegToMemData_in, PC4_in ;
reg [4:0] RdAdress_in;

wire [2:0] PCSrc_out;

wire RegWr_out, MemWr_out,MemRd_out;
wire [1:0] MemToReg_out;

wire [31:0] NewPC_out, ALUResult_out, RegToMemData_out, PC4_out;
wire [4:0] RdAdress_out;

EX_MEM_Register U(clk, Reset, PCSrc_in, RegWr_in,
MemWr_in, MemRd_in, MemToReg_in, 
NewPC_in, PC4_in , ALUResult_in, RegToMemData_in, RdAdress_in,
PCSrc_out, RegWr_out, MemWr_out, MemRd_out, MemToReg_out, 
NewPC_out, PC4_out ,ALUResult_out, RegToMemData_out, RdAdress_out);




initial fork
clk<=0;
 RegWr_in=1;
 MemToReg_in=2;

PC4_in=7;

ALUResult_in=9;

RdAdress_in = 14;

#5 Reset<=0; 
#10 Reset<=1;

forever #2 clk<=~clk;
join


endmodule