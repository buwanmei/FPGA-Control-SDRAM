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


reg             rs232_tx;

initial $readmemh("./tx_data.txt", mem_a);
 
reg     [ 7:0]  mem_a[5:0];

task    tx_byte();
        integer i;
        for(i=0; i<6; i=i+1) begin
                tx_bit(mem_a[i]);
        end
endtask

task    tx_bit(
                input   [ 7:0]  data
                );
        integer i;
        for(i=0; i<10; i=i+1) begin
                case(i)
                        0:      rs232_tx        <=      1'b0;
                        1:      rs232_tx        <=      data[0];
                        2:      rs232_tx        <=      data[1];
                        3:      rs232_tx        <=      data[2];
                        4:      rs232_tx        <=      data[3];
                        5:      rs232_tx        <=      data[4];
                        6:      rs232_tx        <=      data[5];
                        7:      rs232_tx        <=      data[6];
                        8:      rs232_tx        <=      data[7];
                        9:      rs232_tx        <=      1'b1;
                endcase
                #560;
        end
endtask



//----------------------------------------------------------

initial begin
        sclk    =       1;
        s_rst_n <=      0;
        rs232_tx<=      1;
        #100
        s_rst_n <=      1;
        #200000
        tx_byte();
        #34100
        tx_byte();
end

always  #10     sclk    =       ~sclk;

defparam        sdram_model_plus_inst.addr_bits =       12;
defparam        sdram_model_plus_inst.data_bits =       16;
defparam        sdram_model_plus_inst.col_bits  =       9;
defparam        sdram_model_plus_inst.mem_sizes =       2*1024*1024;            // 2M




top             top_inst(
        // system signals
        .sclk                    (sclk                  ),
        .s_rst_n                 (s_rst_n               ),
        // UART Interface
        .rs232_rx                (rs232_tx              ),
        .rs232_tx                (),
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
        .sdram_dq                (sdram_dq              )
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