module MEM_WB_Register (clk, RegWr_in,
MemToReg_in, PC4_in,
Data_in, ALUResult_in, RdAdress_in,
RegWr_out, MemToReg_out, PC4_out,
Data_out, ALUResult_out, RdAdress_out,
peri_rddata, uart_data, peri_rddata_WB, uart_data_WB, reset);

input clk, reset;


input RegWr_in;
input [1:0] MemToReg_in;

input [31:0] PC4_in, Data_in, ALUResult_in, peri_rddata, uart_data;
input [4:0] RdAdress_in;



output RegWr_out;
output [1:0] MemToReg_out;

output [31:0] PC4_out, Data_out, ALUResult_out, peri_rddata_WB, uart_data_WB;
output [4:0] RdAdress_out;


reg RegWr_reg;
reg [1:0] MemToReg_reg;

reg [31:0] PC4_reg, Data_reg, ALUResult_reg, peri_rddata_reg, uart_data_reg;
reg [4:0] RdAdress_reg;

always @(posedge clk or negedge reset) begin
	if(~reset) begin
		RegWr_reg = 0; 
		MemToReg_reg = 0; 
		Data_reg = 0; 
		ALUResult_reg = 0; 
		RdAdress_reg = 0;
		peri_rddata_reg = 0;
		uart_data_reg = 0;
		PC4_reg = PC4_in;
	end
	else begin
		RegWr_reg = RegWr_in; 
		MemToReg_reg = MemToReg_in; 
		Data_reg = Data_in; 
		ALUResult_reg = ALUResult_in; 
		RdAdress_reg = RdAdress_in;
		peri_rddata_reg = peri_rddata;
		uart_data_reg = uart_data;
		PC4_reg = PC4_in;
	end
	
end

assign RegWr_out = RegWr_reg; 
assign MemToReg_out = MemToReg_reg; 
assign Data_out = Data_reg; 
assign ALUResult_out = ALUResult_reg; 
assign RdAdress_out = RdAdress_reg;
assign peri_rddata_WB = peri_rddata_reg;
assign uart_data_WB = uart_data_reg;
assign PC4_out = PC4_reg;
endmodule