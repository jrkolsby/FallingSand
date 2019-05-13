/*
 * Avalon master module that reads from SDRAM and writes to VGA
 *
 * Stephen A. Edwards
 * Columbia University
 */

module vga_render(
	input logic clock,
	input logic reset,

	// SDRAM MASTER (4B)
	output logic [23:0] mem_address,
	output logic mem_read,
	input logic mem_waitrequest,
	input logic mem_readdatavalid,
	input logic [31:0] mem_readdata,

	// GLOBALS WIRE
	input logic [31:0] screen_a_ptr,
	input logic [31:0] screen_b_ptr,
	input logic [10:0] write_x,
	input logic [9:0] write_y, 
	input logic [1:0] write_t,
	input logic [1:0] write_radius,
	
	// VGA WIRE
	output logic [7:0] VGA_R, VGA_G, VGA_B,
	output logic VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_n,
	output logic VGA_SYNC_n
    );

    parameter EMPTY_C	= 24'hFFFFFF,
	    SAND_C	= 24'h993300,   
	    WATER_C	= 24'h0000FF,   
	    WALL_C	= 24'h333333;

    logic [15:0] read_buf;

    logic screen_toggle;	// 1 if screen_a_ptr
    logic mem_reading;		// 1 if waiting
    logic [16:0] mem_block;	// which block are we on?
    logic [10:0] screen_x;	// current x of render
    logic [9:0] screen_y;	// current y of render

    // outputs screen_x, screen_y
    vga_counters counters(.clk50(clock), .*);

    always_ff @(posedge clock) begin

	// GET
	if (screen_x % 4 == 0)
	    mem_block <= mem_block + 17'd1;
	    
	// RESET DEFAULT VALUES
	if (reset) begin
	    mem_reading <= 1'b0;
	    mem_address <= 24'h000000;
	    mem_block <= 17'd0;

	// READ FROM SDRAM (2B)
	end else if (mem_reading & mem_readdatavalid) begin
	    read_buf <= mem_readdata;
	    mem_reading <= 1'b0;

	// START NEW READ FROM SDRAM
	end else if (mem_waitrequest == 1'b0) begin
	    mem_address <= mem_block;
	    mem_reading <= 1'b1;
	end
    end

    always_comb begin
	// set outputs depending on screen_x and screen_y
	mem_read = mem_reading == 1'b0;
	if (screen_x - write_x <= write_radius)
	    case (write_t)
		2'h0 : {VGA_R, VGA_G, VGA_B} = EMPTY_C;
		2'h1 : {VGA_R, VGA_G, VGA_B} = SAND_C;
		2'h2 : {VGA_R, VGA_G, VGA_B} = WATER_C;
		2'h3 : {VGA_R, VGA_G, VGA_B} = WALL_C;
	    endcase
	else 
	    {VGA_R, VGA_G, VGA_B} = {8'd0, 8'd0, read_buf[7:0]}; 
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
