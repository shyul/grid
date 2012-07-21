module test_RegRW16(
//Avalon System control signal.
input					rsi_MRST_reset,	// reset_n from MCU GPIO
input					csi_MCLK_clk,

//Avalon-MM Control.
input		[15:0]	avs_TestReg_writedata,
output	[15:0]	avs_TestReg_readdata,
input		[1:0]		avs_TestReg_byteenable,
input					avs_TestReg_write,
input					avs_TestReg_read
);

reg		[15:0]	testreg = 16'h5a5a;

assign	avs_TestReg_readdata = testreg;

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) testreg <= 16'h5a5a;
	else begin
		if(avs_TestReg_write) begin
			if(avs_TestReg_byteenable[1]) testreg[15:8] <= avs_TestReg_writedata[15:8];
			if(avs_TestReg_byteenable[0]) testreg[7:0] <= avs_TestReg_writedata[7:0];
		end
	end
end

endmodule
