`timescale      1ns/1ns

module  tb_top;

reg             sclk;
reg             s_rst_n;

//----------------------------------------------------------
wire            sdram_clk;
wire            sdram_cke;
wire            sdram_cs_n;
wire            sdram_cas_n;
wire            sdram_ras_n;
wire            sdram_we_n;
wire    [ 1:0]  sdram_bank;
wire    [11:0]  sdram_addr;
wire    [ 1:0]  sdram_dqm;
wire    [15:0]  sdram_dq;


reg wr_trig;
//----------------------------------------------------------

initial begin
        sclk    =       1;
        s_rst_n <=      0;
        #100
        s_rst_n <=      1;
      
end

initial begin
wr_trig = 0;
#205000;
wr_trig = 1;
#20;
wr_trig = 0;
end


always  #10     sclk    =       ~sclk;

defparam        sdram_model_plus_inst.addr_bits =       12;
defparam        sdram_model_plus_inst.data_bits =       16;
defparam        sdram_model_plus_inst.col_bits  =       9;
defparam        sdram_model_plus_inst.mem_sizes =       2*1024*1024;            // 2M


sdram_top   sdram_top_inst(
        // system signals
        .sclk                   (sclk                   ),
        .s_rst_n                (s_rst_n                ),
        // SDRAM Interfaces
        .sdram_clk              (sdram_clk              ),
        .sdram_cke              (sdram_cke              ),
        .sdram_cs_n             (sdram_cs_n             ),
        .sdram_cas_n            (sdram_cas_n            ),
        .sdram_ras_n            (sdram_ras_n            ),
        .sdram_we_n             (sdram_we_n             ),
        .sdram_bank             (sdram_bank             ),
        .sdram_addr             (sdram_addr             ),
        .sdram_dqm              (sdram_dqm              ),
        .sdram_dq               (sdram_dq               ),
        // Others
        .wr_trig                (wr_trig                )
);



sdram_model_plus sdram_model_plus_inst(
        .Dq                     (sdram_dq               ), 
        .Addr                   (sdram_addr             ), 
        .Ba                     (sdram_bank             ), 
        .Clk                    (sdram_clk              ), 
        .Cke                    (sdram_cke              ), 
        .Cs_n                   (sdram_cs_n             ), 
        .Ras_n                  (sdram_ras_n            ), 
        .Cas_n                  (sdram_cas_n            ), 
        .We_n                   (sdram_we_n             ), 
        .Dqm                    (sdram_dqm              ),
        .Debug                  (1'b1                   )
);


endmodule
