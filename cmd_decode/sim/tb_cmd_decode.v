// *********************************************************************************
// Project Name : OSXXXX
// Author       : ZhangXiaoHong
// Email        : 1208481840@qq.com
// Website      : http://www.opensoc.cn/
// Create Time  : 2018/8/1 15:31:18
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

module tb_cmd_decode();

reg                             s_clk                           ;       
reg                             s_rst_n                         ;       
reg                             uart_flag                       ;       
reg [7:0]                       uart_data                       ;       
wire                            wr_trig                         ;       
wire                            rd_trig                         ;       
wire                            wfifo_wr_en                     ;       
wire [7:0]                      wfifo_data                      ;       

initial begin
s_clk = 1;
s_rst_n = 0;
#100;
s_rst_n = 1;
end

always begin
#10;
s_clk = ~s_clk;
end


initial begin
uart_flag <= 0;
uart_data <= 0;

#200;
uart_flag <= 1;
uart_data <= 8'h55;
#20;
uart_flag <= 0;

#200;
uart_flag <= 1;
uart_data <= 8'h13;
#20;
uart_flag <= 0;

#200;
uart_flag <= 1;
uart_data <= 8'h15;
#20;
uart_flag <= 0;

#200;
uart_flag <= 1;
uart_data <= 8'h32;
#20;
uart_flag <= 0;

#200;
uart_flag <= 1;
uart_data <= 8'h26;
#20;
uart_flag <= 0;

#200;
uart_flag <= 1;
uart_data <= 8'haa;
#20;
uart_flag <= 0;
end





cmd_decode cmd_decode_inst(
        .s_clk                  (s_clk                  ),
        .s_rst_n                (s_rst_n                ),

        .uart_flag              (uart_flag              ),
        .uart_data              (uart_data              ),
        .wr_trig                (wr_trig                ),
        .rd_trig                (rd_trig                ),
        .wfifo_wr_en            (wfifo_wr_en            ),
        .wfifo_data             (wfifo_data             )
);


endmodule
