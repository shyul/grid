module test_RegRW8(
//Avalon System control signal.
input					rsi_MRST_reset,	// reset_n from MCU GPIO
input					csi_MCLK_clk,

//Avalon-MM Control.
output	[7:0]		avs_TestReg_readdata,
input					avs_TestReg_read,
input		[7:0]		avs_TestReg_writedata,
input					avs_TestReg_write
);

reg		[7:0]		testreg = 8'h5A;

assign	avs_TestReg_readdata = testreg;

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) testreg <= 8'h5A;
	else begin
		if(avs_TestReg_write) testreg <= avs_TestReg_writedata;
	end
end

endmodule
