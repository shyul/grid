module qsys_test_LED(
//Avalon System control signal.
input					rsi_MRST_reset,	// reset_n from MCU GPIO
input					csi_MCLK_clk,

//Avalon-MM Control.
output	[31:0]	avs_TestReg_readdata,
input					avs_TestReg_read,
input		[31:0]	avs_TestReg_writedata,
input					avs_TestReg_write,
output				avs_TestReg_waitrequest,

output				coe_LED_F0R,
output				coe_LED_F0G,
output				coe_LED_F0B,
output				coe_LED_F1R,
output				coe_LED_F1G,
output				coe_LED_F1B,
output				coe_LED_F2R,
output				coe_LED_F2G,
output				coe_LED_F2B,
output				coe_LED_F3R,
output				coe_LED_F3G,
output				coe_LED_F3B
);

reg		[31:0]	testreg = 32'h5A5A5A5A;

assign	avs_TestReg_readdata = testreg;
assign	avs_TestReg_waitrequest = rsi_MRST_reset;

assign	coe_LED_F0R = testreg[0];
assign 	coe_LED_F0G = testreg[1];
assign	coe_LED_F0B = testreg[2];
assign	coe_LED_F1R = testreg[3];
assign	coe_LED_F1G = testreg[4];
assign	coe_LED_F1B = testreg[5];
assign	coe_LED_F2R = testreg[6];
assign	coe_LED_F2G = testreg[7];
assign	coe_LED_F2B = testreg[8];
assign	coe_LED_F3R = testreg[9];
assign	coe_LED_F3G = testreg[10];
assign	coe_LED_F3B = testreg[11];

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) testreg <= 32'h5A5A5A5A;
	else begin
		if(avs_TestReg_write) testreg <= avs_TestReg_writedata;
	end
end

endmodule
