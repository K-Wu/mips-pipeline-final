module branch_compare(bcompare_out,ALUin1,ALUin2,ALUFunct_41);
output bcompare_out;
input [31:0] ALUin1,ALUin2;
input [3:0] ALUFunct_41;//ALUFunct[4:1]

assign bcompare_out=(ALUFunct_41==4'b1001)?ALUin1==ALUin2://beq
						(ALUFunct_41==4'b1000)?ALUin1!=ALUin2://bne
							(ALUFunct_41==4'b1110)?(ALUin1[31]==1||ALUin1[30:0]==0)://blez
								(ALUFunct_41==4'b1111)?(ALUin1[31]!=0&&ALUin1[30:0]>0)://bgtz
									ALUin1[31]==1;

endmodule