// *********************************************************************************
// Project Name : 
// Author       : Kevin
// Email        : deng.kanwen@163.com
// Creat Time   : 2016/8/29 14:18:53
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
// 1. initial
// *********************************************************************************/
// *************************
// MODULE DEFINITION
// *************************

module  top(
        // system signals
        input                   sclk                    ,
        input                   s_rst_n                 ,
        // UART Interface
        input                   rs232_rx                ,
        output  wire            rs232_tx                ,
        // SDRAM Interfaces
        output  wire            sdram_clk               ,
        output  wire            sdram_cke               ,
        output  wire            sdram_cs_n              ,
        output  wire            sdram_cas_n             ,
        output  wire            sdram_ras_n             ,
        output  wire            sdram_we_n              ,
        output  wire    [ 1:0]  sdram_bank              ,
        output  wire    [11:0]  sdram_addr              ,
        output  wire    [ 1:0]  sdram_dqm               ,
        inout           [15:0]  sdram_dq                
);

//====================================================================\
// ********** Define Parameter and Internal Signals *************
//====================================================================/
//这些就是看你模块的连线
wire    [ 7:0]                  rx_data                         ;
wire                            tx_trig                         ;

wire                            sdram_wr_trig                   ;
wire                            sdram_rd_trig                   ;
wire                            wfifo_wr_en                     ;
wire    [ 7:0]                  wfifo_data                      ;
wire                            wfifo_rd_en                     ;
wire    [ 7:0]                  wfifo_rd_data                   ;

wire    [ 7:0]                  rfifo_wr_data                   ;
wire                            rfifo_wr_en                     ;
wire    [ 7:0]                  rfifo_rd_data                   ;
wire                            rfifo_rd_en                     ;
wire                            rfifo_empty                     ;
//=================================================================================
// ***************      Main    Code    ****************
//=================================================================================
uart_rx         uart_rx_inst(
        // system signals
        .sclk                    (sclk                  ),
        .s_rst_n                 (s_rst_n               ),
        // UART Interface        
        .rs232_rx                (rs232_rx              ),
        // others                
        .rx_data                 (rx_data               ),
        .po_flag                 (tx_trig               )
);

cmd_decode      cmd_decode_inst(
        // system signals
        .sclk                    (sclk                  ),
        .s_rst_n                 (s_rst_n               ),
        // From UART_RX module   
        .uart_flag               (tx_trig               ),
        .uart_data               (rx_data               ),
        // Others                
        .wr_trig                 (sdram_wr_trig         ),
        .rd_trig                 (sdram_rd_trig         ),
        .wfifo_wr_en             (wfifo_wr_en           ),
        .wfifo_data              (wfifo_data            )
);

//------------------------------------------------------------------------
fifo_16x8	wfifo_inst (
        .clock                  ( sclk                  ),
        .data                   ( wfifo_data            ),
        .rdreq                  ( wfifo_rd_en           ),
        .wrreq                  ( wfifo_wr_en           ),
        .empty                  (                       ),
        .q                      ( wfifo_rd_data         )
);

fifo_16x8	rfifo_inst (
        .clock                  ( sclk                  ),
        .data                   ( rfifo_wr_data         ),
        .rdreq                  ( rfifo_rd_en           ),
        .wrreq                  ( rfifo_wr_en           ),
        .empty                  ( rfifo_empty           ),
        .q                      ( rfifo_rd_data         )
);
//------------------------------------------------------------------------
uart_tx         uart_tx_inst(
        // system signals
        .sclk                    (sclk                  ),
        .s_rst_n                 (s_rst_n               ),
        // UART Interface
        .rs232_tx                (rs232_tx              ),
        //
        .rfifo_empty             (rfifo_empty           ),
        .rfifo_rd_en             (rfifo_rd_en           ),
        .rfifo_rd_data           (rfifo_rd_data         )
        
);
//------------------------------------------------------------------------
sdram_top       sdram_top_inst(
        // system signals
        .sclk                    (sclk                  ),
        .s_rst_n                 (s_rst_n               ),
        // SDRAM Interfaces
        .sdram_clk               (sdram_clk             ),
        .sdram_cke               (sdram_cke             ),
        .sdram_cs_n              (sdram_cs_n            ),
        .sdram_cas_n             (sdram_cas_n           ),
        .sdram_ras_n             (sdram_ras_n           ),
        .sdram_we_n              (sdram_we_n            ),
        .sdram_bank              (sdram_bank            ),
        .sdram_addr              (sdram_addr            ),
        .sdram_dqm               (sdram_dqm             ),
        .sdram_dq                (sdram_dq              ),
        // Others
        .wr_trig                 (sdram_wr_trig         ),
        .rd_trig                 (sdram_rd_trig         ),
        // FIFO Signals
        .wfifo_rd_en             (wfifo_rd_en           ),
        .wfifo_rd_data           (wfifo_rd_data         ),
        .rfifo_wr_data           (rfifo_wr_data         ),
        .rfifo_wr_en             (rfifo_wr_en           )
);

endmodule
