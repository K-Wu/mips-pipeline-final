module Muti_cycle(reset,sysclk,switch,digi,led,uart_rx,uart_tx);

input reset,sysclk;
input uart_rx;
output uart_tx;
output [11:0] digi;
output [7:0] led;
input [7:0] switch;
reg [31:0] PC;wire [31:0] Instruct;
wire [31:0] _PCadd4,PCadd4,ConBA,JT,DataBusA,DataBusA_EX,DataBusB,DataBusB_EX,Instruction_ID, Instruction_EX, PC4_ID, PC4_WB,PC4_EX, PC4_MEM;
wire [4:0] RdAdress_MEM, RdAdress_EX,Rt_EX,Rs_EX;
wire [15:0] Imm16;wire [4:0] Shamt, Shamt_EX;
wire [4:0] Rd, Rt, Rs;
wire [31:0] ALUOut, PCIn, ALUOut_MEM, ALUOut_WB, Data_WB, peri_rddata_WB, uart_data_WB, Imm_EX;
wire [5:0] ALUFun,ALUFun_EX;
wire [1:0] ForwardA,ForwardB;
wire [2:0] PCSrc,PCSrc_EX,PCSrc_MEM;wire [1:0] RegDst,RegDst_EX;wire [1:0] MemToReg,MemToReg_EX,MemToReg_MEM,MemToReg_WB;
wire RegWr,ALUSrc1,ALUSrc2, Sign, MemWr, MemRd, EXTOp, LUOp, RegWr_EX, ALUSrc1_EX, ALUSrc2_EX,
 Sign_EX, MemWr_EX, MemRd_EX, 
RegWr_WB,
bubble,ID_EX_Flush,IF_ID_Flush, IF_ID_Flush0, EX_MEM_FORWARD;
wire bcomp;
wire Flushed_out_ID, Flushed_out_EX;
wire IRQ; reg IRQ_sync;


wire [9:0] watchdog;
assign watchdog = PC[9:2];//for debug

assign IF_ID_Flush0 = bubble | IF_ID_Flush;//TODO!!

parameter ILLOP=32'h80000004;
parameter XADR=32'h80000008;
parameter Ra=31;
assign clk = sysclk;//for WNS calculation
//cpuclk U_cpuclk(clk,sysclk,reset);
//IF
ROM5 U_rom(PC[30:0],Instruct);




assign _PCadd4=PC+4;
assign PCadd4={PC[31],_PCadd4[30:0]};					
IF_ID_Register U_IF_ID_Register(clk, IF_ID_Flush0, Instruct, PCadd4, Instruction_ID, PC4_ID,reset,IRQ_sync, PC4_ID[31],Flushed_out_ID);
always @(negedge reset or posedge clk)
begin
	if(~reset)
		PC<=32'h80000000;
	else if(~bubble)
		PC <= PCIn;
end

always @(negedge reset or posedge clk)
begin
	if (~reset)
		IRQ_sync<=0;
	else
		IRQ_sync<=IRQ;
