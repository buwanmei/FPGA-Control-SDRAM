module  cmd_decode(
        // system signals
        input                   sclk                    ,
        input                   s_rst_n                 ,
        // From UART_RX module
        input                   uart_flag               ,
        input           [ 7:0]  uart_data               ,
        // Others
        output  wire            wr_trig                 ,
        output  wire            rd_trig                 ,
        output  wire            wfifo_wr_en             ,
        output  wire    [ 7:0]  wfifo_data              
);

//====================================================================\
// ********** Define Parameter and Internal Signals *************
//====================================================================/
localparam      REC_NUM_END     =       'd4                     ;

reg     [ 2:0]                  rec_num                         ;
reg     [ 7:0]                  cmd_reg                         ;

//=================================================================================
// ***************      Main    Code    ****************
//=================================================================================
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                rec_num <=      'd0;
        else if(uart_flag == 1'b1 && rec_num == 'd0 && uart_data == 8'haa)
                rec_num <=      'd0;
        else if(uart_flag == 1'b1 && rec_num == REC_NUM_END)
                rec_num <=      'd0;
        else if(uart_flag == 1'b1)
                rec_num <=      rec_num + 1'b1;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                cmd_reg <=      8'h00;
        else if(rec_num == 'd0 && uart_flag == 1'b1)
                cmd_reg <=      uart_data;
end

assign  wr_trig         =       (rec_num == REC_NUM_END && cmd_reg == 8'h55) ? uart_flag : 1'b0;
assign  rd_trig         =       (rec_num == 'd0 && uart_data == 8'haa) ? uart_flag : 1'b0;
assign  wfifo_wr_en     =       (rec_num >= 'd1) ? uart_flag : 1'b0;
assign  wfifo_data      =       uart_data;

endmodule