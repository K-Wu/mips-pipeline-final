module tb_ALU;
reg [5:0] ALUFun;
wire [31:0] S;
wire a;
wire [3:0] cmp_out,shift_out,logic_out,addsub_out;
wire [3:0] ALUOut;

assign a=0;
assign cmp_out=111;
assign shift_out=101;
assign logic_out=011;
assign add_sub_out=010;
assign S=(a==0);


assign ALUOut=ALUFun[5]?(ALUFun[4]?cmp_out:shift_out): //11,10
				(ALUFun[4]?logic_out:addsub_out);		//01,00
initial begin
ALUFun<=0;
#20 ALUFun[5:4]<=01;
#20 ALUFun[5:4]<=11;
#20 ALUFun[5:4]<=10;
#20 ALUFun[5:4]<=00;

end


endmodule
