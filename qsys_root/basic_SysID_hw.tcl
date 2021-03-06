# TCL File Generated by Component Editor 11.1sp2
# Sun Jul 22 12:18:54 CST 2012
# DO NOT MODIFY


# +-----------------------------------
# | 
# | basic_SysID "Globe System ID" v1.0
# | Shyu Lee 2012.07.22.12:18:54
# | 
# | 
# | D:/Lophilo/grid/qsys_root/basic_SysID.v
# | 
# |    ./basic_SysID.v syn, sim
# | 
# +-----------------------------------

# +-----------------------------------
# | request TCL package from ACDS 11.0
# | 
package require -exact sopc 11.0
# | 
# +-----------------------------------

# +-----------------------------------
# | module basic_SysID
# | 
set_module_property NAME basic_SysID
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP Lophilo/Basic
set_module_property AUTHOR "Shyu Lee"
set_module_property DISPLAY_NAME "Globe System ID"
set_module_property TOP_LEVEL_HDL_FILE basic_SysID.v
set_module_property TOP_LEVEL_HDL_MODULE basic_SysID
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL TRUE
set_module_property STATIC_TOP_LEVEL_MODULE_NAME basic_SysID
set_module_property FIX_110_VIP_PATH false
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file basic_SysID.v {SYNTHESIS SIMULATION}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
# | 
# +-----------------------------------

# +-----------------------------------
# | display items
# | 
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point MRST
# | 
add_interface MRST reset end
set_interface_property MRST associatedClock MCLK
set_interface_property MRST synchronousEdges DEASSERT

set_interface_property MRST ENABLED true

add_interface_port MRST rsi_MRST_reset reset Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point MCLK
# | 
add_interface MCLK clock end
set_interface_property MCLK clockRate 0

set_interface_property MCLK ENABLED true

add_interface_port MCLK csi_MCLK_clk clk Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point SysID
# | 
add_interface SysID avalon end
set_interface_property SysID addressUnits WORDS
set_interface_property SysID associatedClock MCLK
set_interface_property SysID associatedReset MRST
set_interface_property SysID bitsPerSymbol 8
set_interface_property SysID burstOnBurstBoundariesOnly false
set_interface_property SysID burstcountUnits WORDS
set_interface_property SysID explicitAddressSpan 0
set_interface_property SysID holdTime 0
set_interface_property SysID linewrapBursts false
set_interface_property SysID maximumPendingReadTransactions 0
set_interface_property SysID readLatency 0
set_interface_property SysID readWaitTime 1
set_interface_property SysID setupTime 0
set_interface_property SysID timingUnits Cycles
set_interface_property SysID writeWaitTime 0

set_interface_property SysID ENABLED true

add_interface_port SysID avs_SysID_readdata readdata Output 32
add_interface_port SysID avs_SysID_address address Input 2
add_interface_port SysID avs_SysID_read read Input 1
add_interface_port SysID avs_SysID_waitrequest waitrequest Output 1
# | 
# +-----------------------------------
