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
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {215340000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {214561500 ps} {216225400 ps}
