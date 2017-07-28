module cpuclk(clk,sysclk,reset);
output reg clk;
input sysclk,reset;
reg [6:0] s;
initial begin 
s<=0;
clk<=0;
end
always @(posedge sysclk or negedge reset)
begin
	if (~reset)
	begin
		s<=0;
		clk<=0;
	end
	else begin
		s<=s+1;
		if(s==50)
		begin
			s<=0;
			clk<=~clk;
		end
	end
end


endmodule