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
	input logic [31:0] mem_readdata,

	// GLOBALS WIRE
	input logic [31:0] screen_buffer_a_ptr,
	input logic [31:0] screen_buffer_b_ptr,
	input logic [7:0] write_x, write_y, write_radius,
	
	// VGA WIRE
	output logic [7:0] VGA_R, VGA_G, VGA_B,
	output logic VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_n,
	output logic VGA_SYNC_n
    );

    parameter EMPTY_C	= 24'hFFFFFF,
	    SAND_C	= 24'h993300,   
	    WATER_C	= 24'h0000FF,   
	    WALL_C	= 24'h333333;

    logic [10:0] hcount;
    logic [9:0] vcount;

    logic [22:0] screen_ptr_b, screen_ptr_a;
    logic [7:0] write_x, write_y, write_t;

    logic [31:0] read_buf;

    logic screen_ptr;
    logic mem_reading;
    /*
     * BITMASK FOR INTERFACE STATUS
     *
     * 0 - waiting
     * 1 - reading/writing
     *
     */

    vga_counters counters(.clk50(clock), .*);

    assign logic [22:0] addr = hcount + vcount * 2

    always_ff @(posedge clock) begin

	// RESET DEFAULT VALUES
	if (reset) begin
	    mem_reading <= 2'b00;
	    top_waitrequest <= 1'b0;
	    mem_read <= 1'b0;
	    mem_address <=  24'h000000;

	// READ FROM SDRAM (8B)
	else if (mem_reading & mem_readdatavalid) begin
	    read_buf <= mem_readdata;
	    mem_reading <= 1'b0;

	// START NEW READ FROM SDRAM
	end else if (mem_waitrequest == 1'b0) begin
	    mem_reading <= mem_reading | 1'b1
	    mem_address <= hcount // TODO!
	    top_waitrequest <= 1'b1;

	end else if ()

    end

    always_comb begin
	// set outputs depending on hcount and vcount
	top_waitrequest = 
	mem_read = mem_reading == 1'b0
	mem_address = hcount 
	{VGA_R, VGA_G, VGA_B} = EMPTY_C;
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
 */
    // Parameters for hcount
    parameter HACTIVE      = 11'd1280,
	    HFRONT_PORCH = 11'd32,
	    HSYNC        = 11'd192,
	    HBACK_PORCH  = 11'd96,   
	    HTOTAL       = HACTIVE + HFRONT_PORCH + HSYNC +
			    HBACK_PORCH; // 1600
   
    // Parameters for vcount
    parameter VACTIVE      = 10'd480,
	    VFRONT_PORCH = 10'd10,
	    VSYNC        = 10'd2,
	    VBACK_PORCH  = 10'd33,
	    VTOTAL       = VACTIVE + VFRONT_PORCH + VSYNC +
            VBACK_PORCH; // 525

    logic endOfLine;
   
    always_ff @(posedge clk50 or posedge reset)
	if (reset) hcount <= 0;
	else if (endOfLine) hcount <= 0;
	else hcount <= hcount + 11'd1;

    assign endOfLine = hcount == HTOTAL - 1;
       
    logic endOfField;
   
    always_ff @(posedge clk50 or posedge reset)
	if (reset) vcount <= 0;
	else if (endOfLine)
	if (endOfField) vcount <= 0;
	else vcount <= vcount + 10'd1;

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
