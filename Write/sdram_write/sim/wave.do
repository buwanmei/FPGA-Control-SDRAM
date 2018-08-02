onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider tb_top
add wave -noupdate /tb_top/sclk
add wave -noupdate /tb_top/s_rst_n
add wave -noupdate /tb_top/sdram_clk
add wave -noupdate /tb_top/sdram_cke
add wave -noupdate /tb_top/sdram_cs_n
add wave -noupdate /tb_top/sdram_cas_n
add wave -noupdate /tb_top/sdram_ras_n
add wave -noupdate /tb_top/sdram_we_n
add wave -noupdate /tb_top/sdram_bank
add wave -noupdate /tb_top/sdram_addr
add wave -noupdate /tb_top/sdram_dqm
add wave -noupdate /tb_top/sdram_dq
add wave -noupdate /tb_top/wr_trig
add wave -noupdate -divider sdram_write
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/sclk
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/s_rst_n
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/wr_en
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/wr_req
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/flag_wr_end
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/ref_req
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/wr_trig
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/wr_cmd
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/wr_addr
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/bank_addr
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/wr_data
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/flag_wr
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/state
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/flag_act_end
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/flag_pre_end
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/sd_row_end
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/burst_cnt
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/burst_cnt_t
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/wr_data_end
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/act_cnt
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/break_cnt
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/col_cnt
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/row_addr
add wave -noupdate /tb_top/sdram_top_inst/sdram_write_inst/col_addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {215629600 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {214371300 ps} {218531700 ps}