end
wire [31:0] DataBusA_Forwarded, DataBusB_Forwarded;
assign PCIn=
		(PCSrc==3'b100)?ILLOP://规定4是异常，5是中�?
			(PCSrc==3'b101)?XADR:
				(PCSrc_EX==3'b001&&bcomp)?ConBA:
					(PCSrc_EX==3'b011)?DataBusA_Forwarded:
						(PCSrc==3'b010)?JT:PCadd4;//TODO PCSrc的来源？多路选择器？
//ID
Control U_control(Instruction_ID, IRQ_sync,  PC4_ID[31],PCSrc, RegDst, RegWr,ALUSrc1, ALUSrc2, ALUFun, Sign, MemWr, MemRd, MemToReg,EXTOp, LUOp);
assign JT={PC4_ID[31:28],Instruction_ID[25:0],2'b0};//position?
assign Imm16=Instruction_ID[15:0];

assign Rd=Instruction_ID[15:11];
assign Rt=Instruction_ID[20:16];
assign Rs=Instruction_ID[25:21];





parameter Xp=26;
wire [4:0] AddrC,RdAdress_WB;wire [31:0] DataBusC;

wire [31:0] EXTout,LUout,_EXTout_shift2; 
RegFile U_regfile(reset,clk,Rs,DataBusA,Rt,DataBusB,RegWr_WB,RdAdress_WB,DataBusC);
assign AddrC=(RegDst==0)?Rd:
				(RegDst==1)?Rt:
					(RegDst==2)?Ra:Xp;
assign EXTout=EXTOp?(Imm16[15]?{16'hFFFF,Imm16}:{16'h0000,Imm16}):{16'h0000,Imm16};
assign LUout=LUOp?{Imm16,16'b0}:EXTout;
assign Shamt=Instruction_ID[10:6];
//wire ID_EX_Flush0;
//assign ID_EX_Flush0 = ID_EX_Flush;
ID_EX_Register U_ID_EX_Register(clk, ID_EX_Flush, PCSrc, RegDst, RegWr, ALUSrc1, ALUSrc2,
ALUFun, Sign, MemWr, MemRd, MemToReg, 
PC4_ID, DataBusA, DataBusB, LUout, AddrC,Shamt,Instruction_ID,Flushed_out_ID,
PCSrc_EX, RegDst_EX, RegWr_EX, ALUSrc1_EX, ALUSrc2_EX,
ALUFun_EX, Sign_EX, MemWr_EX, MemRd_EX, MemToReg_EX, 
PC4_EX, DataBusA_EX, DataBusB_EX, Imm_EX, RdAdress_EX, Shamt_EX,Instruction_EX,reset, Flushed_out_EX);//有大�?

//EX

assign Rt_EX=Instruction_EX[20:16];
assign Rs_EX=Instruction_EX[25:21];
wire [31:0] ALUIn1,ALUIn2;
wire [31:0] RegToMemData_MEM;

wire [31:0] NewPC_MEM;
assign DataBusA_Forwarded = (ForwardA == 2'b10)?ALUOut_MEM:(ForwardA == 2'b01)?DataBusC:DataBusA_EX;
assign DataBusB_Forwarded = (ForwardB == 2'b10)?ALUOut_MEM:(ForwardB == 2'b01)?DataBusC:DataBusB_EX;
assign ALUIn1=ALUSrc1_EX?Shamt_EX:DataBusA_Forwarded;
assign ALUIn2=ALUSrc2_EX?Imm_EX:DataBusB_Forwarded;
branch_compare U_branch_compare(bcomp,ALUIn1,ALUIn2,ALUFun_EX[4:1]);
ALU U_alu(ALUOut,ALUIn1,ALUIn2,ALUFun_EX,Sign_EX);

assign _EXTout_shift2={Imm_EX[29:0],2'b00};
assign ConBA=PC4_EX+_EXTout_shift2;
EX_MEM_Register U_EX_MEM_Register(clk, EX_MEM_FORWARD,PCSrc_EX, RegWr_EX,
MemWr_EX, MemRd_EX, MemToReg_EX, 
PCIn, PC4_EX , ALUOut, /*RegToMemData_in*/DataBusB_Forwarded, RdAdress_EX,//wk79upd:这里应该考虑转发�?否则addi addi sw转发通不�?
PCadd4, PC4_ID, Flushed_out_ID, Flushed_out_EX,
PCSrc_MEM, RegWr_MEM, MemWr_MEM, MemRd_MEM, MemToReg_MEM, 
NewPC_MEM, PC4_MEM ,ALUOut_MEM, /*RegToMemData_out*/RegToMemData_MEM, RdAdress_MEM, reset, PCSrc);//PCIn是啥？还要不�?

//MEM
wire [31:0] mem_rddata,peri_rddata,uart_data;
wire uart_tx,uart_rx,irqout,rx_irq,tx_irq;
wire [7:0] led,switch;//led???switch??
wire [11:0] digi;//digi??
DataMem U_mem(reset,clk,MemRd_MEM,MemWr_MEM,ALUOut_MEM,RegToMemData_MEM,mem_rddata);
Peripheral U_peripheral(reset,clk,MemRd_MEM,MemWr_MEM,ALUOut_MEM,RegToMemData_MEM,peri_rddata,led,switch,digi,irqout);
Uart U_uart(sysclk, clk, reset, uart_tx, uart_rx, MemRd_MEM, MemWr_MEM, ALUOut_MEM, RegToMemData_MEM, uart_data, rx_irq, tx_irq);
assign IRQ=rx_irq|tx_irq|irqout;
MEM_WB_Register U_MEM_WB_Register(clk, RegWr_MEM,
MemToReg_MEM, PC4_MEM,
/*Data_in*/mem_rddata, ALUOut_MEM, RdAdress_MEM,
RegWr_WB, MemToReg_WB, PC4_WB,
/*Data_out*/Data_WB, ALUOut_WB, RdAdress_WB,
peri_rddata, uart_data, peri_rddata_WB, uart_data_WB, reset);//peri_rddata, uart_data的用处？

//WB
assign DataBusC=(MemToReg_WB==0)?ALUOut_WB:
					(MemToReg_WB==1)?(Data_WB|peri_rddata_WB|uart_data_WB):PC4_WB;






//Hazard
HazardDetection U_HazardDetection(PCSrc_EX, bcomp, PCSrc, MemRd, /*ID_EX_Rt*/Rt,Instruct[25:21],/*IF_ID_Rt*/Instruct[20:16], bubble,ID_EX_Flush,IF_ID_Flush, EX_MEM_FORWARD);
//forward

forward U_forward(ForwardA,ForwardB,RegWr_MEM,RegWr_WB,RdAdress_MEM,RdAdress_WB,Rs_EX,Rt_EX);//!!!!!
endmodule