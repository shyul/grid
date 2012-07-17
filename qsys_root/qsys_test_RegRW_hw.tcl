# TCL File Generated by Component Editor 11.1sp2
# Tue Jul 17 11:08:44 CST 2012
# DO NOT MODIFY


# +-----------------------------------
# | 
# | qsys_test_RegRW "Avalon-MM Test Register" v1.0
# | Shyu Lee 2012.07.17.11:08:44
# | 
# | 
# | D:/Lophilo/grid/qsys_root/qsys_test_RegRW.v
# | 
# |    ./qsys_test_RegRW.v syn, sim
# | 
# +-----------------------------------

# +-----------------------------------
# | request TCL package from ACDS 11.0
# | 
package require -exact sopc 11.0
# | 
# +-----------------------------------

# +-----------------------------------
# | module qsys_test_RegRW
# | 
set_module_property NAME qsys_test_RegRW
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP Lophilo/Test
set_module_property AUTHOR "Shyu Lee"
set_module_property DISPLAY_NAME "Avalon-MM Test Register"
set_module_property TOP_LEVEL_HDL_FILE qsys_test_RegRW.v
set_module_property TOP_LEVEL_HDL_MODULE qsys_test_RegRW
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL TRUE
set_module_property STATIC_TOP_LEVEL_MODULE_NAME qsys_test_RegRW
set_module_property FIX_110_VIP_PATH false
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file qsys_test_RegRW.v {SYNTHESIS SIMULATION}
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
# | connection point MCLK
# | 
add_interface MCLK clock end
set_interface_property MCLK clockRate 0

set_interface_property MCLK ENABLED true

add_interface_port MCLK csi_MCLK_clk clk Input 1
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
# | connection point TestReg
# | 
add_interface TestReg avalon end
set_interface_property TestReg addressUnits WORDS
set_interface_property TestReg associatedClock MCLK
set_interface_property TestReg associatedReset MRST
set_interface_property TestReg bitsPerSymbol 8
set_interface_property TestReg burstOnBurstBoundariesOnly false
set_interface_property TestReg burstcountUnits WORDS
set_interface_property TestReg explicitAddressSpan 0
set_interface_property TestReg holdTime 0
set_interface_property TestReg linewrapBursts false
set_interface_property TestReg maximumPendingReadTransactions 0
set_interface_property TestReg readLatency 0
set_interface_property TestReg readWaitTime 1
set_interface_property TestReg setupTime 0
set_interface_property TestReg timingUnits Cycles
set_interface_property TestReg writeWaitTime 0

set_interface_property TestReg ENABLED true

add_interface_port TestReg avs_TestReg_readdata readdata Output 32
add_interface_port TestReg avs_TestReg_read read Input 1
add_interface_port TestReg avs_TestReg_writedata writedata Input 32
add_interface_port TestReg avs_TestReg_write write Input 1
add_interface_port TestReg avs_TestReg_waitrequest waitrequest Output 1
# | 
# +-----------------------------------
