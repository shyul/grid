module qsys_basic_SysID(
//Avalon System control signal.
input					rsi_MRST_reset,	// reset_n from MCU GPIO
input					csi_MCLK_clk,

//Avalon-MM LED Control.
output	[31:0]	avs_SysID_readdata,
input					avs_SysID_read,
output				avs_SysID_waitrequest
);

assign	avs_SysID_readdata[31:16] = 16'hEA68;
assign	avs_SysID_readdata[15:0] = 16'h0001;
assign	avs_SysID_waitrequest = 1'b0;

endmodule
