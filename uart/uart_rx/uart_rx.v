// *********************************************************************************
// Project Name : OSXXXX
// Author       : ZhangXiaoHong
// Email        : 1208481840@qq.com
// Website      : http://www.opensoc.cn/
// Create Time  : 2018/7/29 16:47:59
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
// 2018/7/29    XioaHong          1.0                     Original
//  
// *********************************************************************************
`timescale      1ns/1ns
`define SIM
module uart_rx(
input                   s_clk                   ,   
input                   s_rst_n                 ,   

input                   uart_rx                 ,   

output reg [7:0]        rx_data                 ,   
output reg              po_flag
);

`ifndef  SIM
localparam BAUD_END = 5207;
`else
localparam BAUD_END = 56;
`endif
localparam BAUD_END_H = BAUD_END/2 - 1;
localparam BIT_END = 8;

reg rs232_rx1 ;
reg rs232_rx2 ;
reg rs232_rx3 ;
wire rs232_neg;

reg rx_flag;
reg [12:0] baud_cnt;
reg bit_flag;
reg [3:0] bit_cnt;

//------------------------------------------------------- 
//    rx
always @(posedge s_clk) begin
            rs232_rx1 <= uart_rx;
            rs232_rx2 <= rs232_rx1;
            rs232_rx3 <= rs232_rx2;
end

assign rs232_neg = ~rs232_rx2 & rs232_rx3;

//------------------------------------------------------- 
//    rx_flag
always  @(posedge s_clk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            rx_flag <= 'd0;
        else if(bit_cnt == 'd0 && baud_cnt == BAUD_END)
            rx_flag <= 'd0;
        else if(rs232_neg == 1'b1)
            rx_flag <= 1'b1;
end

//------------------------------------------------------- 
//    baud_cnt
always  @(posedge s_clk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            baud_cnt <= 'd0;
        else if(baud_cnt == BAUD_END)
            baud_cnt <= 'd0;
        else if(rx_flag == 1'b1)
            baud_cnt <= baud_cnt + 1'b1;
        else 
            baud_cnt <= 'd0;
end

//------------------------------------------------------- 
//    bit_flag
always  @(posedge s_clk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            bit_flag <= 'd0;
        else if(baud_cnt == BAUD_END_H)
            bit_flag <= 1'b1;
        else 
            bit_flag <= 'd0;
end

//------------------------------------------------------- 
//    bit_cnt
always  @(posedge s_clk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            bit_cnt <= 'd0;
        else if(bit_flag == 1'b1 && bit_cnt == BIT_END)
            bit_cnt <= 'd0;
        else if(bit_flag == 1'b1)
            bit_cnt <= bit_cnt + 1'b1;
end


//------------------------------------------------------- 
//    rx-data
always  @(posedge s_clk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            rx_data <= 'd0;
        else if(bit_flag == 1'b1 && bit_cnt >= 'd1)
            rx_data <= {rs232_rx2, rx_data[7:1]};
end

//------------------------------------------------------- 
//    po_flag
always  @(posedge s_clk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            po_flag <= 'd0;
        else if(bit_cnt == BIT_END && bit_flag == 1'b1)
            po_flag <= 1'b1;
        else 
            po_flag <= 'd0;
end


endmodule




