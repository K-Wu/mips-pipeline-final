module IF_ID_Register(clk, Flush, Instruction_in, PC4_in, Instruction_out, PC4_out,reset, IRQ, PC31, Flushed_out);
input [31:0] Instruction_in, PC4_in;
input Flush, clk;
input reset;
input IRQ, PC31;
output Flushed_out;
output [31:0] Instruction_out, PC4_out;
reg [31:0] Instruction_reg, PC4_reg;
reg Flushed_reg;
always @(posedge clk or negedge reset) begin
	if (~reset) begin
		Instruction_reg = 0;
		PC4_reg = 32'h80000004;
		Flushed_reg = 0;
	end
	else begin 
	PC4_reg[30:0] = PC4_in[30:0];
	PC4_reg[31] = PC31?PC4_in[31]:IRQ?1:PC4_in[31];
		if(Flush) begin
		Instruction_reg = 0;
		Flushed_reg = 1;
		end
		else begin
		Instruction_reg = Instruction_in;
		Flushed_reg = 0;
		end
	end
end
assign Instruction_out = Instruction_reg;
assign PC4_out = PC4_reg;
assign Flushed_out = Flushed_reg;
endmodule