# TCL File Generated by Component Editor 11.1sp2
# Sun Jul 22 15:04:34 CST 2012
# DO NOT MODIFY


# +-----------------------------------
# | 
# | grid_PIO26 "Interrupt GPIO 26-bits" v1.0
# | Shyu Lee 2012.07.22.15:04:34
# | 
# | 
# | D:/Lophilo/grid/qsys_root/grid_PIO26.v
# | 
# |    ./grid_PIO26.v syn, sim
# | 
# +-----------------------------------

# +-----------------------------------
# | request TCL package from ACDS 11.0
# | 
package require -exact sopc 11.0
# | 
# +-----------------------------------

# +-----------------------------------
# | module grid_PIO26
# | 
set_module_property NAME grid_PIO26
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP Lophilo/Grid
set_module_property AUTHOR "Shyu Lee"
set_module_property DISPLAY_NAME "Interrupt GPIO 26-bits"
set_module_property TOP_LEVEL_HDL_FILE grid_PIO26.v
set_module_property TOP_LEVEL_HDL_MODULE grid_PIO26
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL TRUE
set_module_property STATIC_TOP_LEVEL_MODULE_NAME grid_PIO26
set_module_property FIX_110_VIP_PATH false
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file grid_PIO26.v {SYNTHESIS SIMULATION}
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
# | connection point gpio
# | 
add_interface gpio avalon end
set_interface_property gpio addressUnits WORDS
set_interface_property gpio associatedClock MCLK
set_interface_property gpio associatedReset MRST
set_interface_property gpio bitsPerSymbol 8
set_interface_property gpio burstOnBurstBoundariesOnly false
set_interface_property gpio burstcountUnits WORDS
set_interface_property gpio explicitAddressSpan 0
set_interface_property gpio holdTime 0
set_interface_property gpio linewrapBursts false
set_interface_property gpio maximumPendingReadTransactions 0
set_interface_property gpio readLatency 0
set_interface_property gpio readWaitTime 1
set_interface_property gpio setupTime 0
set_interface_property gpio timingUnits Cycles
set_interface_property gpio writeWaitTime 0

set_interface_property gpio ENABLED true

add_interface_port gpio avs_gpio_writedata writedata Input 32
add_interface_port gpio avs_gpio_readdata readdata Output 32
add_interface_port gpio avs_gpio_address address Input 5
add_interface_port gpio avs_gpio_byteenable byteenable Input 4
add_interface_port gpio avs_gpio_write write Input 1
add_interface_port gpio avs_gpio_read read Input 1
add_interface_port gpio avs_gpio_waitrequest waitrequest Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point gpint
# | 
add_interface gpint interrupt end
set_interface_property gpint associatedAddressablePoint gpio
set_interface_property gpint associatedClock MCLK
set_interface_property gpint associatedReset MRST

set_interface_property gpint ENABLED true

add_interface_port gpint ins_gpint_irq irq Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point EXPORT
# | 
add_interface EXPORT conduit end

set_interface_property EXPORT ENABLED true

add_interface_port EXPORT coe_P0 export Bidir 1
add_interface_port EXPORT coe_P1 export Bidir 1
add_interface_port EXPORT coe_P2 export Bidir 1
add_interface_port EXPORT coe_P3 export Bidir 1
add_interface_port EXPORT coe_P4 export Bidir 1
add_interface_port EXPORT coe_P5 export Bidir 1
add_interface_port EXPORT coe_P6 export Bidir 1
add_interface_port EXPORT coe_P7 export Bidir 1
add_interface_port EXPORT coe_P8 export Bidir 1
add_interface_port EXPORT coe_P9 export Bidir 1
add_interface_port EXPORT coe_P10 export Bidir 1
add_interface_port EXPORT coe_P11 export Bidir 1
add_interface_port EXPORT coe_P12 export Bidir 1
add_interface_port EXPORT coe_P13 export Bidir 1
add_interface_port EXPORT coe_P14 export Bidir 1
add_interface_port EXPORT coe_P15 export Bidir 1
add_interface_port EXPORT coe_P16 export Bidir 1
add_interface_port EXPORT coe_P17 export Bidir 1
add_interface_port EXPORT coe_P18 export Bidir 1
add_interface_port EXPORT coe_P19 export Bidir 1
add_interface_port EXPORT coe_P20 export Bidir 1
add_interface_port EXPORT coe_P21 export Bidir 1
add_interface_port EXPORT coe_P22 export Bidir 1
add_interface_port EXPORT coe_P23 export Bidir 1
add_interface_port EXPORT coe_P24 export Bidir 1
add_interface_port EXPORT coe_P25 export Bidir 1
# | 
# +-----------------------------------
