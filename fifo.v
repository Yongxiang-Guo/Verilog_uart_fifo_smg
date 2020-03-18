`timescale 1ns / 1ps
//////////////////////////////////
// Module Name:    fifo
//////////////////////////////////
module fifo
	(
		input clk,
		input fifo_wr, fifo_rd,	//FIFO读写命令：1有效
		input[7:0] in_data,
		output reg empty, full,			//FIFO空、满：1有效
		output reg[7:0] out_data
	);

(*ramstyle = " no_rw_check, m4k", ram_init_file = "rtl/init_sram.mif"*)	//属性
reg [7:0] sram[1023:0];	//SRAM大小为1024，位宽16bit

reg[9:0] wr_addr, rd_addr = 10'd0;
reg[10:0] data_num = 11'd0;	//数据个数

//写数据
always@(posedge clk)begin
	if(data_num != 11'd1024)begin
		if(fifo_wr)begin
			sram[wr_addr] <= in_data;
			if(wr_addr == 10'd1023)begin
				wr_addr <= 10'd0;
			end
			else begin
				wr_addr <= wr_addr + 10'd1;
			end
		end
	end
end

//读数据
always@(posedge clk)begin
	if(data_num != 11'd0)begin
		if(fifo_rd)begin
			out_data <= sram[rd_addr];
			if(rd_addr == 10'd1023)begin
				rd_addr <= 10'd0;
			end
			else begin
				rd_addr <= rd_addr + 10'd1;
			end
		end
	end 
end

//计数
always@(posedge clk)begin	
	if((!fifo_wr) && fifo_rd)begin
		if(data_num != 11'd0)begin
			data_num <= data_num - 11'd1;
		end
	end
	else if((!fifo_rd) && fifo_wr)begin
		if(data_num != 11'd1024)begin
			data_num <= data_num + 11'd1;
		end
	end
end

//控制empty
always@(posedge clk)begin
	if(data_num == 11'd0)begin
		if((!fifo_rd) && fifo_wr)begin
			empty <= 1'b0;
		end
		else begin
			empty <= 1'b1;
		end
	end
	else if(data_num == 11'd1)begin
		if((!fifo_wr) && fifo_rd)begin
			empty <= 1'b1;
		end
		else begin
			empty <= 1'b0;
		end
	end
	else begin
		empty <= 1'b0;
	end
end

//控制full
always@(posedge clk)begin
	if(data_num == 11'd1024)begin
		if((!fifo_wr) && fifo_rd)begin
			full <= 1'b0;
		end
		else begin
			full <= 1'b1;
		end
	end
	else if(data_num == 11'd1023)begin
		if((!fifo_rd) && fifo_wr)begin
			full <= 1'b1;
		end
		else begin
			full <= 1'b0;
		end
	end
	else begin
		full <= 1'b0;
	end
end

endmodule

