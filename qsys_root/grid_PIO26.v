module grid_PIO26(
input					rsi_MRST_reset,
input					csi_MCLK_clk,

input		[31:0]	avs_gpio_writedata,
output	[31:0]	avs_gpio_readdata,
input		[4:0]		avs_gpio_address,
input		[3:0]		avs_gpio_byteenable,
input					avs_gpio_write,
input					avs_gpio_read,
output				avs_gpio_waitrequest,

output				ins_INTRQ_irq,

inout					coe_P0,
inout					coe_P1,
inout					coe_P2,
inout					coe_P3,
inout					coe_P4,
inout					coe_P5,
inout					coe_P6,
inout					coe_P7,
inout					coe_P8,
inout					coe_P9,
inout					coe_P10,
inout					coe_P11,
inout					coe_P12,
inout					coe_P13,
inout					coe_P14,
inout					coe_P15,
inout					coe_P16,
inout					coe_P17,
inout					coe_P18,
inout					coe_P19,
inout					coe_P20,
inout					coe_P21,
inout					coe_P22,
inout					coe_P23,
inout					coe_P24,
inout					coe_P25
);

assign	avs_gpio_readdata = (avs_gpio_address == 0) ? {4'b0000, coe_P25, coe_P24, coe_P23, coe_P22, coe_P21, coe_P20, coe_P19, coe_P18, coe_P17, coe_P16, coe_P15, coe_P14, coe_P13, coe_P12, coe_P11, coe_P10, coe_P9, coe_P8, coe_P7, coe_P6, 2'b0, coe_P5, coe_P4, coe_P3, coe_P2, coe_P1, coe_P0} : {4'b0000, io_oe[25:22], io_oe[21:14], io_oe[13:6], 2'b0, io_oe[5:0]};
assign	avs_gpio_waitrequest = 1'b0;
assign	ins_INTRQ_irq = 1'b0;

assign	coe_P0 = (io_oe[0]) ? io_data[0] : 1'bz;
assign	coe_P1 = (io_oe[1]) ? io_data[1] : 1'bz;
assign	coe_P2 = (io_oe[2]) ? io_data[2] : 1'bz;
assign	coe_P3 = (io_oe[3]) ? io_data[3] : 1'bz;
assign	coe_P4 = (io_oe[4]) ? io_data[4] : 1'bz;
assign	coe_P5 = (io_oe[5]) ? io_data[5] : 1'bz;
assign	coe_P6 = (io_oe[6]) ? io_data[6] : 1'bz;
assign	coe_P7 = (io_oe[7]) ? io_data[7] : 1'bz;
assign	coe_P8 = (io_oe[8]) ? io_data[8] : 1'bz;
assign	coe_P9 = (io_oe[9]) ? io_data[9] : 1'bz;
assign	coe_P10 = (io_oe[10]) ? io_data[10] : 1'bz;
assign	coe_P11 = (io_oe[11]) ? io_data[11] : 1'bz;
assign	coe_P12 = (io_oe[12]) ? io_data[12] : 1'bz;
assign	coe_P13 = (io_oe[13]) ? io_data[13] : 1'bz;
assign	coe_P14 = (io_oe[14]) ? io_data[14] : 1'bz;
assign	coe_P15 = (io_oe[15]) ? io_data[15] : 1'bz;
assign	coe_P16 = (io_oe[16]) ? io_data[16] : 1'bz;
assign	coe_P17 = (io_oe[17]) ? io_data[17] : 1'bz;
assign	coe_P18 = (io_oe[18]) ? io_data[18] : 1'bz;
assign	coe_P19 = (io_oe[19]) ? io_data[19] : 1'bz;
assign	coe_P20 = (io_oe[20]) ? io_data[20] : 1'bz;
assign	coe_P21 = (io_oe[21]) ? io_data[21] : 1'bz;
assign	coe_P22 = (io_oe[22]) ? io_data[22] : 1'bz;
assign	coe_P23 = (io_oe[23]) ? io_data[23] : 1'bz;
assign	coe_P24 = (io_oe[24]) ? io_data[24] : 1'bz;
assign	coe_P25 = (io_oe[25]) ? io_data[25] : 1'bz;

reg		[25:0]	io_data = 0;
reg		[25:0]	io_oe = 0;

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) begin
		io_data <= 0;
		io_oe = 0;
	end
	else begin
		if((avs_gpio_write)&&(avs_gpio_address == 0)) begin
			if(avs_gpio_byteenable[3]) io_data[25:22] <= avs_gpio_writedata[27:24];
			if(avs_gpio_byteenable[2]) io_data[21:14] <= avs_gpio_writedata[23:16];
			if(avs_gpio_byteenable[1]) io_data[13:6] <= avs_gpio_writedata[15:8];
			if(avs_gpio_byteenable[0]) io_data[5:0] <= avs_gpio_writedata[5:0];
		end
		else if((avs_gpio_write)&&(avs_gpio_address == 1)) begin
			if(avs_gpio_byteenable[3]) io_oe[25:22] <= avs_gpio_writedata[27:24];
			if(avs_gpio_byteenable[2]) io_oe[21:14] <= avs_gpio_writedata[23:16];
			if(avs_gpio_byteenable[1]) io_oe[13:6] <= avs_gpio_writedata[15:8];
			if(avs_gpio_byteenable[0]) io_oe[5:0] <= avs_gpio_writedata[5:0];
		end
	end
end

endmodule
