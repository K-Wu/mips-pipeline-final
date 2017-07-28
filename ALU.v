module ALU(ALUOut,in1,in2,ALUFun,Sign);
output [31:0] ALUOut;
input [31:0] in1;
input [31:0] in2;
input [5:0] ALUFun;
input Sign;
wire [31:0] cmp_out,shift_out,logic_out,addsub_out;
addsub adsb(.S(addsub_out),.Z(Z),.V(V),.N(N),.in1(in1),.in2(in2),.ALUFun(ALUFun[0]),.Sign(Sign));
cmp cp(.S(cmp_out),.V(V),.N(N),.ALUFun(ALUFun[3:1]),.in1(in1),.in2(in2),.Sign(Sign));
logic lgc(.out(logic_out),.in1(in1),.in2(in2),.ALUFun(ALUFun[3:0]));
shift sft(.out(shift_out),.in1(in1),.in2(in2),.ALUFun(ALUFun[1:0]));
assign ALUOut=ALUFun[5]?(ALUFun[4]?cmp_out:shift_out): //11,10
				(ALUFun[4]?logic_out:addsub_out);	//01,00




endmodule


module addsub(S,Z,V,N,in1,in2,ALUFun,Sign);
output [31:0] S;
output Z,V,N;

input [31:0] in1, in2;
input ALUFun,Sign;//ALUFun[0]
wire [31:0]s_add,s_sub;
wire z_add,v_add,n_add,   z_sub,v_sub,n_sub;
wire [31:0] inv_in2;
assign inv_in2 = ~in2+1;
assign s_add = in1+in2;
assign z_add = (s_add==0); 
assign n_add = Sign&s_add[31];
assign v_add = Sign&(s_add[31]^in1[31])&~(in1[31]^in2[31]);
assign s_sub = in1+inv_in2;
assign z_sub = (s_sub==0);
assign n_sub = Sign&s_sub[31];
assign v_sub = Sign&(s_sub[31]^in1[31])&~(in1[31]^inv_in2[31]);
assign S=ALUFun?s_sub:s_add;//1?sub
assign Z=ALUFun?z_sub:z_add;
assign N=ALUFun?n_sub:n_add;
assign V=ALUFun?v_sub:v_add;
endmodule


module cmp(S,V,N,ALUFun,in1,in2,Sign);
input V,N,Sign;
input [2:0] ALUFun;
input [31:0] in1,in2;
output [31:0] S;
//EQ001,NEQ000,LT010,LEZ110,LTZ101,GTZ111
wire EQ,NEQ,LT,LEZ,LTZ,GTZ;
assign EQ=in1==in2;
assign NEQ=~(in1==in2);
assign LT=(~V&N)|(V&in1[31]);
assign EQZ=(in1==0);
assign LEZ=Sign?(in1[31]||EQZ):EQZ;
assign LTZ=Sign?(in1[31]):0;
assign GTZ=Sign?(~in1[31]):~EQZ;

assign S=(ALUFun[2]==0)?
			(
			(ALUFun[1]==0)?
				((ALUFun[0]==0)?NEQ:EQ)//000,001
				:
				((ALUFun[0]==0)?LT:0)//010,011
			)
			:
			(
			(ALUFun[1]==0)?
				((ALUFun[0]==0)?0:LTZ)//100,101
				:
				((ALUFun[0]==0)?LEZ:GTZ)//110,111
			);
endmodule

module logic(out,in1,in2,ALUFun);
output [31:0] out;
input [31:0] in1,in2;
input [3:0] ALUFun;
wire [31:0] _and,_or,_xor,_nor;
assign _and=in1&in2;
assign _or=in1|in2;
assign _xor=in1^in2;
assign _nor=~(in1|in2);
assign out=(ALUFun[3]==1)?(
				(ALUFun[2]==1)?_or:(
					(ALUFun[1]==1)?in1:_and))
				:
					((ALUFun[2]==1)?_xor:_nor);
endmodule

module _arshift1(out,in);
input [31:0] in;
output [31:0] out;
wire temp;
assign temp=(in[31]==1)?1'b1:1'b0;
assign out={temp,in[31:1]};
endmodule

module _arshift2(out,in);
input [31:0] in;
output [31:0] out;
wire [1:0] temp;
assign temp=(in[31]==1)?2'b11:2'b00;
assign out={temp,in[31:2]};
endmodule

module _arshift4(out,in);
input [31:0] in;
output [31:0] out;
wire [3:0] temp;
assign temp=(in[31]==1)?4'b1111:4'b0000;
assign out={temp,in[31:4]};
endmodule

module _arshift8(out,in);
input [31:0] in;
output [31:0] out;
wire [7:0] temp;
assign temp=(in[31]==1)?8'hFF:8'h00;
assign out={temp,in[31:8]};
endmodule

module _arshift16(out,in);
input [31:0] in;
output [31:0] out;
wire [15:0] temp;
assign temp=(in[31]==1)?16'hFFFF:16'h0000;
assign out={temp,in[31:16]};
endmodule



