module test_arith;
wire [3:0] a;
wire [4:0] b;
wire g_a,g_b,g_e;
wire [30:0] e;
assign a=4'b1111;
assign b=4'b11111;
assign e=31'b1111111111111111111111111111111;
assign g_a=a>0;
assign g_b=b>0;
assign g_e=e>0;


endmodule
