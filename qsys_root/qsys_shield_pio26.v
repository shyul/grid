module qsys_shield_pio26(
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

input		[25:0]	coe_input,
output	[25:0]	coe_output,
output	[25:0]	coe_en
);

assign	avs_gpio_readdata = (avs_gpio_address == 0) ? {4'b0000, coe_input[25:22], coe_input[21:14], coe_input[13:6], 2'b0, coe_input[5:0]} : {4'b0000, io_oe[25:22], io_oe[21:14], io_oe[13:6], 2'b0, io_oe[5:0]};
assign	avs_gpio_waitrequest = 1'b0;

assign	coe_output = io_data;
assign	coe_en = io_oe;

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
