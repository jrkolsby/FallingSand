/*
 * Module that writes to VGA
 *
 * James Kolsby and Jeremy Adkins
 * Columbia University
 */

module vga_render(
	input logic clock,
	input logic reset,

	input logic [31:0] buffer,

	// WRITE STATE
	input logic [10:0] write_x,
	input logic [9:0] write_y, 
	input logic [1:0] write_t,

	output logic [6:0] screen_x,
	output logic [6:0] screen_y,
	
	// VGA CONDUIT
	output logic [7:0] VGA_R, VGA_G, VGA_B,
	output logic VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_n,
	output logic VGA_SYNC_n
    );

    parameter EMPTY_C	= 24'hFFFFFF,
	    SAND_C	= 24'h993300,   
	    WALL_C	= 24'h333333;

    logic [10:0] current_x;	// current x of render
    logic [9:0] current_y;	// current y of render

    assign screen_x = current_x[10:3];
    assign screen_y = current_y[9:2];

    // outputs screen_x, screen_y
    vga_counters counters(
	.clk50(clock), 
	.screen_x(current_x),
	.screen_y(current_y),
	.*);

    logic [1:0] buffer_index;
    assign buffer_index = screen_x % 4;

    always_comb begin

	// set outputs depending on screen_x and screen_y
	if (screen_x == write_x && screen_y == write_y)
	    case (write_t)
		2'h0 : {VGA_R, VGA_G, VGA_B} = EMPTY_C;
		2'h1 : {VGA_R, VGA_G, VGA_B} = SAND_C;
		2'h2 : {VGA_R, VGA_G, VGA_B} = SAND_C;
		2'h3 : {VGA_R, VGA_G, VGA_B} = WALL_C;
	    endcase
	else 
	    case (buffer[buffer_index])
		2'h0 : {VGA_R, VGA_G, VGA_B} = EMPTY_C;
		2'h1 : {VGA_R, VGA_G, VGA_B} = SAND_C;
		2'h2 : {VGA_R, VGA_G, VGA_B} = SAND_C;
		2'h3 : {VGA_R, VGA_G, VGA_B} = WALL_C;
	    endcase
    end

endmodule

module vga_counters(
    input logic clk50, reset,
    output logic [10:0] screen_x,  // screen_x[10:1] is pixel column
    output logic [9:0]  screen_y,  // screen_y[9:0] is pixel row
    output logic VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_n, VGA_SYNC_n);

/*
 * 640 X 480 VGA timing for a 50 MHz clock: one pixel every other cycle
 * 
 * SCREENX 1599 0             1279       1599 0
 *             _______________              ________
 * ___________|    Video      |____________|  Video
 * 
 * 
 * |SYNC| BP |<-- HACTIVE -->|FP|SYNC| BP |<-- HACTIVE
 *       _______________________      _____________
 * |____|       VGA_HS          |____|
 * 
 *
 */
    // Parameters for screen_x
    parameter HACTIVE      = 11'd1280,
	    HFRONT_PORCH = 11'd32,
	    HSYNC        = 11'd192,
	    HBACK_PORCH  = 11'd96,
	    HTOTAL       = HACTIVE + HFRONT_PORCH + HSYNC +
			    HBACK_PORCH; // 1600
   
    // Parameters for screen_y
    parameter VACTIVE      = 10'd480,
	    VFRONT_PORCH = 10'd10,
	    VSYNC        = 10'd2,
	    VBACK_PORCH  = 10'd33,
	    VTOTAL       = VACTIVE + VFRONT_PORCH + VSYNC +
            VBACK_PORCH; // 525

    logic end_of_line;
	 logic end_of_screen;
	 
    always_ff @(posedge clk50 or posedge reset)
	if (reset) screen_x <= 0;
	else if (end_of_line) screen_x <= 0;
	else screen_x <= screen_x + 11'd1;

    assign end_of_line = screen_x == HTOTAL - 1;
   
    always_ff @(posedge clk50 or posedge reset)
	if (reset) screen_y <= 0;
	else if (end_of_line)
	if (end_of_screen) screen_y <= 0;
	else screen_y <= screen_y + 10'd1;

   assign end_of_screen = screen_y == VTOTAL - 1;

   // Horizontal sync: from 0x520 to 0x5DF (0x57F)
   // 101 0010 0000 to 101 1101 1111
   assign VGA_HS = !( (screen_x[10:8] == 3'b101) &
		      !(screen_x[7:5] == 3'b111));
   assign VGA_VS = !( screen_y[9:1] == (VACTIVE + VFRONT_PORCH) / 2);

   assign VGA_SYNC_n = 1'b0; // For putting sync on the green signal; unused
   
   // Horizontal active: 0 to 1279     Vertical active: 0 to 479
   // 101 0000 0000  1280	       01 1110 0000  480
   // 110 0011 1111  1599	       10 0000 1100  524
   assign VGA_BLANK_n = !( screen_x[10] & (screen_x[9] | screen_x[8]) ) &
			!( screen_y[9] | (screen_y[8:5] == 4'b1111) );

   /* VGA_CLK is 25 MHz
    *               __    __    __
    * clk50      __|  |__|  |__|
    *        
    *               _____       __
    * screen_x[0]__|     |_____|
    */
   assign VGA_CLK = screen_x[0]; // 25 MHz clock: rising edge sensitive
   
endmodule
