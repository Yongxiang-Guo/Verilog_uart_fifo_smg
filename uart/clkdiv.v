`timescale 1ns / 1ps
//////////////////////////////////////
//Module Name:	clkdiv
//说明：串口波特率为9600，采样时钟为154.6KHz（16倍频）
//////////////////////////////////////
module clkdiv
	(
		input clk50, 		//系统时钟
		input rst_n,      //收入复位信号
		output reg clkout //采样时钟输出
	);

reg [15:0] cnt;

//分频进程, 50Mhz的时钟326分频,得到波特率9600的16倍频
always @(posedge clk50 or negedge rst_n)   
begin
  if (!rst_n) begin
     clkout <=1'b0;
	  cnt<=0;
  end	  
  else if(cnt == 16'd162) begin
    clkout <= 1'b1;
    cnt <= cnt + 16'd1;
  end
  else if(cnt == 16'd325) begin
    clkout <= 1'b0;
    cnt <= 16'd0;
  end
  else begin
    cnt <= cnt + 16'd1;
  end
end
endmodule
