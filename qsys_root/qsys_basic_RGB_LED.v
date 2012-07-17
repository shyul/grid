module qsys_basic_RGB_LED(
//Avalon System control signal.
input					rsi_MRST_reset,	// reset_n from MCU GPIO
input					csi_MCLK_clk,

//Avalon-MM LED Control.
input		[31:0]	avs_LEDD_writedata,
output	[31:0]	avs_LEDD_readdata,
input		[3:0]		avs_LEDD_byteenable,
input					avs_LEDD_write,
input					avs_LEDD_read,
output				avs_LEDD_waitrequest,

//Avalon-ST LED Control.
input		[23:0]	asi_LEDS_data,
input					asi_LEDS_valid,
output				asi_LEDS_ready,

//LED pin-out.
output				coe_LED_R,
output				coe_LED_G,
output				coe_LED_B
);

assign	avs_LEDD_readdata = {led_asi_en, 7'b0, led_r_data, led_g_data, led_b_data};
assign	avs_LEDD_waitrequest = rsi_MRST_reset;
assign	asi_LEDS_ready = led_asi_en;

reg		[7:0]		led_r_data, led_g_data, led_b_data;
reg		[7:0]		led_r_cnt, led_g_cnt, led_b_cnt;
reg					led_r, led_g, led_b;
reg					led_asi_en;

assign	coe_LED_R = led_r;
assign	coe_LED_G = led_g;
assign	coe_LED_B = led_b;

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) begin
		led_r_data <= 0;
		led_g_data <= 0;
		led_b_data <= 0;
		led_asi_en <= 0;
	end
	else begin
		if(avs_LEDD_write) begin
			if(avs_LEDD_byteenable[3]) led_asi_en <= avs_LEDD_writedata[31];
		end
		if(led_asi_en) begin
			if(asi_LEDS_valid) begin
				led_r_data <= asi_LEDS_data[23:16];
				led_g_data <= asi_LEDS_data[15:8];
				led_b_data <= asi_LEDS_data[7:0];
			end
		end
		else if(avs_LEDD_write) begin
			if(avs_LEDD_byteenable[2]) led_r_data <= avs_LEDD_writedata[23:16];
			if(avs_LEDD_byteenable[1]) led_g_data <= avs_LEDD_writedata[15:8];
			if(avs_LEDD_byteenable[0]) led_b_data <= avs_LEDD_writedata[7:0];
		end
	end
end

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) begin
		led_r_cnt <= 0;
		led_g_cnt <= 0;
		led_b_cnt <= 0;
		led_r <= 1'b1;
		led_g <= 1'b1;
		led_b <= 1'b1;
	end
	else begin
		led_r_cnt <= led_r_cnt + 1;
		led_g_cnt <= led_g_cnt + 1;
		led_b_cnt <= led_b_cnt + 1;
		if(led_r_cnt < led_r_data) led_r <= 1'b0; else led_r <= 1'b1;
		if(led_g_cnt < led_g_data) led_g <= 1'b0; else led_g <= 1'b1;
		if(led_b_cnt < led_b_data) led_b <= 1'b0; else led_b <= 1'b1;
	end
end

endmodule
