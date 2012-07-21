module test_LEDState(
//Avalon System control signal.
input					rsi_MRST_reset,	// reset_n from MCU GPIO
input					csi_MCLK_clk,

//Avalon-ST LED Control.
output	[23:0]	aso_LEDS_data,
output				aso_LEDS_valid
);

assign	aso_LEDS_valid = 1;
assign	aso_LEDS_data = {r_cnt, g_cnt, b_cnt};

reg	[5:0]		state;
reg	[7:0]		r_cnt, g_cnt, b_cnt;
reg	[18:0]	delay_cnt;

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) begin
		state <= 0;
		r_cnt <= 0;
		g_cnt <= 0;
		b_cnt <= 0;
		delay_cnt <= 0;
	end
	else begin
		case(state)
			0: begin 
				g_cnt <= 0;
				b_cnt <= 0;
				delay_cnt <= delay_cnt + 1;
				if(delay_cnt == 19'h7FFFF) r_cnt <= r_cnt + 1;
				if(r_cnt == 255) state <= 1;
			end
			
			1: begin
				delay_cnt <= 0;
				state <= 2;
			end
			
			2: begin 
				delay_cnt <= delay_cnt + 1;
				if(delay_cnt == 19'h7FFFF) r_cnt <= r_cnt - 1;
				if(r_cnt == 0) state <= 3;
			end
			
			3: begin
				r_cnt <= 0;
				g_cnt <= 0;
				b_cnt <= 0;
				delay_cnt <= 0;
				state <= 4;
			end
			
			4: begin 
				delay_cnt <= delay_cnt + 1;
				if(delay_cnt == 19'h7FFFF) g_cnt <= g_cnt + 1;
				if(g_cnt == 255) state <= 5;
			end
			
			5: begin
				delay_cnt <= 0;
				state <= 6;
			end
			
			6: begin 
				delay_cnt <= delay_cnt + 1;
				if(delay_cnt == 19'h7FFFF) g_cnt <= g_cnt - 1;
				if(g_cnt == 0) state <= 7;
			end
			
			7: begin
				r_cnt <= 0;
				g_cnt <= 0;
				b_cnt <= 0;
				delay_cnt <= 0;
				state <= 8;
			end
			
			8: begin 
				delay_cnt <= delay_cnt + 1;
				if(delay_cnt == 19'h7FFFF) b_cnt <= b_cnt + 1;
				if(b_cnt == 255) state <= 9;
			end
			
			9: begin
				delay_cnt <= 0;
				state <= 10;
			end
			
			10: begin 
				delay_cnt <= delay_cnt + 1;
				if(delay_cnt == 19'h7FFFF) b_cnt <= b_cnt - 1;
				if(b_cnt == 0) state <= 11;
			end
			
			11: begin
				r_cnt <= 0;
				g_cnt <= 0;
				b_cnt <= 0;
				delay_cnt <= 0;
				state <= 0;
			end
			
			default: begin
				state <= 0;
				r_cnt <= 0;
				g_cnt <= 0;
				b_cnt <= 0;
				delay_cnt <= 0;
			end
			
		endcase
	end
end

endmodule
