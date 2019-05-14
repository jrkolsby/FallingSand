onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sand_top/clock
add wave -noupdate /sand_top/reset
add wave -noupdate /sand_top/mem_address
add wave -noupdate /sand_top/mem_read
add wave -noupdate /sand_top/mem_write
add wave -noupdate /sand_top/mem_waitrequest
add wave -noupdate /sand_top/mem_readdatavalid
add wave -noupdate /sand_top/mem_readdata
add wave -noupdate /sand_top/mem_writedata
add wave -noupdate /sand_top/write_x
add wave -noupdate /sand_top/write_y
add wave -noupdate /sand_top/write_radius
add wave -noupdate /sand_top/write_t
add wave -noupdate /sand_top/screen_select
add wave -noupdate /sand_top/screen_a_ptr
add wave -noupdate /sand_top/screen_b_ptr
add wave -noupdate /sand_top/cacheselect
add wave -noupdate /sand_top/screen_a_cache
add wave -noupdate /sand_top/screen_b_cache
add wave -noupdate /sand_top/screen_c_cache
add wave -noupdate /sand_top/render_address
add wave -noupdate /sand_top/physics_address
add wave -noupdate /sand_top/render_flag
add wave -noupdate /sand_top/render_read
add wave -noupdate /sand_top/physics_read
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 244
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1039 ps}