module arshift(out,in,shamt);
output [31:0] out;
input [31:0] in;
input [4:0] shamt;
wire [31:0] _out1,_out2,_out4,_out8,_out16;
wire [31:0] _in1,_in2,_in4,_in8,_in16;
_arshift16 ar16(_out16,_in16);
_arshift8 ar8(_out8,_in8);
_arshift4 ar4(_out4,_in4);
_arshift2 ar2(_out2,_in2);
_arshift1 ar1(_out1,_in1);
assign _in16=in;
assign _in8=(shamt[4]==1)?_out16:in;
assign _in4=(shamt[3]==1)?_out8:(
				(shamt[4]==1)?_out16:in);
assign _in2=(shamt[2]==1)?_out4:(
				(shamt[3]==1)?_out8:((
					shamt[4]==1)?_out16:in));

assign _in1=(shamt[1]==1)?_out2:(
				(shamt[2]==1)?_out4:(
					(shamt[3]==1)?_out8:(
						(shamt[4]==1)?_out16:in)));
assign out=(shamt[0]==1)?_out1:(
				(shamt[1]==1)?_out2:(
					(shamt[2]==1)?_out4:(
						(shamt[3]==1)?_out8:(
							(shamt[4]==1)?_out16:in))));
endmodule


module rshift(out,in,shamt);
output [31:0] out;
input [31:0] in;
input [4:0] shamt;
wire [31:0] _out1,_out2,_out4,_out8,_out16;
wire [31:0] _in1,_in2,_in4,_in8,_in16;
_rshift16 r16(_out16,_in16);
_rshift8 r8(_out8,_in8);
_rshift4 r4(_out4,_in4);
_rshift2 r2(_out2,_in2);
_rshift1 r1(_out1,_in1);
assign _in16=in;
assign _in8=(shamt[4]==1)?_out16:in;
assign _in4=(shamt[3]==1)?_out8:(
				(shamt[4]==1)?_out16:in);
assign _in2=(shamt[2]==1)?_out4:(
				(shamt[3]==1)?_out8:(
					(shamt[4]==1)?_out16:in));

assign _in1=(shamt[1]==1)?_out2:(
				(shamt[2]==1)?_out4:(
					(shamt[3]==1)?_out8:(
						(shamt[4]==1)?_out16:in)));
assign out=(shamt[0]==1)?_out1:(
				(shamt[1]==1)?_out2:(
					(shamt[2]==1)?_out4:(
						(shamt[3]==1)?_out8:(
							(shamt[4]==1)?_out16:in))));
endmodule

module lshift(out,in,shamt);
output [31:0] out;
input [31:0] in;
input [4:0] shamt;
wire [31:0] _out1,_out2,_out4,_out8,_out16;
wire [31:0] _in1,_in2,_in4,_in8,_in16;
_lshift16 l16(_out16,_in16);
_lshift8 l8(_out8,_in8);
_lshift4 l4(_out4,_in4);
_lshift2 l2(_out2,_in2);
_lshift1 l1(_out1,_in1);
assign _in16=in;
assign _in8=(shamt[4]==1)?_out16:in;
assign _in4=(shamt[3]==1)?_out8:(
				(shamt[4]==1)?_out16:in);
assign _in2=(shamt[2]==1)?_out4:(
				(shamt[3]==1)?_out8:(
					(shamt[4]==1)?_out16:in));

assign _in1=(shamt[1]==1)?_out2:(
				(shamt[2]==1)?_out4:(
					(shamt[3]==1)?_out8:(
						(shamt[4]==1)?_out16:in)));
assign out=(shamt[0]==1)?_out1:(
				(shamt[1]==1)?_out2:(
					(shamt[2]==1)?_out4:(
						(shamt[3]==1)?_out8:(
							(shamt[4]==1)?_out16:in))));
endmodule

module shift(out,in1,in2,ALUFun);
output [31:0] out;
input [31:0] in1,in2;
input [1:0] ALUFun;
wire [31:0] _arout,_rout,_lout;
arshift ar(.out(_arout),.in(in2),.shamt(in1[4:0]));
rshift r(.out(_rout),.in(in2),.shamt(in1[4:0]));
lshift l(.out(_lout),.in(in2),.shamt(in1[4:0]));
assign out=(ALUFun[1]==1)?_arout:(
				(ALUFun[0]==1)?_rout:_lout);

endmodule

module _rshift1(out,in);
input [31:0] in;
output [31:0] out;
assign out={1'b0,in[31:1]};
endmodule

module _rshift2(out,in);
input [31:0] in;
output [31:0] out;
assign out={2'b0,in[31:2]};
endmodule

module _rshift4(out,in);
input [31:0] in;
output [31:0] out;
assign out={4'b0,in[31:4]};
endmodule


module _rshift8(out,in);
input [31:0] in;
output [31:0] out;
assign out={8'b0,in[31:8]};
endmodule

module _rshift16(out,in);
input [31:0] in;
output [31:0] out;
assign out={16'b0,in[31:16]};
endmodule

module _lshift1(out,in);
input [31:0] in;
output [31:0] out;
assign out={in[30:0],1'b0};
endmodule

module _lshift2(out,in);
input [31:0] in;
output [31:0] out;
assign out={in[29:0],2'b0};
endmodule

module _lshift4(out,in);
input [31:0] in;
output [31:0] out;
assign out={in[27:0],4'b0};
endmodule


module _lshift8(out,in);
input [31:0] in;
output [31:0] out;
assign out={in[23:0],8'b0};
endmodule

module _lshift16(out,in);
input [31:0] in;
output [31:0] out;
assign out={in[15:0],16'b0};
endmodule


