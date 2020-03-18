`timescale 1ns/1ps
/////////////////////////////////
//module name: key_input
/////////////////////////////////

module key_input
	(
		input clk_50MHz,
		input clk_uart,
		input[3:0] key,
		output reg uart_wrsig,
		output reg[7:0] uart_datain
	);

parameter num1 = 8'd49;
parameter num2 = 8'd50;
parameter num3 = 8'd51;
parameter num4 = 8'd52;
parameter rst1 = 1'b1;

reg[19:0] cnt;
reg[3:0] key_scan;
reg[3:0] key_scan_buf;
reg[3:0] key_down;

	
//每20ms扫描一次键值
always @(posedge clk_50MHz)
begin
	if(cnt == 20'd999999)begin	//50Hz,即20ms检测按键一次，去除高频抖动影响
		cnt <= 20'd0;
		key_scan <= key;
	end
	else begin
		cnt <= cnt + 20'd1;
	end
end

//检测按键按下
always @(posedge clk_uart)
begin
	key_scan_buf <= key_scan;
	key_down <= key_scan_buf & (~key_scan);
end

//按键按下处理程序
always @(posedge clk_uart)
begin
	case(key_down)
		4'b0001:begin	//KEY1
			uart_datain <= num1;
			uart_wrsig <= 1'b1;
		end
		4'b0010:begin	//KEY2
			uart_datain <= num2;
			uart_wrsig <= 1'b1;
		end
		4'b0100:begin	//KEY3
			uart_datain <= num3;
			uart_wrsig <= 1'b1;
		end
		4'b1000:begin	//KEY4
			uart_datain <= num4;
			uart_wrsig <= 1'b1;
		end
		default:begin
			uart_wrsig <= 1'b0;
		end
	endcase
end

endmodule

