onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /uart_tx_tb/clk
add wave -noupdate /uart_tx_tb/dataValid
add wave -noupdate /uart_tx_tb/txData
add wave -noupdate -color Gold /uart_tx_tb/tx
add wave -noupdate -color Cyan /uart_tx_tb/txDone
add wave -noupdate /uart_tx_tb/txActive
add wave -noupdate /uart_tx_tb/char
add wave -noupdate /uart_tx_tb/state
add wave -noupdate /uart_tx_tb/clkCount
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {29 ps} 0} {{Cursor 2} {93 ps} 0}
quietly wave cursor active 2
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
WaveRestoreZoom {0 ps} {132 ps}
