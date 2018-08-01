quit -sim

vlib work

#../返回上一级的目录，看你run.do文件在哪一个目录下面

vlog "../src/*.v"
vlog "./*.v"

#开始仿真
#tb_sdram_init这个是你要仿真的模块
vsim -voptargs=+acc work.tb_uart_rx

#添加指定信号
#添加顶层所有的信号
# Set the window types
# 打开波形窗口

view wave
view structure

# 打开信号窗口

view signals

# 添加波形模板

#tb_sdram_init这个是你要仿真的模块
add wave -divider {tb_uart_rx}
add wave tb_uart_rx/*
add wave -divider {uart_rx_inst}
add wave tb_uart_rx/uart_rx_inst/*

.main clear

#运行xxms

run 205us