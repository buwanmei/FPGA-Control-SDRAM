// *********************************************************************************
// Project Name : OSXXXX
// Author       : ZhangXiaoHong
// Email        : 1208481840@qq.com
// Website      : http://www.opensoc.cn/
// Create Time  : 2018/7/30 10:19:19
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
// 2018/7/30    XioaHong          1.0                     Original
//  
// *********************************************************************************
`timescale      1ns/1ns
`define SIM
module uart_tx(
input                   s_clk                   ,   
input                   s_rst_n                 ,   

input [7:0]             tx_data                 ,   
input                   tx_trig                 ,   
output reg              rs232_tx                 
);

`ifndef SIM
localparam BAUD_END = 5207;
`else
localparam BAUD_END = 52;
`endif
localparam BIT_END  = 8;

reg [7:0] tx_data_r;
reg tx_flag;
reg [12:0] baud_cnt;
reg bit_flag;
reg [3:0] bit_cnt;

//------------------------------------------------------- 
//    tx_data_r
always  @(posedge s_clk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            tx_data_r <= 'd0;
        else if(tx_trig == 1'b1)
            tx_data_r <= tx_data;
        else ;
end

//------------------------------------------------------- 
//   tx_flag
always  @(posedge s_clk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            tx_flag <= 'd0;
        else if(bit_flag == 1'b1 && bit_cnt == BIT_END)
            tx_flag <= 'd0;
        else if(tx_trig == 1'b1)
            tx_flag <= 1'b1;
end


//------------------------------------------------------- 
//    baud_cnt
always  @(posedge s_clk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            baud_cnt <= 'd0;
        else if(baud_cnt == BAUD_END)
            baud_cnt <= 'd0;
        else if(tx_flag == 1'b1)
            baud_cnt <= baud_cnt + 1'b1;
        else 
            baud_cnt <= 'd0;
end


//------------------------------------------------------- 
//    bit_flag
always  @(posedge s_clk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            bit_flag <= 'd0;
        else if(baud_cnt == BAUD_END)
            bit_flag <= 1'b1;
        else
            bit_flag <= 'd0;
end


//------------------------------------------------------- 
//    bit_cnt
always  @(posedge s_clk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            bit_cnt <= 'd0;
        else if(bit_cnt == BIT_END)
            bit_cnt <= 'd0;
        else if(bit_flag == 1'b1 && tx_flag == 1'b1)
            bit_cnt <= bit_cnt + 1'b1;
        else ; 
end

//------------------------------------------------------- 
//    rs232_tx
always  @(posedge s_clk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
            rs232_tx <= 'd0;
        else if(tx_flag == 1'b1) begin
            case(bit_cnt)
                0: rs232_tx <= 'd0;
                1: rs232_tx <= tx_data_r[0];
                2: rs232_tx <= tx_data_r[1];
                3: rs232_tx <= tx_data_r[2];
                4: rs232_tx <= tx_data_r[3];
                5: rs232_tx <= tx_data_r[4];
                6: rs232_tx <= tx_data_r[5];
                7: rs232_tx <= tx_data_r[6];
                8: rs232_tx <= tx_data_r[7];
                default: rs232_tx <= 1'b1;
            endcase
        end
        else 
            rs232_tx <= 1'b1;
end






endmodule


