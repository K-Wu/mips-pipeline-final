module ID_EX_Register (clk, Flush, PCSrc_in, RegDst_in, RegWr_in, ALUSrc1_in, ALUSrc2_in,
ALUFun_in, Sign_in, MemWr_in, MemRd_in, MemToReg_in, 
PC4_in, R1_in, R2_in, Imm_in, RdAdress_in, Shamt_in,Instruction_in,Flushed_in,
PCSrc_out, RegDst_out, RegWr_out, ALUSrc1_out, ALUSrc2_out,
ALUFun_out, Sign_out, MemWr_out, MemRd_out, MemToReg_out, 
PC4_out, R1_out, R2_out, Imm_out, RdAdress_out, Shamt_out,Instruction_out,reset,Flushed_out);

input clk,Flush;
input reset,Flushed_in;
input [2:0] PCSrc_in;
input [1:0] RegDst_in; 
input RegWr_in, ALUSrc1_in, ALUSrc2_in, Sign_in, MemWr_in,MemRd_in;
input [5:0] ALUFun_in;
input [1:0] MemToReg_in;
input [31:0] PC4_in, R1_in, R2_in, Imm_in,Instruction_in;
input [4:0] RdAdress_in,Shamt_in;


output [2:0] PCSrc_out;
output [1:0] RegDst_out; 
output RegWr_out, ALUSrc1_out, ALUSrc2_out, Sign_out, MemWr_out,MemRd_out,Flushed_out;
output [5:0] ALUFun_out;
output [1:0] MemToReg_out;

output [31:0] PC4_out, R1_out, R2_out, Imm_out,Instruction_out;
output [4:0] RdAdress_out,Shamt_out;

reg [2:0] PCSrc_reg;
reg [1:0] RegDst_reg; 
reg RegWr_reg, ALUSrc1_reg, ALUSrc2_reg, Sign_reg, MemWr_reg,MemRd_reg,Flushed_reg;
reg [5:0] ALUFun_reg;
reg [1:0] MemToReg_reg;

reg [31:0] PC4_reg, R1_reg, R2_reg, Imm_reg,Instruction_reg;
reg [4:0] RdAdress_reg, Shamt_reg;

always @(posedge clk or negedge reset) begin
	if (~reset)
	begin
		PCSrc_reg = 0;
		RegDst_reg = 0; 
		RegWr_reg = 0; 
		ALUSrc1_reg = 0; 
		ALUSrc2_reg = 0;
		ALUFun_reg = 0; 
		Sign_reg = 0; 
		MemWr_reg = 0; 
		MemRd_reg = 0; 
		MemToReg_reg = 0; 
		PC4_reg = 32'h80000004;
		R1_reg = 0; 
		R2_reg = 0; 
		Imm_reg = 0; 
		RdAdress_reg = 0;
		Shamt_reg = 0;
		Instruction_reg = 0;
		Flushed_reg = 0;
	end
	else begin 
	if(Flush) begin
		PCSrc_reg = 0; 
		RegWr_reg = 0; 
		MemWr_reg = 0; 
		MemRd_reg = 0; 

		PC4_reg = PC4_in;
		Flushed_reg = 1;
		
	end
	else begin
		PCSrc_reg = PCSrc_in;
		RegWr_reg = RegWr_in; 
		MemWr_reg = MemWr_in; 
		MemRd_reg = MemRd_in;  
		PC4_reg = PC4_in;
		Flushed_reg = Flushed_in;
	end

		RegDst_reg = RegDst_in; 
		ALUSrc1_reg = ALUSrc1_in; 
		ALUSrc2_reg = ALUSrc2_in;
		ALUFun_reg = ALUFun_in; 
		Sign_reg = Sign_in; 
		MemToReg_reg = MemToReg_in; 
		R1_reg = R1_in; 
		R2_reg = R2_in; 
		Imm_reg = Imm_in; 
		RdAdress_reg = RdAdress_in;
		Shamt_reg = Shamt_in;
		Instruction_reg = Instruction_in;
	end
end

assign PCSrc_out = PCSrc_reg;
assign RegDst_out = RegDst_reg; 
assign RegWr_out = RegWr_reg; 
assign ALUSrc1_out = ALUSrc1_reg; 
assign ALUSrc2_out = ALUSrc2_reg;
assign ALUFun_out = ALUFun_reg; 
assign Sign_out = Sign_reg; 
assign MemWr_out = MemWr_reg; 
assign MemRd_out = MemRd_reg; 
assign MemToReg_out = MemToReg_reg; 
assign PC4_out = PC4_reg;
assign R1_out = R1_reg; 
assign R2_out = R2_reg; 
assign Imm_out = Imm_reg; 
assign RdAdress_out = RdAdress_reg;
assign Shamt_out = Shamt_reg;
assign Instruction_out = Instruction_reg;
assign Flushed_out = Flushed_reg;
endmodule