module Uart(sysclk,clk,reset,uart_tx,uart_rx,rd,wr,addr,wdata,rdata,rx_irq,tx_irq);

input [31:0] addr;
input [31:0] wdata;
output [31:0] rdata;
reg [31:0] rdata;
input rd,wr,reset,uart_rx,sysclk,clk;
output uart_tx,rx_irq,tx_irq;

wire rx_status,tx_status,tx_en,baudrate_clk;
wire [7:0] tx_data;
wire [7:0] rx_data;
reg en;
reg [7:0] data;
reg [7:0] rx_tmp;
reg [7:0] tx_tmp;
// reg rx_ready;
reg tx_ready;
reg [4:0] uart_con;
reg con2,con3;

assign tx_data = data;
assign tx_en = en;
assign tx_irq = uart_con[0]&uart_con[2];
assign rx_irq = uart_con[1]&uart_con[3];

Generator G(sysclk,baudrate_clk);
Receiver R(baudrate_clk,uart_rx,rx_data,rx_status);
Sender S(tx_data,tx_en,baudrate_clk,uart_tx,tx_status);

always@(*) begin
	uart_con[4] <= ~tx_status;
	if(rd) begin
		case(addr)
			32'h40000018: rdata <= {24'b0,tx_tmp};
			32'h4000001C: rdata <= {24'b0,rx_tmp};
			32'h40000020: rdata <= {27'b0,uart_con};
			default: rdata <= 32'b0;
		endcase
	end
	else
		rdata <= 32'b0;
end

always@(negedge reset or posedge clk) begin
	if(~reset) begin
		con3 <= 0;
		con2 <= 0;
		uart_con[3:2] <= 2'b00;
		uart_con[1:0] <= 2'b11;
		tx_tmp <= 8'b0;
		tx_ready <= 0;
		data <= 0;
		rx_tmp <= 8'b0;
		// rx_ready <= 0; 
	end
	else begin
		if(wr) begin
			case(addr)
				32'h40000018: begin tx_tmp <= wdata[7:0]; tx_ready <= 1; end
				32'h40000020: uart_con[1:0] <= wdata[1:0];//wk710upd:中断状态不给写
				default: ;
			endcase
		end
		if (rd & (addr == 32'h40000020)) begin
			if (uart_con[1])
				uart_con[3] <= 0;
			if (uart_con[0])
				uart_con[2] <= 0;//使能读时才清零中断
		end
		if (tx_status & ~con2) begin
			con2 <= 1;
			uart_con[2] <= 1;		
		end
		if (con2 & ~tx_status) begin
			con2 <= 0;
		end
		if (rx_status & ~con3) begin
			con3 <= 1;
			uart_con[3] <= 1;
			rx_tmp <= rx_data;
			// rx_ready <= 1; 		
		end
		if (con3 & ~rx_status) begin
			con3 <= 0;
		end
		if(tx_status & tx_ready) begin
			tx_ready <= 0;
			data <= tx_tmp;
		end
	end
end

always @(negedge reset or posedge baudrate_clk or posedge tx_ready) begin
	if (~reset) begin
		en <= 0;
	end
	else begin
        if (en) begin
            en <= 0;
        end
		if (tx_status & tx_ready) begin
			en <= 1;
		end
	end
end

endmodule