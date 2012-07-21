module test_RegWaitRW8(
//Avalon System control signal.
input					rsi_MRST_reset,	// reset_n from MCU GPIO
input					csi_MCLK_clk,

//Avalon-MM Control.
input		[7:0]		avs_test_writedata,
output	[7:0]		avs_test_readdata,
input		[5:0]		avs_test_address,
input					avs_test_write,
input					avs_test_read,
output				avs_test_waitrequest
);

reg		[7:0]		out_data = 0;
reg		[7:0]		r_data = 0;
reg					r_wait = 0;
reg		[4:0]		r_wait_cnt = 0;

assign	avs_test_readdata = out_data;
assign	avs_test_waitrequest = r_wait;

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) begin
		out_data <= 0;
		r_data <= 0;
		r_wait <= 0;
		r_wait_cnt <= 0;
	end
	else begin
		if((r_wait_cnt > 0)&&(r_wait_cnt < 31)) r_wait <= 1; else r_wait <= 0;
		if(avs_test_read) begin
			r_wait_cnt <= r_wait_cnt + 1;
			out_data <= r_data + avs_test_address;
		end
		else if(avs_test_write) begin
			r_wait_cnt <= r_wait_cnt + 1;
			case(avs_test_address)
				0: begin
					r_data <= avs_test_writedata;
				end
				1: begin
					r_data <= ~avs_test_writedata;				
				end
				default: begin
					r_data <= 0;				
				end
			endcase
		end
		else begin
			r_wait_cnt <= 0;
		end
	end
end

endmodule
