# TCL File Generated by Component Editor 18.1
# Sat May 04 18:54:00 EDT 2019
# DO NOT MODIFY


# 
# sand_update "Sand Update" v1.0
#  2019.05.04.18:54:00
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module sand_update
# 
set_module_property DESCRIPTION ""
set_module_property NAME sand_update
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "Sand Update"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL new_component
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file sand_update.sv SYSTEM_VERILOG PATH modules/sand_update.sv TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 

