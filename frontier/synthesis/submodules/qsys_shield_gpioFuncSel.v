module qsys_shield_gpioFuncSel(
//Avalon System control signal.
input					rsi_MRST_reset,	// reset_n from MCU GPIO
input					csi_MCLK_clk,

input		[7:0]		avs_ctrl_writedata,
output	[7:0]		avs_ctrl_readdata,
input					avs_ctrl_write,
input					avs_ctrl_read,
output				avs_ctrl_waitrequest,

input					coe_f0_oe,
input					coe_f1_oe,
input					coe_f2_oe,
input					coe_f3_oe,
input					coe_f4_oe,
input					coe_f5_oe,
input					coe_f6_oe,
input					coe_f7_oe,

input					coe_f0_out,
input					coe_f1_out,
input					coe_f2_out,
input					coe_f3_out,
input					coe_f4_out,
input					coe_f5_out,
input					coe_f6_out,
input					coe_f7_out,

output				coe_f_in,

inout					coe_GPIO
);

reg					io_oe, io_out;
reg		[2:0]		func_sel = 0;

assign	coe_GPIO = (io_oe) ? io_out : 1'bz;
assign	coe_f_in = coe_GPIO;

assign	avs_ctrl_readdata = {4'b0, func_sel, coe_GPIO};
assign	avs_ctrl_waitrequest = 1'b0;

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) func_sel <= 0;
	else begin
		if(avs_ctrl_write) func_sel <= avs_ctrl_writedata[3:1];
	end
end

always@(func_sel or coe_f0_out or coe_f1_out or coe_f2_out or coe_f3_out or coe_f4_out or coe_f5_out or coe_f6_out or coe_f7_out)
begin:MUX
	case(func_sel)
		0: io_out = coe_f0_out;
		1: io_out = coe_f1_out;
		2: io_out = coe_f2_out;
		3: io_out = coe_f3_out;
		4: io_out = coe_f4_out;
		5: io_out = coe_f5_out;
		6: io_out = coe_f6_out;
		7: io_out = coe_f7_out;
	endcase
end

always@(func_sel or coe_f0_oe or coe_f1_oe or coe_f2_oe or coe_f3_oe or coe_f4_oe or coe_f5_oe or coe_f6_oe or coe_f7_oe)
begin:MUXOE
	case(func_sel)
		0: io_oe = coe_f0_oe;
		1: io_oe = coe_f1_oe;
		2: io_oe = coe_f2_oe;
		3: io_oe = coe_f3_oe;
		4: io_oe = coe_f4_oe;
		5: io_oe = coe_f5_oe;
		6: io_oe = coe_f6_oe;
		7: io_oe = coe_f7_oe;
	endcase
end

endmodule
