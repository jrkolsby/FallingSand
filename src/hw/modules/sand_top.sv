/*
`include "vga_render.sv"
`include "sand_update.sv"
*/

module sand_top(
	input logic reset,
	input logic clock,

	// SLAVE TO HPS
	input kernel_chipselect,		// chipselect
	input logic kernel_write, 		// action enable
	input logic [2:0] kernel_address,	// action type
	input logic [15:0] kernel_writedata,	// action payload
	
	// SDRAM MASTER
	output logic [23:0] mem_address,
	output logic mem_read,
	output logic mem_write,
	input logic mem_waitrequest,
	input logic mem_readdatavalid,
	input logic [15:0] mem_readdata,
	output logic [15:0] mem_writedata,

	// VGA CONDUIT
	output logic [7:0] VGA_R, VGA_G, VGA_B,
	output logic VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_n,
	output logic VGA_SYNC_n
);

    logic [10:0] write_x;
    logic [9:0] write_y;
    logic [1:0] write_t;

    logic screen_select;

    logic [31:0] screen_a_ptr;
    logic [31:0] screen_b_ptr;

    logic [1:0] cacheselect;

    logic [1279:0] screen_a_cache;
    logic [1279:0] screen_b_cache;
    logic [1279:0] screen_c_cache;

    logic [23:0] render_address;
    logic [23:0] physics_address;

    logic render_flag;
    logic render_read;
    logic physics_read;

    // SUB MODULES
    vga_render render(
	.screen_ptr(screen_a_ptr), 
	.mem_address(render_address),
	.mem_read(render_read),
	.*
    );
    sand_update physics(
	.screen_ptr(screen_b_ptr),
	.mem_address(physics_address),
	.mem_read(physics_read),
	.*
    );


    /* It seems render_flag gets stuck at 1 */

    always_ff @(posedge clock) begin

	// RESET
	if (reset) begin
	    write_x <= 10'h0;
	    write_y <= 9'h0;
	    write_t <= 2'h0;
	    render_flag <= 1'b0;

	// NOT RESET
	end else begin

	    // VGA READ
	    if (render_read & render_flag == 0) begin
		render_flag <= 1'b1;

		mem_address <= render_address;
		mem_read <= 1'b1;

	    end else if (physics_read) begin
		render_flag <= 1'b0;

		mem_address <= physics_address;
		mem_read <= 1'b1;

	    // HPS SLAVE WRITE
	    end else if (kernel_chipselect && kernel_write)
		case (kernel_address)
		    3'h0 : write_x <= kernel_writedata[10:0];
		    3'h1 : write_y <= kernel_writedata[9:0];
		    3'h2 : write_t <= kernel_writedata[1:0];
		endcase
	end 
    end

endmodule
