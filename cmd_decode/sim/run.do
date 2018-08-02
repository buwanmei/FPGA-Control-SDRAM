##create work library
vlib work


vlog	"../src/*.v"
vlog	"./*.v"


vsim	-voptargs=+acc work.tb_cmd_decode

# Set the window types
view wave
view structure
view signals


add wave -divider {tb_cmd_decode}
add wave tb_cmd_decode/*



.main clear

run 20us