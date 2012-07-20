// (C) 2001-2012 Altera Corporation. All rights reserved.
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


// $Id: //acds/rel/11.1sp2/ip/merlin/altera_merlin_router/altera_merlin_router.sv.terp#1 $
// $Revision: #1 $
// $Date: 2011/11/10 $
// $Author: max $

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
     parameter DEFAULT_CHANNEL = 0,
               DEFAULT_DESTID = 0 
   )
  (output [91 - 86 : 0] default_destination_id,
   output [58-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[91 - 86 : 0];
  generate begin : default_decode
    if (DEFAULT_CHANNEL == -1)
      assign default_src_channel = '0;
    else
      assign default_src_channel = 58'b1 << DEFAULT_CHANNEL;
  end endgenerate

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
    input  [93-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [93-1    : 0] src_data,
    output reg [58-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 67;
    localparam PKT_ADDR_L = 36;
    localparam PKT_DEST_ID_H = 91;
    localparam PKT_DEST_ID_L = 86;
    localparam ST_DATA_W = 93;
    localparam ST_CHANNEL_W = 58;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 70;
    localparam PKT_TRANS_READ  = 71;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;




    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    localparam PAD0 = log2ceil(32'h10000004 - 32'h10000000);
    localparam PAD1 = log2ceil(32'h10000014 - 32'h10000010);
    localparam PAD2 = log2ceil(32'h10000018 - 32'h10000014);
    localparam PAD3 = log2ceil(32'h1000001c - 32'h10000018);
    localparam PAD4 = log2ceil(32'h10000020 - 32'h1000001c);
    localparam PAD5 = log2ceil(32'h10001004 - 32'h10001000);
    localparam PAD6 = log2ceil(32'h10002001 - 32'h10002000);
    localparam PAD7 = log2ceil(32'h10002002 - 32'h10002001);
    localparam PAD8 = log2ceil(32'h10002003 - 32'h10002002);
    localparam PAD9 = log2ceil(32'h10002004 - 32'h10002003);
    localparam PAD10 = log2ceil(32'h10002005 - 32'h10002004);
    localparam PAD11 = log2ceil(32'h10002006 - 32'h10002005);
    localparam PAD12 = log2ceil(32'h10002007 - 32'h10002006);
    localparam PAD13 = log2ceil(32'h10002008 - 32'h10002007);
    localparam PAD14 = log2ceil(32'h10002009 - 32'h10002008);
    localparam PAD15 = log2ceil(32'h1000200a - 32'h10002009);
    localparam PAD16 = log2ceil(32'h1000200b - 32'h1000200a);
    localparam PAD17 = log2ceil(32'h1000200c - 32'h1000200b);
    localparam PAD18 = log2ceil(32'h1000200d - 32'h1000200c);
    localparam PAD19 = log2ceil(32'h1000200e - 32'h1000200d);
    localparam PAD20 = log2ceil(32'h1000200f - 32'h1000200e);
    localparam PAD21 = log2ceil(32'h10002010 - 32'h1000200f);
    localparam PAD22 = log2ceil(32'h10002011 - 32'h10002010);
    localparam PAD23 = log2ceil(32'h10002012 - 32'h10002011);
    localparam PAD24 = log2ceil(32'h10002013 - 32'h10002012);
    localparam PAD25 = log2ceil(32'h10002014 - 32'h10002013);
    localparam PAD26 = log2ceil(32'h10002015 - 32'h10002014);
    localparam PAD27 = log2ceil(32'h10002016 - 32'h10002015);
    localparam PAD28 = log2ceil(32'h10002017 - 32'h10002016);
    localparam PAD29 = log2ceil(32'h10002018 - 32'h10002017);
    localparam PAD30 = log2ceil(32'h10002019 - 32'h10002018);
    localparam PAD31 = log2ceil(32'h1000201a - 32'h10002019);
    localparam PAD32 = log2ceil(32'h10002021 - 32'h10002020);
    localparam PAD33 = log2ceil(32'h10002022 - 32'h10002021);
    localparam PAD34 = log2ceil(32'h10002023 - 32'h10002022);
    localparam PAD35 = log2ceil(32'h10002024 - 32'h10002023);
    localparam PAD36 = log2ceil(32'h10002025 - 32'h10002024);
    localparam PAD37 = log2ceil(32'h10002026 - 32'h10002025);
    localparam PAD38 = log2ceil(32'h10002027 - 32'h10002026);
    localparam PAD39 = log2ceil(32'h10002028 - 32'h10002027);
    localparam PAD40 = log2ceil(32'h10002029 - 32'h10002028);
    localparam PAD41 = log2ceil(32'h1000202a - 32'h10002029);
    localparam PAD42 = log2ceil(32'h1000202b - 32'h1000202a);
    localparam PAD43 = log2ceil(32'h1000202c - 32'h1000202b);
    localparam PAD44 = log2ceil(32'h1000202d - 32'h1000202c);
    localparam PAD45 = log2ceil(32'h1000202e - 32'h1000202d);
    localparam PAD46 = log2ceil(32'h1000202f - 32'h1000202e);
    localparam PAD47 = log2ceil(32'h10002030 - 32'h1000202f);
    localparam PAD48 = log2ceil(32'h10002031 - 32'h10002030);
    localparam PAD49 = log2ceil(32'h10002032 - 32'h10002031);
    localparam PAD50 = log2ceil(32'h10002033 - 32'h10002032);
    localparam PAD51 = log2ceil(32'h10002034 - 32'h10002033);
    localparam PAD52 = log2ceil(32'h10002035 - 32'h10002034);
    localparam PAD53 = log2ceil(32'h10002036 - 32'h10002035);
    localparam PAD54 = log2ceil(32'h10002037 - 32'h10002036);
    localparam PAD55 = log2ceil(32'h10002038 - 32'h10002037);
    localparam PAD56 = log2ceil(32'h10002039 - 32'h10002038);
    localparam PAD57 = log2ceil(32'h1000203a - 32'h10002039);

    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 32'h1000203a;
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
    wire [58-1 : 0] default_src_channel;




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

        // ( 0x10000000 .. 0x10000004 )
        if ( {address[RG:PAD0],{PAD0{1'b0}}} == 'h10000000 ) begin
            src_channel = 58'b0000000000000000000000000000000000000000000000000000000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
        end

        // ( 0x10000010 .. 0x10000014 )
        if ( {address[RG:PAD1],{PAD1{1'b0}}} == 'h10000010 ) begin
            src_channel = 58'b0000000000000000000000000000000000000000000000000000000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
        end

        // ( 0x10000014 .. 0x10000018 )
        if ( {address[RG:PAD2],{PAD2{1'b0}}} == 'h10000014 ) begin
            src_channel = 58'b0000000000000000000000000000000000000000000000000000000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
        end

        // ( 0x10000018 .. 0x1000001c )
        if ( {address[RG:PAD3],{PAD3{1'b0}}} == 'h10000018 ) begin
            src_channel = 58'b0000000000000000000000000000000000000000000000000000001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
        end

        // ( 0x1000001c .. 0x10000020 )
        if ( {address[RG:PAD4],{PAD4{1'b0}}} == 'h1000001c ) begin
            src_channel = 58'b0000000000000000000000000000000000000000000000000000010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
        end

        // ( 0x10001000 .. 0x10001004 )
        if ( {address[RG:PAD5],{PAD5{1'b0}}} == 'h10001000 ) begin
            src_channel = 58'b0000000000000000000000000000000000000000000000000000100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 5;
        end

        // ( 0x10002000 .. 0x10002001 )
        if ( {address[RG:PAD6],{PAD6{1'b0}}} == 'h10002000 ) begin
            src_channel = 58'b0000000000000000000000000000000000000000000000000001000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
        end

        // ( 0x10002001 .. 0x10002002 )
        if ( {address[RG:PAD7],{PAD7{1'b0}}} == 'h10002001 ) begin
            src_channel = 58'b0000000000000000000000000000000000000000000000000010000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
        end

        // ( 0x10002002 .. 0x10002003 )
        if ( {address[RG:PAD8],{PAD8{1'b0}}} == 'h10002002 ) begin
            src_channel = 58'b0000000000000000000000000000000000000000000000000100000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 8;
        end

        // ( 0x10002003 .. 0x10002004 )
        if ( {address[RG:PAD9],{PAD9{1'b0}}} == 'h10002003 ) begin
            src_channel = 58'b0000000000000000000000000000000000000000000000001000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 9;
        end

        // ( 0x10002004 .. 0x10002005 )
        if ( {address[RG:PAD10],{PAD10{1'b0}}} == 'h10002004 ) begin
            src_channel = 58'b0000000000000000000000000000000000000000000000010000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 10;
        end

        // ( 0x10002005 .. 0x10002006 )
        if ( {address[RG:PAD11],{PAD11{1'b0}}} == 'h10002005 ) begin
            src_channel = 58'b0000000000000000000000000000000000000000000000100000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 11;
        end

        // ( 0x10002006 .. 0x10002007 )
        if ( {address[RG:PAD12],{PAD12{1'b0}}} == 'h10002006 ) begin
            src_channel = 58'b0000000000000000000000000000000000000000000001000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 12;
        end

        // ( 0x10002007 .. 0x10002008 )
        if ( {address[RG:PAD13],{PAD13{1'b0}}} == 'h10002007 ) begin
            src_channel = 58'b0000000000000000000000000000000000000000000010000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 13;
        end

        // ( 0x10002008 .. 0x10002009 )
        if ( {address[RG:PAD14],{PAD14{1'b0}}} == 'h10002008 ) begin
            src_channel = 58'b0000000000000000000000000000000000000000000100000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 14;
        end

        // ( 0x10002009 .. 0x1000200a )
        if ( {address[RG:PAD15],{PAD15{1'b0}}} == 'h10002009 ) begin
            src_channel = 58'b0000000000000000000000000000000000000000001000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 15;
        end

        // ( 0x1000200a .. 0x1000200b )
        if ( {address[RG:PAD16],{PAD16{1'b0}}} == 'h1000200a ) begin
            src_channel = 58'b0000000000000000000000000000000000000000010000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 16;
        end

        // ( 0x1000200b .. 0x1000200c )
        if ( {address[RG:PAD17],{PAD17{1'b0}}} == 'h1000200b ) begin
            src_channel = 58'b0000000000000000000000000000000000000000100000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 17;
        end

        // ( 0x1000200c .. 0x1000200d )
        if ( {address[RG:PAD18],{PAD18{1'b0}}} == 'h1000200c ) begin
            src_channel = 58'b0000000000000000000000000000000000000010000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 19;
        end

        // ( 0x1000200d .. 0x1000200e )
        if ( {address[RG:PAD19],{PAD19{1'b0}}} == 'h1000200d ) begin
            src_channel = 58'b0000000000000000000000000000000000000001000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 18;
        end

        // ( 0x1000200e .. 0x1000200f )
        if ( {address[RG:PAD20],{PAD20{1'b0}}} == 'h1000200e ) begin
            src_channel = 58'b0000000000000000000000000000000000000100000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 20;
        end

        // ( 0x1000200f .. 0x10002010 )
        if ( {address[RG:PAD21],{PAD21{1'b0}}} == 'h1000200f ) begin
            src_channel = 58'b0000000000000000000000000000000000001000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 21;
        end

        // ( 0x10002010 .. 0x10002011 )
        if ( {address[RG:PAD22],{PAD22{1'b0}}} == 'h10002010 ) begin
            src_channel = 58'b0000000000000000000000000000000000100000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 23;
        end

        // ( 0x10002011 .. 0x10002012 )
        if ( {address[RG:PAD23],{PAD23{1'b0}}} == 'h10002011 ) begin
            src_channel = 58'b0000000000000000000000000000000000010000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 22;
        end

        // ( 0x10002012 .. 0x10002013 )
        if ( {address[RG:PAD24],{PAD24{1'b0}}} == 'h10002012 ) begin
            src_channel = 58'b0000000000000000000000000000000001000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 24;
        end

        // ( 0x10002013 .. 0x10002014 )
        if ( {address[RG:PAD25],{PAD25{1'b0}}} == 'h10002013 ) begin
            src_channel = 58'b0000000000000000000000000000000010000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 25;
        end

        // ( 0x10002014 .. 0x10002015 )
        if ( {address[RG:PAD26],{PAD26{1'b0}}} == 'h10002014 ) begin
            src_channel = 58'b0000000000000000000000000000000100000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 26;
        end

        // ( 0x10002015 .. 0x10002016 )
        if ( {address[RG:PAD27],{PAD27{1'b0}}} == 'h10002015 ) begin
            src_channel = 58'b0000000000000000000000000000001000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 27;
        end

        // ( 0x10002016 .. 0x10002017 )
        if ( {address[RG:PAD28],{PAD28{1'b0}}} == 'h10002016 ) begin
            src_channel = 58'b0000000000000000000000000000010000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 28;
        end

        // ( 0x10002017 .. 0x10002018 )
        if ( {address[RG:PAD29],{PAD29{1'b0}}} == 'h10002017 ) begin
            src_channel = 58'b0000000000000000000000000000100000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 29;
        end

        // ( 0x10002018 .. 0x10002019 )
        if ( {address[RG:PAD30],{PAD30{1'b0}}} == 'h10002018 ) begin
            src_channel = 58'b0000000000000000000000000001000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 30;
        end

        // ( 0x10002019 .. 0x1000201a )
        if ( {address[RG:PAD31],{PAD31{1'b0}}} == 'h10002019 ) begin
            src_channel = 58'b0000000000000000000000000010000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 31;
        end

        // ( 0x10002020 .. 0x10002021 )
        if ( {address[RG:PAD32],{PAD32{1'b0}}} == 'h10002020 ) begin
            src_channel = 58'b0000000000000000000000000100000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 32;
        end

        // ( 0x10002021 .. 0x10002022 )
        if ( {address[RG:PAD33],{PAD33{1'b0}}} == 'h10002021 ) begin
            src_channel = 58'b0000000000000000000000001000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 33;
        end

        // ( 0x10002022 .. 0x10002023 )
        if ( {address[RG:PAD34],{PAD34{1'b0}}} == 'h10002022 ) begin
            src_channel = 58'b0000000000000000000000010000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 34;
        end

        // ( 0x10002023 .. 0x10002024 )
        if ( {address[RG:PAD35],{PAD35{1'b0}}} == 'h10002023 ) begin
            src_channel = 58'b0000000000000000000000100000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 35;
        end

        // ( 0x10002024 .. 0x10002025 )
        if ( {address[RG:PAD36],{PAD36{1'b0}}} == 'h10002024 ) begin
            src_channel = 58'b0000000000000000000001000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 36;
        end

        // ( 0x10002025 .. 0x10002026 )
        if ( {address[RG:PAD37],{PAD37{1'b0}}} == 'h10002025 ) begin
            src_channel = 58'b0000000000000000000100000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 38;
        end

        // ( 0x10002026 .. 0x10002027 )
        if ( {address[RG:PAD38],{PAD38{1'b0}}} == 'h10002026 ) begin
            src_channel = 58'b0000000000000000000010000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 37;
        end

        // ( 0x10002027 .. 0x10002028 )
        if ( {address[RG:PAD39],{PAD39{1'b0}}} == 'h10002027 ) begin
            src_channel = 58'b0000000000000000001000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 39;
        end

        // ( 0x10002028 .. 0x10002029 )
        if ( {address[RG:PAD40],{PAD40{1'b0}}} == 'h10002028 ) begin
            src_channel = 58'b0000000000000000010000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 40;
        end

        // ( 0x10002029 .. 0x1000202a )
        if ( {address[RG:PAD41],{PAD41{1'b0}}} == 'h10002029 ) begin
            src_channel = 58'b0000000000000000100000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 41;
        end

        // ( 0x1000202a .. 0x1000202b )
        if ( {address[RG:PAD42],{PAD42{1'b0}}} == 'h1000202a ) begin
            src_channel = 58'b0000000000000001000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 42;
        end

        // ( 0x1000202b .. 0x1000202c )
        if ( {address[RG:PAD43],{PAD43{1'b0}}} == 'h1000202b ) begin
            src_channel = 58'b0000000000000010000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 43;
        end

        // ( 0x1000202c .. 0x1000202d )
        if ( {address[RG:PAD44],{PAD44{1'b0}}} == 'h1000202c ) begin
            src_channel = 58'b0000000000000100000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 44;
        end

        // ( 0x1000202d .. 0x1000202e )
        if ( {address[RG:PAD45],{PAD45{1'b0}}} == 'h1000202d ) begin
            src_channel = 58'b0000000000001000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 45;
        end

        // ( 0x1000202e .. 0x1000202f )
        if ( {address[RG:PAD46],{PAD46{1'b0}}} == 'h1000202e ) begin
            src_channel = 58'b0000000000010000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 46;
        end

        // ( 0x1000202f .. 0x10002030 )
        if ( {address[RG:PAD47],{PAD47{1'b0}}} == 'h1000202f ) begin
            src_channel = 58'b0000000000100000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 47;
        end

        // ( 0x10002030 .. 0x10002031 )
        if ( {address[RG:PAD48],{PAD48{1'b0}}} == 'h10002030 ) begin
            src_channel = 58'b0000000001000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 48;
        end

        // ( 0x10002031 .. 0x10002032 )
        if ( {address[RG:PAD49],{PAD49{1'b0}}} == 'h10002031 ) begin
            src_channel = 58'b0000000010000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 49;
        end

        // ( 0x10002032 .. 0x10002033 )
        if ( {address[RG:PAD50],{PAD50{1'b0}}} == 'h10002032 ) begin
            src_channel = 58'b0000000100000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 50;
        end

        // ( 0x10002033 .. 0x10002034 )
        if ( {address[RG:PAD51],{PAD51{1'b0}}} == 'h10002033 ) begin
            src_channel = 58'b0000001000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 51;
        end

        // ( 0x10002034 .. 0x10002035 )
        if ( {address[RG:PAD52],{PAD52{1'b0}}} == 'h10002034 ) begin
            src_channel = 58'b0000010000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 52;
        end

        // ( 0x10002035 .. 0x10002036 )
        if ( {address[RG:PAD53],{PAD53{1'b0}}} == 'h10002035 ) begin
            src_channel = 58'b0000100000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 53;
        end

        // ( 0x10002036 .. 0x10002037 )
        if ( {address[RG:PAD54],{PAD54{1'b0}}} == 'h10002036 ) begin
            src_channel = 58'b0001000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 54;
        end

        // ( 0x10002037 .. 0x10002038 )
        if ( {address[RG:PAD55],{PAD55{1'b0}}} == 'h10002037 ) begin
            src_channel = 58'b0010000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 55;
        end

        // ( 0x10002038 .. 0x10002039 )
        if ( {address[RG:PAD56],{PAD56{1'b0}}} == 'h10002038 ) begin
            src_channel = 58'b0100000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 56;
        end

        // ( 0x10002039 .. 0x1000203a )
        if ( {address[RG:PAD57],{PAD57{1'b0}}} == 'h10002039 ) begin
            src_channel = 58'b1000000000000000000000000000000000000000000000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 57;
        end
    end

    // --------------------------------------------------
    // Ceil(log2()) function
    // --------------------------------------------------
    function integer log2ceil;
        input reg[63:0] val;
        reg [63:0] i;

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


