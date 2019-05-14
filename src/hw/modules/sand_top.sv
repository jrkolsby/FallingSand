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
	input logic [1:0] mem_response,
	input logic mem_waitrequest,
	input logic mem_readdatavalid,
	input logic mem_writeresponsevalid,
	input logic [15:0] mem_readdata,
	output logic [15:0] mem_writedata,

	// VGA CONDUIT
	output logic [7:0] VGA_R, VGA_G, VGA_B,
	output logic VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_n,
	output logic VGA_SYNC_n
);

    parameter SPOUT = 1'b1;

    logic [10:0] write_x;
    logic [9:0] write_y;
    logic [1:0] write_t;

    logic [15:0] region_buffer_a;
    logic [15:0] region_buffer_b;
    logic [15:0] floor_buffer_a;
    logic [15:0] floor_buffer_b;

    logic [15:0] new_region_buffer_a;
    logic [15:0] new_region_buffer_b;
    logic [15:0] new_floor_buffer_a;
    logic [15:0] new_floor_buffer_b;

    logic [23:0] region_address_a; // NEED ONLY SET THIS
    logic [23:0] region_address_b;
    logic [23:0] floor_address_a;
    logic [23:0] floor_address_b;

    assign region_address_b = region_address_a + 24'd1;
    assign floor_address_a = region_address_a + 24'd80;
    assign floor_address_b = region_address_b + 24'd80;

    logic [5:0] state_counter;
    logic [4:0] buffer_counter;

    assign buffer_counter = state_counter / 2;
    
    logic [8:0] screen_x;
    logic [8:0] screen_y;

    logic screenend;	// End of column
    logic screenbegin;	// Beginning of column
    logic screenbottom; // Bottom of screen

    assign screenend = ((region_address_a + 2) % 80 == 0);
    assign screenbegin = (region_address_a % 80 == 0);
    assign screenbottom = (region_address_a > 24'd38320);

    // SUB MODULES
    vga_render render_0(
	.clock(clock),
	.reset(reset),

	.buffer({region_buffer_a, region_buffer_b}),
	
	.buffer_ptr(buffer_counter),

	.readdatavalid(mem_readdatavalid),
	.writeresponsevalid(mem_writeresponsevalid),

	.write_x(write_x),
	.write_y(write_y),
	.write_t(write_t),

	.screen_x(screen_x),
	.screen_y(screen_y),

	.VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B),
	.VGA_CLK(VGA_CLK), .VGA_HS(VGA_HS), .VGA_VS(VGA_VS),
	.VGA_BLANK_n(VGA_BLANK_n), .VGA_SYNC_n(VGA_SYNC_n)
    );

    sand_update update_0(
	.screenbottom(screenbottom),
	.screenbegin(screenbegin),
	.screenend(screenend),
	.spout(SPOUT),

	.region({region_buffer_a, region_buffer_b}), 
	.floor({floor_buffer_a, floor_buffer_b}),

	.new_region({new_region_buffer_a, new_region_buffer_b}),
	.new_floor({new_floor_buffer_a, new_floor_buffer_b})
    );

    always_ff @(posedge clock) begin

	// RESET
	if (reset) begin
	    state_counter <= 6'h0;
	    write_x <= 10'h0;
	    write_y <= 9'h0;
	    write_t <= 2'h0;
	    mem_write <= 1'b0;
	    mem_read <= 1'b0;
	    mem_writedata <= 16'h0;
	    region_address_a <= 24'h0;

	end else begin
	    case (state_counter)
		6'd0 : {mem_write, mem_read, mem_address} <=
		    {1'b0, 1'b1, region_address_a};

		6'd1 : {mem_read} <= {1'b0};

		6'd2 : {mem_read, mem_address, region_buffer_a} <=
		    {1'b1, region_address_b, mem_readdatavalid ? 
			mem_readdata : 16'h0000};

		6'd3 : {mem_read} <= {1'b0};

		6'd4 : {mem_read, mem_address, region_buffer_b} <=
		    {1'b1, floor_address_a, mem_readdatavalid ? 
			mem_readdata : 16'h0000};

		6'd5 : {mem_read} <= {1'b0};

		6'd6 : {mem_read, mem_address, floor_buffer_a} <=
		    {1'b1, floor_address_b, mem_readdatavalid ? 
			mem_readdata : 16'h0000};

		6'd7 : {mem_read} <= {1'b0};

		6'd8 : floor_buffer_b <= (mem_readdatavalid ? 
			mem_readdata : 16'h0000);

		6'd9 : {mem_write, mem_address, mem_writedata} <=
		    {1'b1, region_address_a, new_region_buffer_a};

		6'd10 : {mem_write} <= {1'b0};

		6'd11 : {mem_write, mem_address, mem_writedata} <=
		    {1'b1, region_address_b, new_region_buffer_b};

		6'd12 : {mem_write} <= {1'b0};

		6'd13 : {mem_write, mem_address, mem_writedata} <=
		    {1'b1, floor_address_a, new_floor_buffer_a};

		6'd14 : {mem_write} <= {1'b0};

		6'd15 : {mem_write, mem_address, mem_writedata} <=
		    {1'b1, floor_address_b, new_floor_buffer_b};

		6'd16 : {mem_write} <= {1'b0};

		6'd17 : {mem_address, mem_writedata} <=
		    {24'h0, 16'h0};

	    endcase

	    if (state_counter == 6'd31) begin
		state_counter <= 6'd0;
		region_address_a <= screenend ?
		    region_address_a + 24'h2 : region_address_a + 24'h1;
	    end else 
		state_counter <= state_counter + 6'd1;
	end
    end

endmodule
