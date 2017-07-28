module EX_MEM_Register (clk, FORWARD, PCSrc_in, RegWr_in,
MemWr_in, MemRd_in, MemToReg_in, 
NewPC_in, PC4_in , ALUResult_in, RegToMemData_in, RdAdress_in,
PCadd4, PC4_ID, Flushed_out_ID, Flushed_out_EX,
PCSrc_out, RegWr_out, MemWr_out, MemRd_out, MemToReg_out, 
NewPC_out, PC4_out ,ALUResult_out, RegToMemData_out, RdAdress_out, reset,PCSrc_ID);

input clk,reset;
input [2:0] PCSrc_ID;
input FORWARD,Flushed_out_ID, Flushed_out_EX;
input [2:0] PCSrc_in;

input RegWr_in, MemWr_in,MemRd_in;
input [1:0] MemToReg_in;

input [31:0] NewPC_in, ALUResult_in, RegToMemData_in, PC4_in ;
input [4:0] RdAdress_in;

output [2:0] PCSrc_out;

output RegWr_out, MemWr_out,MemRd_out;
output [1:0] MemToReg_out;
input [31:0] PCadd4, PC4_ID; //wk10upd TODO: are these input?
output [31:0] NewPC_out, ALUResult_out, RegToMemData_out, PC4_out;
output [4:0] RdAdress_out;

reg [2:0] PCSrc_reg;
reg RegWr_reg, MemWr_reg,MemRd_reg;
reg [1:0] MemToReg_reg;

reg [31:0] NewPC_reg, ALUResult_reg, RegToMemData_reg, PC4_reg;
reg [4:0] RdAdress_reg;

always @(posedge clk or negedge reset) begin
	if(~reset) begin
		PCSrc_reg = 0;
		RegWr_reg = 0; 
		MemWr_reg = 0; 
		MemRd_reg = 0; 
		MemToReg_reg = 0; 
		NewPC_reg = 32'h80000004;//TODO 
		PC4_reg = 32'h80000004;
		ALUResult_reg = 0; 
		RegToMemData_reg = 0; 
		RdAdress_reg = 0;
	end
	else begin 
	if (FORWARD) begin
		
		RegWr_reg = 1; 
		MemWr_reg = 0; 
		MemRd_reg = 0; 
		MemToReg_reg = 2; 
		
		PC4_reg = (PC4_in[31]||Flushed_out_EX)?((PC4_ID[31]||Flushed_out_ID)?PCadd4:PC4_ID):PC4_in;//wk10upd TODO: what's the meaning?
		RdAdress_reg = 26;//Xp
	end
	else begin

		RegWr_reg = RegWr_in; 
		MemWr_reg = MemWr_in; 
		MemRd_reg = MemRd_in; 
		MemToReg_reg = MemToReg_in; 
		PC4_reg = PC4_in;

		RdAdress_reg = RdAdress_in;
	end
	PCSrc_reg = PCSrc_ID;
	NewPC_reg = NewPC_in;//TODO 
	ALUResult_reg = ALUResult_in; 
    RegToMemData_reg = RegToMemData_in; 
	end
end

assign PCSrc_out = PCSrc_reg;
assign RegWr_out = RegWr_reg; 
assign MemWr_out = MemWr_reg; 
assign MemRd_out = MemRd_reg; 
assign MemToReg_out = MemToReg_reg; 
assign NewPC_out = NewPC_reg; 
assign PC4_out = PC4_reg;
assign ALUResult_out = ALUResult_reg; 
assign RegToMemData_out = RegToMemData_reg; 
assign RdAdress_out = RdAdress_reg;
endmodule