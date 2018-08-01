// *********************************************************************************
// Project Name : OSXXXX
// Author       : ZhangXiaoHong
// Email        : 1208481840@qq.com
// Website      : http://www.opensoc.cn/
// Create Time  : 2018/7/29 21:41:40
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
 /*
`timescale      1ns/1ns


module tb_uart_tx();

reg s_clk    ;
reg s_rst_n  ;
         
reg tx_trig  ;
         
reg [7:0] tx_data  ;
wire rs232_tx ;

initial begin
s_clk = 1;
s_rst_n = 0;
#100;
s_rst_n = 1;
end

always  begin
#5;
s_clk = ~s_clk;
end

initial begin
tx_data <= 0;
tx_trig <= 0;
#200;
tx_trig <= 1'b1;
tx_data <= 8'h55;
#10;
tx_trig <= 'd0;
#10;
tx_trig <= 1;
tx_data  <= 8'h32;
#10;
tx_trig <= 0;

end


 uart_tx  uart_tx_inst(
        .s_clk                  (s_clk                  ),
        .s_rst_n                (s_rst_n                ),

        .tx_trig                (tx_trig                ),

        .tx_data                (tx_data                ),
        .rs232_tx               (rs232_tx               )
);


endmodule
*/

`timescale 1ns/1ns
module tb_uart_tx;
reg sclk;
reg s_rst_n;
reg tx_trig;
reg [ 7:0] tx_data;
wire rs232_tx;
//------------- generate system signals ------------------------------------
initial begin
sclk = 1;
s_rst_n <= 0;
#100
s_rst_n <= 1;
end
always #5 sclk = ~sclk;
//--------------------------------------------------------------------------
initial begin
tx_data <= 8'd0;
tx_trig <= 0;
#200
tx_trig <= 1'b1;
tx_data <= 8'h55;
#10
tx_trig <= 1'b0;
end
uart_tx uart_tx_inst(
// system signals
.s_clk (sclk ),
.s_rst_n (s_rst_n ),
// UART Interface
.rs232_tx (rs232_tx ),
// others
.tx_trig (tx_trig ),
.tx_data (tx_data )
);
endmodule

