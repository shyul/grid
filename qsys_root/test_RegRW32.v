module test_RegRW32(
//Avalon System control signal.
input					rsi_MRST_reset,	// reset_n from MCU GPIO
input					csi_MCLK_clk,

//Avalon-MM Control.
input		[31:0]	avs_TestReg_writedata,
output	[31:0]	avs_TestReg_readdata,
input		[3:0]		avs_TestReg_byteenable,
input					avs_TestReg_write,
input					avs_TestReg_read
);

reg		[31:0]	testreg = 32'h12345678;

assign	avs_TestReg_readdata = testreg;

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) testreg <= 32'h12345678;
	else begin
		if(avs_TestReg_write) begin
			if(avs_TestReg_byteenable[3]) testreg[31:24] <= avs_TestReg_writedata[31:24];
			if(avs_TestReg_byteenable[2]) testreg[23:16] <= avs_TestReg_writedata[23:16];
			if(avs_TestReg_byteenable[1]) testreg[15:8] <= avs_TestReg_writedata[15:8];
			if(avs_TestReg_byteenable[0]) testreg[7:0] <= avs_TestReg_writedata[7:0];
		end
	end
end

endmodule
