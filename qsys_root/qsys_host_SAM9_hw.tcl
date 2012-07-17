# TCL File Generated by Component Editor 11.1sp2
# Tue Jul 17 11:05:53 CST 2012
# DO NOT MODIFY


# +-----------------------------------
# | 
# | qsys_host_SAM9 "SAM9 Host Interface" v1.0
# | Shyu Lee 2012.07.17.11:05:53
# | 
# | 
# | D:/Lophilo/grid/qsys_root/qsys_host_SAM9.v
# | 
# |    ./qsys_host_SAM9.v syn, sim
# | 
# +-----------------------------------

# +-----------------------------------
# | request TCL package from ACDS 11.0
# | 
package require -exact sopc 11.0
# | 
# +-----------------------------------

# +-----------------------------------
# | module qsys_host_SAM9
# | 
set_module_property NAME qsys_host_SAM9
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP Lophilo/Basic
set_module_property AUTHOR "Shyu Lee"
set_module_property DISPLAY_NAME "SAM9 Host Interface"
set_module_property TOP_LEVEL_HDL_FILE qsys_host_SAM9.v
set_module_property TOP_LEVEL_HDL_MODULE qsys_host_SAM9
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL TRUE
set_module_property STATIC_TOP_LEVEL_MODULE_NAME qsys_host_SAM9
set_module_property FIX_110_VIP_PATH false
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file qsys_host_SAM9.v {SYNTHESIS SIMULATION}
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
add_interface MRST reset start
set_interface_property MRST associatedClock MCLK
set_interface_property MRST associatedDirectReset ""
set_interface_property MRST associatedResetSinks ""
set_interface_property MRST synchronousEdges DEASSERT

set_interface_property MRST ENABLED true

add_interface_port MRST rso_MRST_reset reset Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point MCLK
# | 
add_interface MCLK clock start
set_interface_property MCLK associatedDirectClock ""
set_interface_property MCLK clockRate 133333333
set_interface_property MCLK clockRateKnown true

set_interface_property MCLK ENABLED true

add_interface_port MCLK cso_MCLK_clk clk Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point H1CLK
# | 
add_interface H1CLK clock start
set_interface_property H1CLK associatedDirectClock ""
set_interface_property H1CLK clockRate 66666666
set_interface_property H1CLK clockRateKnown true

set_interface_property H1CLK ENABLED true

add_interface_port H1CLK cso_H1CLK_clk clk Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point H2CLK
# | 
add_interface H2CLK clock start
set_interface_property H2CLK associatedDirectClock ""
set_interface_property H2CLK clockRate 200000000
set_interface_property H2CLK clockRateKnown true

set_interface_property H2CLK ENABLED true

add_interface_port H2CLK cso_H2CLK_clk clk Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point M1
# | 
add_interface M1 avalon start
set_interface_property M1 addressUnits SYMBOLS
set_interface_property M1 associatedClock MCLK
set_interface_property M1 associatedReset MRST
set_interface_property M1 bitsPerSymbol 8
set_interface_property M1 burstOnBurstBoundariesOnly false
set_interface_property M1 burstcountUnits WORDS
set_interface_property M1 doStreamReads false
set_interface_property M1 doStreamWrites false
set_interface_property M1 holdTime 0
set_interface_property M1 linewrapBursts false
set_interface_property M1 maximumPendingReadTransactions 0
set_interface_property M1 readLatency 0
set_interface_property M1 readWaitTime 1
set_interface_property M1 setupTime 0
set_interface_property M1 timingUnits Cycles
set_interface_property M1 writeWaitTime 0

set_interface_property M1 ENABLED true

add_interface_port M1 avm_M1_writedata writedata Output 32
add_interface_port M1 avm_M1_readdata readdata Input 32
add_interface_port M1 avm_M1_address address Output 32
add_interface_port M1 avm_M1_byteenable byteenable Output 4
add_interface_port M1 avm_M1_write write Output 1
add_interface_port M1 avm_M1_read read Output 1
add_interface_port M1 avm_M1_begintransfer begintransfer Output 1
add_interface_port M1 avm_M1_readdatavalid readdatavalid Input 1
add_interface_port M1 avm_M1_waitrequest waitrequest Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point EVENTS
# | 
add_interface EVENTS interrupt start
set_interface_property EVENTS associatedAddressablePoint M1
set_interface_property EVENTS associatedClock MCLK
set_interface_property EVENTS associatedReset MRST
set_interface_property EVENTS irqScheme INDIVIDUAL_REQUESTS

set_interface_property EVENTS ENABLED true

add_interface_port EVENTS inr_EVENTS_irq irq Input 10
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point EXPORT
# | 
add_interface EXPORT conduit end

set_interface_property EXPORT ENABLED true

add_interface_port EXPORT coe_M1_RSTN export Input 1
add_interface_port EXPORT coe_M1_CLK export Input 1
add_interface_port EXPORT coe_M1_ADDR export Input 22
add_interface_port EXPORT coe_M1_DATA export Bidir 32
add_interface_port EXPORT coe_M1_CSN export Input 4
add_interface_port EXPORT coe_M1_BEN export Input 4
add_interface_port EXPORT coe_M1_RDN export Input 1
add_interface_port EXPORT coe_M1_WRN export Input 1
add_interface_port EXPORT coe_M1_WAITN export Output 1
add_interface_port EXPORT coe_M1_EINT export Output 10
# | 
# +-----------------------------------
