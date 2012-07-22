module basic_ShieldCtrl(
//Avalon System control signal.
input					rsi_MRST_reset,	// reset_n from MCU GPIO
input					csi_MCLK_clk,

//Avalon-MM Control.
input		[31:0]	avs_Ctrl_writedata,
output	[31:0]	avs_Ctrl_readdata,
input		[3:0]		avs_Ctrl_byteenable,
input					avs_Ctrl_write,
input					avs_Ctrl_read,

//Over current interrupt.
output				ins_OC_irq,

input					coe_A_OCN,
output				coe_A_PWREN,
output				coe_A_HOE,
output				coe_A_LOE,
input					coe_B_OCN,
output				coe_B_PWREN,
output				coe_B_HOE,
output				coe_B_LOE
);

reg					rMODA_PWREN = 1;
reg					rMODA_HOE = 0;
reg					rMODA_LOE = 0;

reg					rMODB_PWREN = 1;
reg					rMODB_HOE = 0;
reg					rMODB_LOE = 0;

assign	avs_Ctrl_readdata = {6'b0, ~rMODB_PWREN, ~rMODA_PWREN, 6'b0, rMODB_HOE, rMODA_HOE, 6'b0, rMODB_LOE, rMODA_LOE, 6'b0, ~coe_B_OCN, ~coe_A_OCN};
assign	ins_OC_irq = ~(coe_A_OCN & coe_B_OCN);

assign	coe_A_PWREN = rMODA_PWREN;
assign	coe_A_HOE = rMODA_HOE;
assign	coe_A_LOE = rMODA_LOE;

assign	coe_B_PWREN = rMODB_PWREN;
assign	coe_B_HOE = rMODB_HOE;
assign	coe_B_LOE = rMODB_LOE;

always@(posedge csi_MCLK_clk or posedge rsi_MRST_reset)
begin
	if(rsi_MRST_reset) begin
		rMODA_PWREN <= 1;
		rMODA_HOE <= 0;
		rMODA_LOE <= 0;
		rMODB_PWREN <= 1;
		rMODB_HOE <= 0;
		rMODB_LOE <= 0;
	end
	else begin
		if(avs_Ctrl_write) begin
			if(avs_Ctrl_byteenable[3]) begin rMODB_PWREN <= ~avs_Ctrl_writedata[25]; rMODA_PWREN <= ~avs_Ctrl_writedata[24]; end
			if(avs_Ctrl_byteenable[2]) begin rMODB_HOE <= avs_Ctrl_writedata[17]; rMODA_HOE <= avs_Ctrl_writedata[16]; end
			if(avs_Ctrl_byteenable[1]) begin rMODB_LOE <= avs_Ctrl_writedata[9]; rMODA_LOE <= avs_Ctrl_writedata[8]; end
		end
	end
end

endmodule