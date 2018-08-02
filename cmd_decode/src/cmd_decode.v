// *********************************************************************************
// Project Name : OSXXXX
// Author       : ZhangXiaoHong
// Email        : 1208481840@qq.com
// Website      : http://www.opensoc.cn/
// Create Time  : 2018/8/1 14:42:04
// File Name    : .v
// Module Name  : 
// Called By    :
// Abstract     :
//
// CopyRight(c) 2016, OpenSoc Studio.. 
// All Rights Reserved
//
// *********************************************************************************
// Modification History:
// Date         By              Version                 Change Description
// -----------------------------------------------------------------------
// 2018/8/1    XioaHong          1.0                     Original
//  
// *********************************************************************************
`timescale      1ns/1ns


module cmd_decode(
input                   s_clk                   ,   
input                   s_rst_n                 ,   

input                   uart_flag		,
input [7:0]             uart_data               ,   
output reg              wr_trig                 ,   
output reg              rd_trig                 ,   
output reg              wfifo_wr_en             ,
output wire [7:0]       wfifo_data
);

reg [7:0] cmd_reg;
reg [2:0] rec_num;


//------------------------------------------------------- 
//    rec_num
always  @(posedge s_clk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            rec_num <= 'd0;
        else if(uart_flag == 1'b1 && rec_num == 'd0 && uart_data == 8'haa)//这条就是把uart_data为aa的num清0
            rec_num <= 'd0;
        else if(rec_num == 'd4 && uart_flag == 1'b1)
            rec_num <= 'd0;
        else if(uart_flag == 1'b1)
            rec_num <= rec_num + 1'b1;
        else ;
end

//------------------------------------------------------- 
//    cmd_reg

always  @(posedge s_clk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            cmd_reg <= 'd0;
        else if(uart_data == 8'h55 && uart_flag == 1'b1)
            cmd_reg <= 8'h55;
        else if(uart_data == 8'haa && uart_flag == 1'b1)
            cmd_reg <= 8'haa;
        else ;
end

//上面用的现在是我的代码，下面的是开源骚客的代码
//------------------------------------------------------- 
//    cmd_reg
/*
always  @(posedge s_clk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            cmd_reg <= 'd0;
        else if(rec_num == 'd0 && uart_flag == 1'b1)
            cmd_reg <= uart_data;
        
end
*/


//------------------------------------------------------- 
//    wr_trig 
always  @(posedge s_clk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            wr_trig <= 'd0;
        else if(rec_num == 'd4)
            wr_trig <= 'd1;
        else 
            wr_trig <= 'd0;
end

//------------------------------------------------------- 
//    rd_trig
always  @(posedge s_clk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            rd_trig <= 'd0;
        else if(uart_flag  == 1'b1 && uart_data == 8'haa)
            rd_trig <= 'd1;
        else
            rd_trig <= 'd0;
end

//------------------------------------------------------- 
//    wfifo_wr_en
always  @(posedge s_clk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            wfifo_wr_en <= 'd0;
        else if(cmd_reg == 8'h55 && uart_flag == 1'b1)
            wfifo_wr_en <= 1'b1;
        else 
            wfifo_wr_en <= 'd0;
end



assign wfifo_data = uart_data;


endmodule




