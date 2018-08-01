module  sdram_write(
        // system signals
        input                   sclk                    ,
        input                   s_rst_n                 ,
        // Communicate with TOP
        input                   wr_en                   ,
        output  wire            wr_req                  ,
        output  reg             flag_wr_end             ,
        // Others
        input                   ref_req                 ,
        input                   wr_trig                 ,
        // write interfaces
        output  reg     [ 3:0]  wr_cmd                  ,
        output  reg     [11:0]  wr_addr                 ,
        output  wire    [ 1:0]  bank_addr               ,
        output  reg     [15:0]  wr_data                 
     
);

//===================================================================\
// ********* Define Parameter and Internal Signals *********
//===================================================================/
// Define State
localparam      S_IDLE          =       5'b0_0001               ;
localparam      S_REQ           =       5'b0_0010               ;
localparam      S_ACT           =       5'b0_0100               ;
localparam      S_WR            =       5'b0_1000               ;
localparam      S_PRE           =       5'b1_0000               ;
// SDRAM Command
localparam      CMD_NOP         =       4'b0111                 ;
localparam      CMD_PRE         =       4'b0010                 ;
localparam      CMD_AREF        =       4'b0001                 ;
localparam      CMD_ACT         =       4'b0011                 ;
localparam      CMD_WR          =       4'b0100                 ;



reg                             flag_wr                         ;
reg     [ 4:0]                  state                           ;
//-----------------------------------------------------------------
reg                             flag_act_end                    ;
reg                             flag_pre_end                    ;
reg                             sd_row_end                      ;
reg     [ 1:0]                  burst_cnt                       ; 
reg     [ 1:0]                  burst_cnt_t                     ; 
reg                             wr_data_end                     ;
//-----------------------------------------------------------------
reg     [ 3:0]                  act_cnt                         ;
reg     [ 3:0]                  break_cnt                       ;
reg     [ 6:0]                  col_cnt                         ;
//-----------------------------------------------------------------
reg     [11:0]                  row_addr                        ;
wire    [ 8:0]                  col_addr                        ;

//==========================================================================
// ****************     Main    Code    **************
//==========================================================================
//flag_wr
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                flag_wr <=      1'b0;
        else if(wr_trig == 1'b1 && flag_wr == 1'b0)
                flag_wr <=      1'b1;
        else if(wr_data_end == 1'b1)
                flag_wr <=      1'b0;
end

// burst_cnt
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                burst_cnt       <=      'd0;
        else if(state == S_WR)
                burst_cnt       <=      burst_cnt + 1'b1;
        else
                burst_cnt       <=      'd0;
end

// burst_cnt_t
always  @(posedge sclk) begin
        burst_cnt_t     <=      burst_cnt;
end

//-------------------------  STATE ------------------------------------------
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                state   <=      S_IDLE;
        else case(state)
                S_IDLE:
                        if(wr_trig == 1'b1)
                                state   <=      S_REQ;
                        else
                                state   <=      S_IDLE;
                S_REQ:
                        if(wr_en == 1'b1)
                                state   <=      S_ACT;
                        else
                                state   <=      S_REQ;
                S_ACT:
                        if(flag_act_end == 1'b1)
                                state   <=      S_WR;
                        else 
                                state   <=      S_ACT;
                S_WR:
                        if(wr_data_end == 1'b1)
                                state   <=      S_PRE;
                        else if(ref_req == 1'b1 && burst_cnt_t == 'd2 && flag_wr == 1'b1)
                                state   <=      S_PRE;
                        else if(sd_row_end == 1'b1 && flag_wr == 1'b1)
                                state   <=      S_PRE;
                S_PRE:
                        if(ref_req == 1'b1 && flag_wr == 1'b1)
                                state   <=      S_REQ;
                        else if(flag_pre_end == 1'b1 && flag_wr == 1'b1)
                                state   <=      S_ACT;
                        else if(flag_wr == 1'b0)    
                                state   <=      S_IDLE;
                default:
                        state   <=      S_IDLE;
        endcase
end

// wr_cmd
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                wr_cmd  <=      CMD_NOP;
        else case(state)
                S_ACT:  
                        if(act_cnt == 'd0)
                                wr_cmd  <=      CMD_ACT;
                        else 
                                wr_cmd  <=      CMD_NOP;
                S_WR:
                        if(burst_cnt == 'd0)
                                wr_cmd  <=      CMD_WR;
                        else
                                wr_cmd  <=      CMD_NOP;
                S_PRE:
                        if(break_cnt == 'd0)
                                wr_cmd  <=      CMD_PRE;
                        else
                                wr_cmd  <=      CMD_NOP;
                default:
                        wr_cmd  <=      CMD_NOP;
        endcase
end

// wr_addr
always  @(*) begin
        case(state)
                S_ACT:
                        if(act_cnt == 'd1)
                                wr_addr <=      row_addr;
                        else
                                wr_addr <=      'd0;
                S_WR:   wr_addr <=      {3'b000, col_addr};
                S_PRE:  if(break_cnt == 'd0)
                                wr_addr <=      {12'b0100_0000_0000};
                        else
                                wr_addr <=      'd0;
                default:
                        wr_addr <=      'd0;
        endcase
end
//-------------------------------------------------------------------
// flag_act_end
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                flag_act_end    <=      1'b0;
        else if(act_cnt == 'd3)
                flag_act_end    <=      1'b1;
        else    
                flag_act_end    <=      1'b0;
end

// act_cnt
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                act_cnt <=      'd0;
        else if(state == S_ACT)
                act_cnt <=      act_cnt + 1'b1;
        else
                act_cnt <=      'd0;
end

// flag_pre_end
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                flag_pre_end    <=      1'b0;
        else if(break_cnt == 'd3)
                flag_pre_end    <=      1'b1;
        else 
                flag_pre_end    <=      1'b0;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                flag_wr_end     <=      1'b0;
        else if((state == S_PRE && ref_req == 1'b1) ||   //refresh
                 state == S_PRE && flag_wr == 1'b0)     
                flag_wr_end     <=      1'b1;
        else 
                flag_wr_end     <=      1'b0;
end

// break_cnt
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                break_cnt <=      'd0;
        else if(state == S_PRE)
                break_cnt <=      break_cnt + 1'b1;
        else
                break_cnt <=      'd0;
end

// wr_data_end
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                wr_data_end     <=      1'b0;
        else if(row_addr == 'd2 && col_addr == 'd511)
                wr_data_end     <=      1'b1;
        else
                wr_data_end     <=      1'b0;
end

// col_cnt
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                col_cnt <=      'd0;
        else if(col_addr == 'd511)
                col_cnt <=      'd0;
        else if(burst_cnt_t == 'd3)
                col_cnt <=      col_cnt + 1'b1;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                row_addr        <=      'd0;
        else if(sd_row_end == 1'b1)
                row_addr        <=      row_addr + 1'b1;
end

always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                sd_row_end      <=      1'b0;
        else if(col_addr == 'd509)
                sd_row_end      <=      1'b1;
        else
                sd_row_end      <=      1'b0;
end

//----------------------------------------------------------------
 always  @(*) begin
        case(burst_cnt_t)
                0:      wr_data <=      'd3;
                1:      wr_data <=      'd5;
                2:      wr_data <=      'd7;
                3:      wr_data <=      'd9;
        endcase
end 
//----------------------------------------------------------------

assign  col_addr        =       {col_cnt, burst_cnt_t};
//assign  col_addr        =       {7'd0, burst_cnt_t};
assign  bank_addr       =       2'b00;
assign  wr_req          =       state[1];


endmodule
