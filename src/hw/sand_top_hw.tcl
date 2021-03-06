# TCL File Generated by Component Editor 18.1
# Tue May 14 10:25:24 EDT 2019
# DO NOT MODIFY


# 
# sand_top "Sand Toplevel" v1.0
#  2019.05.14.10:25:24
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module sand_top
# 
set_module_property DESCRIPTION ""
set_module_property NAME sand_top
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "Sand Toplevel"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL sand_top
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file sand_top.sv SYSTEM_VERILOG PATH modules/sand_top.sv TOP_LEVEL_FILE
add_fileset_file sand_update.sv SYSTEM_VERILOG PATH modules/sand_update.sv
add_fileset_file vga_render.sv SYSTEM_VERILOG PATH modules/vga_render.sv


# 
# parameters
# 
add_parameter SPOUT STD_LOGIC_VECTOR 1
set_parameter_property SPOUT DEFAULT_VALUE 1
set_parameter_property SPOUT DISPLAY_NAME SPOUT
set_parameter_property SPOUT TYPE STD_LOGIC_VECTOR
set_parameter_property SPOUT UNITS None
set_parameter_property SPOUT ALLOWED_RANGES 0:3
set_parameter_property SPOUT HDL_PARAMETER true


# 
# module assignments
# 
set_module_assignment embeddedsw.dts.group vga
set_module_assignment embeddedsw.dts.name sand_top
set_module_assignment embeddedsw.dts.vendor jjtech


# 
# display items
# 


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
# connection point kernel
# 
add_interface kernel avalon end
set_interface_property kernel addressUnits WORDS
set_interface_property kernel associatedClock clock
set_interface_property kernel associatedReset reset
set_interface_property kernel bitsPerSymbol 8
set_interface_property kernel burstOnBurstBoundariesOnly false
set_interface_property kernel burstcountUnits WORDS
set_interface_property kernel explicitAddressSpan 0
set_interface_property kernel holdTime 0
set_interface_property kernel linewrapBursts false
set_interface_property kernel maximumPendingReadTransactions 0
set_interface_property kernel maximumPendingWriteTransactions 0
set_interface_property kernel readLatency 0
set_interface_property kernel readWaitTime 1
set_interface_property kernel setupTime 0
set_interface_property kernel timingUnits Cycles
set_interface_property kernel writeWaitTime 0
set_interface_property kernel ENABLED true
set_interface_property kernel EXPORT_OF ""
set_interface_property kernel PORT_NAME_MAP ""
set_interface_property kernel CMSIS_SVD_VARIABLES ""
set_interface_property kernel SVD_ADDRESS_GROUP ""

add_interface_port kernel kernel_chipselect chipselect Input 1
add_interface_port kernel kernel_write write Input 1
add_interface_port kernel kernel_address address Input 3
add_interface_port kernel kernel_writedata writedata Input 16
set_interface_assignment kernel embeddedsw.configuration.isFlash 0
set_interface_assignment kernel embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment kernel embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment kernel embeddedsw.configuration.isPrintableDevice 0


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

add_interface_port vga VGA_G g Output 8
add_interface_port vga VGA_B b Output 8
add_interface_port vga VGA_CLK clk Output 1
add_interface_port vga VGA_HS hs Output 1
add_interface_port vga VGA_VS vs Output 1
add_interface_port vga VGA_BLANK_n blank_n Output 1
add_interface_port vga VGA_SYNC_n sync_n Output 1
add_interface_port vga VGA_R r Output 8


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

add_interface_port sdram_master mem_address address Output 24
add_interface_port sdram_master mem_read read Output 1
add_interface_port sdram_master mem_readdata readdata Input 16
add_interface_port sdram_master mem_readdatavalid readdatavalid Input 1
add_interface_port sdram_master mem_waitrequest waitrequest Input 1
add_interface_port sdram_master mem_write write Output 1
add_interface_port sdram_master mem_writedata writedata Output 16
add_interface_port sdram_master mem_writeresponsevalid writeresponsevalid Input 1
add_interface_port sdram_master mem_response response Input 2

