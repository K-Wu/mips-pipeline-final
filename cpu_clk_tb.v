module cpu_clk_tb;
reg sysclk;
cpuclk U_cpuclk(clk,sysclk);
initial fork
sysclk<=0;
forever #2 sysclk<=~sysclk;
join
endmodule
