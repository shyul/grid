module qsys_test_RegRW(
//Avalon System control signal.
input					rsi_MRST_reset,	// reset_n from MCU GPIO
input					csi_MCLK_clk,

//Avalon-MM Control.
output	[31:0]	avs_TestReg_readdata,
input					avs_TestReg_read,
input		[31:0]	avs_TestReg_writedata,
input					avs_TestReg_write,
output				avs_TestReg_waitrequest
);

reg		[31:0]	testreg = 32'h12345678;

assign	avs_TestReg_readdata = testreg;
assign	avs_TestReg_waitrequest = rsi_MRST_reset;

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) testreg <= 32'h12345678;
	else begin
		if(avs_TestReg_write) testreg <= avs_TestReg_writedata;
	end
end

endmodule
