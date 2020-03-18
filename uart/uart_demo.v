`timescale 1ns/1ps
////////////////////////////////
//module name:uart_demo
//说明：	串口波特率为9600
//			接收数据，rx下降沿开始读取，rdsig上升沿表示数据包读取完成
//			发送数据，检测到wrsig上升沿，开始发送数据
////////////////////////////////

module uart_demo
	(
		input clk_50MHz,
		input rst,
		input rx,
		input[7:0] datain,
		input wrsig,
		
		output clk_uart,
		output tx,
		output rdsig,
		output[7:0] dataout
	);
	

//clkdiv
clkdiv clkdiv_inst
	(
		.clk50(clk_50MHz),
		.rst_n(rst),
		.clkout(clk_uart)
	);

//uart rx
uartrx uartrx_inst
	(
		.clk(clk_uart),
		.rst_n(rst),
		.rx(rx),
		.dataout(dataout), 
		.rdsig(rdsig)
	);

//uart tx	
uarttx uarttx_inst
	(
		.clk(clk_uart), 
		.rst_n(rst), 
		.datain(datain), 
		.wrsig(wrsig),
		.tx(tx)
	);
	
endmodule
	