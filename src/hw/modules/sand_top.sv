module sand_top(
	input logic reset,
	input logic clock,

	// SLAVE TO HPS
	input kernel_chipselect,		// chipselect
	input logic kernel_write, 		// action enable
	input logic [2:0] kernel_address 	// action type
	input logic [7:0] kernel_writedata,	// action payload

	output logic [31:0] screen_buffer_a_ptr,
	output logic [31:0] screen_buffer_b_ptr,
	output logic [7:0] write_x, write_y, write_radius,
);

    logic [7:0] write_x, write_y, write_radius;
    logic [1:0] write_type;

    logic [31:0] screen_buffer_a_ptr;
    logic [31:0] screen_buffer_b_ptr;

    always_ff @(posedge clock) begin
	// RESET
	if (reset) begin
	    write_x <= 8'h0;
	    write_y <= 8'h0;
	    write_radius <= 8'h0;
	    write_type <= 2'h0;

	// HPS SLAVE WRITE
	end else if (kernel_chipselect && kernel_write)
	    case (kernel_address)
		3'b000 : write_x <= kernel_writedata;
		3'b001 : write_y <= kernel_writedata;
		3'b010 : write_radius <= kernel_writedata;
		3'b011 : write_type <= kernel_writedata[2:0];
	    endcase
    end

endmodule
