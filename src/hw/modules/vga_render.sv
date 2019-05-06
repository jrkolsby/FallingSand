/*
 * Avalon memory-mapped peripheral that renders to VGA
 *
 * Stephen A. Edwards
 * Columbia University
 */

module vga_render(input logic clk,
		input logic reset,
		output logic [7:0] VGA_R, VGA_G, VGA_B,
		output logic VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_n,
		output logic VGA_SYNC_n);

   logic [10:0]	hcount;
   logic [9:0] vcount;
	
   /* This sets hcount and vcount */
   vga_counters counters(.clk50(clk), .*);

   always_comb begin
      {VGA_R, VGA_G, VGA_B} = {8'h0, 8'h0, 8'h0};
      if (VGA_BLANK_n )
	if ((hcount[10:3] >= (ball_x-3) && (ball_x+3) >= hcount[10:3] 
		&& vcount[9:2] >= (ball_y-3) && (ball_y+3) >= vcount[9:2])
		|| (hcount[10:3] >= (ball_x-1) && (ball_x+1) >= hcount[10:3]
		&& vcount[9:2] >= (ball_y-4) && (ball_y+4) >= vcount[9:2])
                || (hcount[10:3] >= (ball_x-4) && (ball_x+4) >= hcount[10:3]
                && vcount[9:2] >= (ball_y-1) && (ball_y+1) >= vcount[9:2])) 
	  {VGA_R, VGA_G, VGA_B} = {8'h16, 8'h37, 8'h92};
	else
	  {VGA_R, VGA_G, VGA_B} =
             {background_r, background_g, background_b};
   end
	       
endmodule

module vga_counters(
 input logic 	     clk50, reset,
 output logic [10:0] hcount,  // hcount[10:1] is pixel column
 output logic [9:0]  vcount,  // vcount[9:0] is pixel row
 output logic 	     VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_n, VGA_SYNC_n);

/*
 * 640 X 480 VGA timing for a 50 MHz clock: one pixel every other cycle
 * 
 * HCOUNT 1599 0             1279       1599 0
 *             _______________              ________
 * ___________|    Video      |____________|  Video
 * 
 * 
 * |SYNC| BP |<-- HACTIVE -->|FP|SYNC| BP |<-- HACTIVE
 *       _______________________      _____________
 * |____|       VGA_HS          |____|
 * 
 *
1080 VGA PARAMETERS

Name        1920x1080p60 
Standard      SMPTE 274M
VIC                   16
Short Name         1080p
Aspect Ratio        16:9

Pixel Clock        148.5 MHz
TMDS Clock       1,485.0 MHz
Pixel Time           6.7 ns ±0.5%
Horizontal Freq.  67.500 kHz
Line Time           14.8 μs
Vertical Freq.    60.000 Hz
Frame Time          16.7 ms

Horizontal Timings
Active Pixels       1920
Front Porch           88
Sync Width            44
Back Porch           148
Blanking Total       280
Total Pixels        2200
Sync Polarity        pos

Vertical Timings
Active Lines        1080
Front Porch            4
Sync Width             5
Back Porch            36
Blanking Total        45
Total Lines         1125
Sync Polarity        pos

Active Pixels  2,073,600
Data Rate           3.56 Gbps

Frame Memory (Kbits)
 8-bit Memory     16,200
12-bit Memory     24,300
24-bit Memory     48,600
32-bit Memory     64,800
 */
   // Parameters for hcount
   parameter HACTIVE      = 11'd 1280,
             HFRONT_PORCH = 11'd 32,
             HSYNC        = 11'd 192,
             HBACK_PORCH  = 11'd 96,   
             HTOTAL       = HACTIVE + HFRONT_PORCH + HSYNC +
                            HBACK_PORCH; // 1600
   
   // Parameters for vcount
   parameter VACTIVE      = 10'd 480,
             VFRONT_PORCH = 10'd 10,
             VSYNC        = 10'd 2,
             VBACK_PORCH  = 10'd 33,
             VTOTAL       = VACTIVE + VFRONT_PORCH + VSYNC +
                            VBACK_PORCH; // 525

   logic endOfLine;
   
   always_ff @(posedge clk50 or posedge reset)
     if (reset)          hcount <= 0;
     else if (endOfLine) hcount <= 0;
     else  	         hcount <= hcount + 11'd 1;

   assign endOfLine = hcount == HTOTAL - 1;
       
   logic endOfField;
   
   always_ff @(posedge clk50 or posedge reset)
     if (reset)          vcount <= 0;
     else if (endOfLine)
       if (endOfField)   vcount <= 0;
       else              vcount <= vcount + 10'd 1;

   assign endOfField = vcount == VTOTAL - 1;

   // Horizontal sync: from 0x520 to 0x5DF (0x57F)
   // 101 0010 0000 to 101 1101 1111
   assign VGA_HS = !( (hcount[10:8] == 3'b101) &
		      !(hcount[7:5] == 3'b111));
   assign VGA_VS = !( vcount[9:1] == (VACTIVE + VFRONT_PORCH) / 2);

   assign VGA_SYNC_n = 1'b0; // For putting sync on the green signal; unused
   
   // Horizontal active: 0 to 1279     Vertical active: 0 to 479
   // 101 0000 0000  1280	       01 1110 0000  480
   // 110 0011 1111  1599	       10 0000 1100  524
   assign VGA_BLANK_n = !( hcount[10] & (hcount[9] | hcount[8]) ) &
			!( vcount[9] | (vcount[8:5] == 4'b1111) );

   /* VGA_CLK is 25 MHz
    *             __    __    __
    * clk50    __|  |__|  |__|
    *        
    *             _____       __
    * hcount[0]__|     |_____|
    */
   assign VGA_CLK = hcount[0]; // 25 MHz clock: rising edge sensitive
   
endmodule
