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



.main clear

run 320us