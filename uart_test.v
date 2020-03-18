`timescale 1ns / 1ps
//////////////////////////////////
// Module Name:    uart_test 
//////////////////////////////////
module uart_test
	(
		input clk_50MHz,
		input rst,
		input rx,
		input[3:0] key,
		
		output tx,
		output[5:0] smg_sig,
		output[7:0] smg_data
	);
	
wire wrsig;	//串口发送命令，上升沿有效
wire rdsig;	//数据读取完成标志，上升沿有效
wire[7:0] datain;	//串口发送数据
wire[7:0] dataout;//串口接收数据
reg rdsig_buf;
reg rdsig_rise;	//检测到串口数据读取完成，1有效
wire clk_uart;

wire empty;	//fifo为空，1有效
wire rdsig_nextdata;	//fifo读取信号
reg fifo_rd;
wire[7:0] data_display;


//检测数据读取完成标志rdsig的上升沿,得到fifo写入控制信号
always @(posedge clk_50MHz)
begin
   rdsig_buf <= rdsig;
   rdsig_rise <= (~rdsig_buf) & rdsig;
end

//fifo读取控制信号
always @(posedge clk_50MHz)
begin
	if(!empty)begin
		fifo_rd <= rdsig_nextdata;
	end
	else begin
		fifo_rd <= 1'b0;
	end
end

//uart part
uart_demo uart_demo_inst
	(
		.clk_50MHz(clk_50MHz),
		.rst(rst),
		.rx(rx),
		.datain(datain),
		.wrsig(wrsig),
		.clk_uart(clk_uart),
		.tx(tx),
		.rdsig(rdsig),
		.dataout(dataout)
	);


//fifo part
fifo fifo_inst
	(
		.clk(clk_50MHz),
		.fifo_wr(rdsig_rise),
		.fifo_rd(fifo_rd),	
		.in_data(dataout),
		.empty(empty),
		.out_data(data_display)
	);
	
	
//smg display part	
smg_demo smg_demo_inst
	(
		.clk_50MHz(clk_50MHz),
		.rst(rst),
		.data(data_display),
		.smg_sig(smg_sig),
		.smg_data(smg_data),
		.rdsig_nextdata(rdsig_nextdata)
	);

//key input part
key_input key_input_inst
	(
		.clk_50MHz(clk_50MHz),
		.clk_uart(clk_uart),
		.key(key),
		.uart_wrsig(wrsig),
		.uart_datain(datain)
	);

endmodule
	
	