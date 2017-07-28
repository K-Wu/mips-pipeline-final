module single_cycle(reset,sysclk,switch,digi,led,uart_rx,uart_tx);

input reset,sysclk;
input uart_rx;
output uart_tx;
output [11:0] digi;
output [7:0] led;
input [7:0] switch;
reg [31:0] PC;wire [31:0] Instruct;
wire [31:0] _PCadd4,PCadd4,ConBA,JT,DataBusA,DataBusB;
wire [15:0] Imm16;wire [4:0] Shamt;
wire [4:0] Rd, Rt, Rs;
wire [31:0] ALUOut, PCIn, PC1;wire [5:0] ALUFun;
wire [7:0] watchdog;
wire [2:0] PCSrc;wire [1:0] RegDst;wire [1:0] MemToReg;
wire RegWr,ALUSrc1,ALUSrc2, Sign, MemWr, MemRd, EXTOp, LUOp;

parameter ILLOP=32'h80000004;
parameter XADR=32'h80000008;
parameter Ra=31;
cpuclk U_cpuclk(clk,sysclk,reset);
//IF
ROM5 U_rom(PC[30:0],Instruct);
Control U_control(Instruct, IRQ, PC[31],PCSrc, RegDst, RegWr,ALUSrc1, ALUSrc2, ALUFun, Sign, MemWr, MemRd, MemToReg,EXTOp, LUOp);

assign watchdog = PC[9:2];

assign JT={PC[31:28],Instruct[25:0],2'b0};
assign Imm16=Instruct[15:0];
assign Shamt=Instruct[10:6];
assign Rd=Instruct[15:11];
assign Rt=Instruct[20:16];
assign Rs=Instruct[25:21];

assign _PCadd4=PC+4;
assign PCadd4={PC[31],_PCadd4[30:0]};
assign PC1=ALUOut[0]?ConBA:PCadd4;
assign PCIn=(PCSrc==3'b000)?PCadd4:
				(PCSrc==3'b001)?PC1:
					(PCSrc==3'b010)?JT:
						(PCSrc==3'b011)?DataBusA:
							(PCSrc==3'b100)?ILLOP:XADR;

always @(negedge reset or posedge clk)
begin
	if(~reset)
		PC<=32'h80000000;
	else
		PC <= PCIn;
end

//ID
parameter Xp=26;
wire [4:0] AddrC;wire [31:0] DataBusC;
wire [31:0] ALUIn1,ALUIn2;
wire [31:0] EXTout,LUout,_EXTout_shift2; 
RegFile U_regfile(reset,clk,Rs,DataBusA,Rt,DataBusB,RegWr,AddrC,DataBusC);
assign AddrC=(RegDst==0)?Rd:
				(RegDst==1)?Rt:
					(RegDst==2)?Ra:Xp;
assign EXTout=EXTOp?(Imm16[15]?{16'hFFFF,Imm16}:{16'h0000,Imm16}):{16'h0000,Imm16};
assign LUout=LUOp?{Imm16,16'b0}:EXTout;
assign ALUIn1=ALUSrc1?Shamt:DataBusA;
assign ALUIn2=ALUSrc2?LUout:DataBusB;
assign _EXTout_shift2={EXTout[29:0],2'b00};
assign ConBA=PCadd4+_EXTout_shift2;//TODO会改变监督位？

//EX
ALU U_alu(ALUOut,ALUIn1,ALUIn2,ALUFun,Sign);

//MEM
wire [31:0] mem_rddata,peri_rddata,uart_data;
wire uart_tx,uart_rx,irqout,rx_irq,tx_irq;
wire [7:0] led,switch;//led输出，switch输入
wire [11:0] digi;//digi输出
DataMem U_mem(reset,clk,MemRd,MemWr,ALUOut,DataBusB,mem_rddata);
Peripheral U_peripheral(reset,clk,MemRd,MemWr,ALUOut,DataBusB,peri_rddata,led,switch,digi,irqout);
Uart U_uart(sysclk, clk, reset, uart_tx, uart_rx, MemRd, MemWr, ALUOut, DataBusB, uart_data, rx_irq, tx_irq);
assign IRQ=tx_irq|rx_irq|irqout;//
//WB
assign DataBusC=(MemToReg==0)?ALUOut:
					(MemToReg==1)?(mem_rddata|peri_rddata|uart_data):PCadd4;

endmodule