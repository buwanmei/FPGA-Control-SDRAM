##create work library
vlib work


vlog	"../src/*.v"
vlog	"./*.v"
vlog	"./altera_lib/*.v"
vlog	"./../src/core/*.v"

vsim	-voptargs=+acc work.tb_top

# Set the window types
view wave
view structure
view signals


add wave -divider {tb_top}
add wave tb_top/*
add wave -divider {top}
add wave tb_top/top_inst/*
add wave -divider {uart_rx}
add wave tb_top/top_inst/uart_rx_inst/*
add wave -divider {cmd_decode}
add wave tb_top/top_inst/cmd_decode_inst/*
add wave -divider {uart_tx}
add wave tb_top/top_inst/uart_tx_inst/*
add wave -divider {sdram_top}
add wave tb_top/top_inst/sdram_top_inst/*
add wave -divider {sdram_write}
add wave tb_top/top_inst/sdram_top_inst/sdram_write_inst/*
add wave -divider {sdram_read}
add wave tb_top/top_inst/sdram_top_inst/sdram_read_inst/*


.main clear

run 320us