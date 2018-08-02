##create work library
vlib work


vlog	"../src/*.v"
vlog	"./*.v"


vsim	-voptargs=+acc work.tb_top

# Set the window types
view wave
view structure
view signals


add wave -divider {tb_top}
add wave tb_top/*
add wave -divider {sdram_write}
add wave tb_top/sdram_top_inst/sdram_write_inst/*



.main clear

run 220us