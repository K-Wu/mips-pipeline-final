module forward(ForwardA,ForwardB,EX_MEM_RegWr,MEM_WB_RegWr,EX_MEM_Rd,MEM_WB_Rd,ID_EX_Rs,ID_EX_Rt);
input EX_MEM_RegWr,MEM_WB_RegWr;
input [4:0] EX_MEM_Rd, ID_EX_Rs,ID_EX_Rt,MEM_WB_Rd;
output [1:0] ForwardA,ForwardB;

//always @(*)//TODO:???EX????EX/MEM(????)???
// begin
// 	if (EX_MEM_RegWr&&(EX_MEM_Rd!=0)&&(EX_MEM_Rd==ID_EX_Rs))//EX??
// 		ForwardA <= 2'b10;
// 	else if(MEM_WB_RegWr&&(MEM_WB_Rd!=0)&&(MEM_WB_Rd==ID_EX_Rs))
// 		ForwardA<=2'b01;
// 	else
// 		ForwardA<=2'b00;
// end

assign ForwardA = (EX_MEM_RegWr&&EX_MEM_Rd!=0&&EX_MEM_Rd==ID_EX_Rs)?2'b10:
					(MEM_WB_RegWr&&MEM_WB_Rd!=0&&MEM_WB_Rd==ID_EX_Rs)?2'b01:
						2'b00;

assign ForwardB = (EX_MEM_RegWr&&EX_MEM_Rd!=0&&EX_MEM_Rd==ID_EX_Rt)?2'b10:
					(MEM_WB_RegWr&&MEM_WB_Rd!=0&&MEM_WB_Rd==ID_EX_Rt)?2'b01:
						2'b00;


// always @(*)
// begin
// 	if (EX_MEM_RegWr&&(EX_MEM_Rd!=0)&&(EX_MEM_Rd==ID_EX_Rt)) //EX??
// 		ForwardB<=2'b10;	
// 	else if (MEM_WB_RegWr&&(MEM_WB_Rd!=0)&&(MEM_WB_Rd==ID_EX_Rt))
// 		ForwardB<=2'b01;
// 	else 
// 		ForwardB<=2'b00;

// end

endmodule