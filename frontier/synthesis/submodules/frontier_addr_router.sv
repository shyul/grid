// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/12.1sp1/ip/merlin/altera_merlin_router/altera_merlin_router.sv.terp#1 $
// $Revision: #1 $
// $Date: 2012/10/10 $
// $Author: swbranch $

// -------------------------------------------------------
// Merlin Router
//
// Asserts the appropriate one-hot encoded channel based on 
// either (a) the address or (b) the dest id. The DECODER_TYPE
// parameter controls this behaviour. 0 means address decoder,
// 1 means dest id decoder.
//
// In the case of (a), it also sets the destination id.
// -------------------------------------------------------

`timescale 1 ns / 1 ns

module frontier_addr_router_default_decode
  #(
     parameter DEFAULT_CHANNEL = 6,
               DEFAULT_DESTID = 6 
   )
  (output [100 - 95 : 0] default_destination_id,
   output [35-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[100 - 95 : 0];
  generate begin : default_decode
    if (DEFAULT_CHANNEL == -1)
      assign default_src_channel = '0;
    else
      assign default_src_channel = 35'b1 << DEFAULT_CHANNEL;
  end
  endgenerate

endmodule


module frontier_addr_router
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // Command Sink (Input)
    // -------------------
    input                       sink_valid,
    input  [111-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [111-1    : 0] src_data,
    output reg [35-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 67;
    localparam PKT_ADDR_L = 36;
    localparam PKT_DEST_ID_H = 100;
    localparam PKT_DEST_ID_L = 95;
    localparam ST_DATA_W = 111;
    localparam ST_CHANNEL_W = 35;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 70;
    localparam PKT_TRANS_READ  = 71;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;




    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    localparam PAD0 = log2ceil(64'h10000010 - 64'h10000000);
    localparam PAD1 = log2ceil(64'h10000104 - 64'h10000100);
    localparam PAD2 = log2ceil(64'h10000108 - 64'h10000104);
    localparam PAD3 = log2ceil(64'h1000010c - 64'h10000108);
    localparam PAD4 = log2ceil(64'h10000110 - 64'h1000010c);
    localparam PAD5 = log2ceil(64'h10000204 - 64'h10000200);
    localparam PAD6 = log2ceil(64'h20000080 - 64'h20000000);
    localparam PAD7 = log2ceil(64'h20000100 - 64'h20000080);
    localparam PAD8 = log2ceil(64'h20000120 - 64'h20000100);
    localparam PAD9 = log2ceil(64'h20000140 - 64'h20000120);
    localparam PAD10 = log2ceil(64'h20000160 - 64'h20000140);
    localparam PAD11 = log2ceil(64'h20000180 - 64'h20000160);
    localparam PAD12 = log2ceil(64'h200001a0 - 64'h20000180);
    localparam PAD13 = log2ceil(64'h200001c0 - 64'h200001a0);
    localparam PAD14 = log2ceil(64'h200001e0 - 64'h200001c0);
    localparam PAD15 = log2ceil(64'h20000200 - 64'h200001e0);
    localparam PAD16 = log2ceil(64'h20000220 - 64'h20000200);
    localparam PAD17 = log2ceil(64'h20000240 - 64'h20000220);
    localparam PAD18 = log2ceil(64'h20000260 - 64'h20000240);
    localparam PAD19 = log2ceil(64'h20000280 - 64'h20000260);
    localparam PAD20 = log2ceil(64'h200002a0 - 64'h20000280);
    localparam PAD21 = log2ceil(64'h200002c0 - 64'h200002a0);
    localparam PAD22 = log2ceil(64'h200002e0 - 64'h200002c0);
    localparam PAD23 = log2ceil(64'h20000300 - 64'h200002e0);
    localparam PAD24 = log2ceil(64'h20000320 - 64'h20000300);
    localparam PAD25 = log2ceil(64'h20000340 - 64'h20000320);
    localparam PAD26 = log2ceil(64'h20000360 - 64'h20000340);
    localparam PAD27 = log2ceil(64'h20000380 - 64'h20000360);
    localparam PAD28 = log2ceil(64'h200003a0 - 64'h20000380);
    localparam PAD29 = log2ceil(64'h200003c0 - 64'h200003a0);
    localparam PAD30 = log2ceil(64'h200003e0 - 64'h200003c0);
    localparam PAD31 = log2ceil(64'h20000400 - 64'h200003e0);
    localparam PAD32 = log2ceil(64'h20000420 - 64'h20000400);
    localparam PAD33 = log2ceil(64'h20000440 - 64'h20000420);
    localparam PAD34 = log2ceil(64'h20000450 - 64'h20000440);
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h20000450;
    localparam RANGE_ADDR_WIDTH = log2ceil(ADDR_RANGE);
    localparam OPTIMIZED_ADDR_H = (RANGE_ADDR_WIDTH > PKT_ADDR_W) ||
                                  (RANGE_ADDR_WIDTH == 0) ?
                                        PKT_ADDR_H :
                                        PKT_ADDR_L + RANGE_ADDR_WIDTH - 1;
    localparam RG = RANGE_ADDR_WIDTH-1;

      wire [PKT_ADDR_W-1 : 0] address = sink_data[OPTIMIZED_ADDR_H : PKT_ADDR_L];

    // -------------------------------------------------------
    // Pass almost everything through, untouched
    // -------------------------------------------------------
    assign sink_ready        = src_ready;
    assign src_valid         = sink_valid;
    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket   = sink_endofpacket;

    wire [PKT_DEST_ID_W-1:0] default_destid;
    wire [35-1 : 0] default_src_channel;




    frontier_addr_router_default_decode the_default_decode(
      .default_destination_id (default_destid),
      .default_src_channel (default_src_channel)
    );

    always @* begin
        src_data    = sink_data;
        src_channel = default_src_channel;

        src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = default_destid;
        // --------------------------------------------------
        // Address Decoder
        // Sets the channel and destination ID based on the address
        // --------------------------------------------------

        // ( 0x10000000 .. 0x10000010 )
        if ( {address[RG:PAD0],{PAD0{1'b0}}} == 30'h10000000 ) begin
            src_channel = 35'b00000000000000000000000000000000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
        end

        // ( 0x10000100 .. 0x10000104 )
        if ( {address[RG:PAD1],{PAD1{1'b0}}} == 30'h10000100 ) begin
            src_channel = 35'b00000000000000000000000000000000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
        end

        // ( 0x10000104 .. 0x10000108 )
        if ( {address[RG:PAD2],{PAD2{1'b0}}} == 30'h10000104 ) begin
            src_channel = 35'b00000000000000000000000000000000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
        end

        // ( 0x10000108 .. 0x1000010c )
        if ( {address[RG:PAD3],{PAD3{1'b0}}} == 30'h10000108 ) begin
            src_channel = 35'b00000000000000000000000000000001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
        end

        // ( 0x1000010c .. 0x10000110 )
        if ( {address[RG:PAD4],{PAD4{1'b0}}} == 30'h1000010c ) begin
            src_channel = 35'b00000000000000000000000000000010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
        end

        // ( 0x10000200 .. 0x10000204 )
        if ( {address[RG:PAD5],{PAD5{1'b0}}} == 30'h10000200 ) begin
            src_channel = 35'b00000000000000000000000000000100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 5;
        end

        // ( 0x20000000 .. 0x20000080 )
        if ( {address[RG:PAD6],{PAD6{1'b0}}} == 30'h20000000 ) begin
            src_channel = 35'b00000000000000000000000000001000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
        end

        // ( 0x20000080 .. 0x20000100 )
        if ( {address[RG:PAD7],{PAD7{1'b0}}} == 30'h20000080 ) begin
            src_channel = 35'b00000000000000000000000000010000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
        end

        // ( 0x20000100 .. 0x20000120 )
        if ( {address[RG:PAD8],{PAD8{1'b0}}} == 30'h20000100 ) begin
            src_channel = 35'b00000000000000000000000000100000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 8;
        end

        // ( 0x20000120 .. 0x20000140 )
        if ( {address[RG:PAD9],{PAD9{1'b0}}} == 30'h20000120 ) begin
            src_channel = 35'b00000000000000000000000001000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 9;
        end

        // ( 0x20000140 .. 0x20000160 )
        if ( {address[RG:PAD10],{PAD10{1'b0}}} == 30'h20000140 ) begin
            src_channel = 35'b00000000000000000000000010000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 10;
        end

        // ( 0x20000160 .. 0x20000180 )
        if ( {address[RG:PAD11],{PAD11{1'b0}}} == 30'h20000160 ) begin
            src_channel = 35'b00000000000000000000000100000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 11;
        end

        // ( 0x20000180 .. 0x200001a0 )
        if ( {address[RG:PAD12],{PAD12{1'b0}}} == 30'h20000180 ) begin
            src_channel = 35'b00000000000000000000001000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 12;
        end

        // ( 0x200001a0 .. 0x200001c0 )
        if ( {address[RG:PAD13],{PAD13{1'b0}}} == 30'h200001a0 ) begin
            src_channel = 35'b00000000000000000000010000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 13;
        end

        // ( 0x200001c0 .. 0x200001e0 )
        if ( {address[RG:PAD14],{PAD14{1'b0}}} == 30'h200001c0 ) begin
            src_channel = 35'b00000000000000000000100000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 14;
        end

        // ( 0x200001e0 .. 0x20000200 )
        if ( {address[RG:PAD15],{PAD15{1'b0}}} == 30'h200001e0 ) begin
            src_channel = 35'b00000000000000000001000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 15;
        end

        // ( 0x20000200 .. 0x20000220 )
        if ( {address[RG:PAD16],{PAD16{1'b0}}} == 30'h20000200 ) begin
            src_channel = 35'b00000000000000000010000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 16;
        end

        // ( 0x20000220 .. 0x20000240 )
        if ( {address[RG:PAD17],{PAD17{1'b0}}} == 30'h20000220 ) begin
            src_channel = 35'b00000000000000000100000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 17;
        end

        // ( 0x20000240 .. 0x20000260 )
        if ( {address[RG:PAD18],{PAD18{1'b0}}} == 30'h20000240 ) begin
            src_channel = 35'b00000000000000001000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 18;
        end

        // ( 0x20000260 .. 0x20000280 )
        if ( {address[RG:PAD19],{PAD19{1'b0}}} == 30'h20000260 ) begin
            src_channel = 35'b00000000000000010000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 19;
        end

        // ( 0x20000280 .. 0x200002a0 )
        if ( {address[RG:PAD20],{PAD20{1'b0}}} == 30'h20000280 ) begin
            src_channel = 35'b00000000000000100000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 20;
        end

        // ( 0x200002a0 .. 0x200002c0 )
        if ( {address[RG:PAD21],{PAD21{1'b0}}} == 30'h200002a0 ) begin
            src_channel = 35'b00000000000001000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 21;
        end

        // ( 0x200002c0 .. 0x200002e0 )
        if ( {address[RG:PAD22],{PAD22{1'b0}}} == 30'h200002c0 ) begin
            src_channel = 35'b00000000000010000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 22;
        end

        // ( 0x200002e0 .. 0x20000300 )
        if ( {address[RG:PAD23],{PAD23{1'b0}}} == 30'h200002e0 ) begin
            src_channel = 35'b00000000000100000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 23;
        end

        // ( 0x20000300 .. 0x20000320 )
        if ( {address[RG:PAD24],{PAD24{1'b0}}} == 30'h20000300 ) begin
            src_channel = 35'b00000000001000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 24;
        end

        // ( 0x20000320 .. 0x20000340 )
        if ( {address[RG:PAD25],{PAD25{1'b0}}} == 30'h20000320 ) begin
            src_channel = 35'b00000000010000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 25;
        end

        // ( 0x20000340 .. 0x20000360 )
        if ( {address[RG:PAD26],{PAD26{1'b0}}} == 30'h20000340 ) begin
            src_channel = 35'b00000000100000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 26;
        end

        // ( 0x20000360 .. 0x20000380 )
        if ( {address[RG:PAD27],{PAD27{1'b0}}} == 30'h20000360 ) begin
            src_channel = 35'b00000001000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 27;
        end

        // ( 0x20000380 .. 0x200003a0 )
        if ( {address[RG:PAD28],{PAD28{1'b0}}} == 30'h20000380 ) begin
            src_channel = 35'b00000010000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 28;
        end

        // ( 0x200003a0 .. 0x200003c0 )
        if ( {address[RG:PAD29],{PAD29{1'b0}}} == 30'h200003a0 ) begin
            src_channel = 35'b00000100000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 29;
        end

        // ( 0x200003c0 .. 0x200003e0 )
        if ( {address[RG:PAD30],{PAD30{1'b0}}} == 30'h200003c0 ) begin
            src_channel = 35'b00001000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 30;
        end

        // ( 0x200003e0 .. 0x20000400 )
        if ( {address[RG:PAD31],{PAD31{1'b0}}} == 30'h200003e0 ) begin
            src_channel = 35'b00010000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 31;
        end

        // ( 0x20000400 .. 0x20000420 )
        if ( {address[RG:PAD32],{PAD32{1'b0}}} == 30'h20000400 ) begin
            src_channel = 35'b00100000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 32;
        end

        // ( 0x20000420 .. 0x20000440 )
        if ( {address[RG:PAD33],{PAD33{1'b0}}} == 30'h20000420 ) begin
            src_channel = 35'b01000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 33;
        end

        // ( 0x20000440 .. 0x20000450 )
        if ( {address[RG:PAD34],{PAD34{1'b0}}} == 30'h20000440 ) begin
            src_channel = 35'b10000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 34;
        end

end


    // --------------------------------------------------
    // Ceil(log2()) function
    // --------------------------------------------------
    function integer log2ceil;
        input reg[65:0] val;
        reg [65:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

endmodule


