# TCL File Generated by Component Editor 18.1
# Wed May 08 19:19:10 EDT 2019
# DO NOT MODIFY


# 
# vga_render "Sand Renderer" v1.0
#  2019.05.08.19:19:10
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module vga_render
# 
set_module_property DESCRIPTION ""
set_module_property NAME vga_render
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "Sand Renderer"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL vga_render
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file vga_render.sv SYSTEM_VERILOG PATH modules/vga_render.sv TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clock clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point vga
# 
add_interface vga conduit end
set_interface_property vga associatedClock clock
set_interface_property vga associatedReset ""
set_interface_property vga ENABLED true
set_interface_property vga EXPORT_OF ""
set_interface_property vga PORT_NAME_MAP ""
set_interface_property vga CMSIS_SVD_VARIABLES ""
set_interface_property vga SVD_ADDRESS_GROUP ""

add_interface_port vga VGA_R r Output 8
add_interface_port vga VGA_G g Output 8
add_interface_port vga VGA_CLK clk Output 1
add_interface_port vga VGA_HS hs Output 1
add_interface_port vga VGA_VS vs Output 1
add_interface_port vga VGA_BLANK_n blank_n Output 1
add_interface_port vga VGA_SYNC_n sync_n Output 1
add_interface_port vga VGA_B b Output 8


# 
# connection point sdram_master
# 
add_interface sdram_master avalon start
set_interface_property sdram_master addressUnits SYMBOLS
set_interface_property sdram_master associatedClock clock
set_interface_property sdram_master associatedReset reset
set_interface_property sdram_master bitsPerSymbol 8
set_interface_property sdram_master burstOnBurstBoundariesOnly false
set_interface_property sdram_master burstcountUnits WORDS
set_interface_property sdram_master doStreamReads false
set_interface_property sdram_master doStreamWrites false
set_interface_property sdram_master holdTime 0
set_interface_property sdram_master linewrapBursts false
set_interface_property sdram_master maximumPendingReadTransactions 0
set_interface_property sdram_master maximumPendingWriteTransactions 0
set_interface_property sdram_master readLatency 0
set_interface_property sdram_master readWaitTime 1
set_interface_property sdram_master setupTime 0
set_interface_property sdram_master timingUnits Cycles
set_interface_property sdram_master writeWaitTime 0
set_interface_property sdram_master ENABLED true
set_interface_property sdram_master EXPORT_OF ""
set_interface_property sdram_master PORT_NAME_MAP ""
set_interface_property sdram_master CMSIS_SVD_VARIABLES ""
set_interface_property sdram_master SVD_ADDRESS_GROUP ""

add_interface_port sdram_master address address Output 23
add_interface_port sdram_master read read Output 1
add_interface_port sdram_master readdata readdata Input 8
add_interface_port sdram_master waitrequest waitrequest Input 1

