module sand_top(
	input logic reset,
	input logic clock,

	// SLAVE TO HPS
	input kernel_chipselect,		// chipselect
	input logic kernel_write, 		// action enable
	input logic [2:0] kernel_address 	// action type
	input logic [7:0] kernel_writedata,	// action payload

	// GLOBALS
	output logic [31:0] screen_a_ptr,
	output logic [31:0] screen_b_ptr,
	output logic [31:0] screen_c_ptr,

	output logic [10:0] write_x,
	output logic [9:0] write_y, 
	output logic [1:0] write_t, 
	output logic [1:0] write_radius,
);

    logic [7:0] write_x, write_y, write_radius;
    logic [1:0] write_t;

    logic screen_select;
    logic [31:0] screen_a_ptr;
    logic [31:0] screen_b_ptr;

    logic [1:0] cacheselect;
    wire [1279:0] screen_a_cache;
    wire [1279:0] screen_b_cache;
    wire [1279:0] screen_c_cache;

    always_ff @(posedge clock) begin
	// RESET
	if (reset) begin
	    write_x <= 10'h0;
	    write_y <= 9'h0;
	    write_t <= 2'h0;
	    write_radius <= 2'h0;

	// HPS SLAVE WRITE
	end else if (kernel_chipselect && kernel_write)
	    case (kernel_address)
		3'h0 : write_x <= kernel_writedata[10:0];
		3'h1 : write_y <= kernel_writedata[9:0];
		3'h2 : write_radius <= kernel_writedata[2:0];
		3'h3 : write_t <= kernel_writedata[2:0];
	    endcase
	else if 
    end

endmodule
