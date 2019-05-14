module sand_update(
	input logic clock,
	input logic reset,

	input logic [31:0] screen_ptr,

	output logic [23:0] mem_address,
	output logic mem_read,
	output logic mem_write,
	input logic mem_waitrequest,
	input logic mem_readdatavalid,
	input logic [15:0] mem_readdata,
	output logic [15:0] mem_writedata,

	input logic [15:0] region,
	input logic [15:0] floor,
	output logic [15:0] new_region,
	output logic [15:0] new_floor
    );

    logic [16:0] write_block = 17'd0;

    always_ff @(posedge clock) begin
	if (mem_waitrequest == 1'b1) begin
	    mem_write <= 1'd0; 
	    write_block <= write_block + 17'd1;
	end else begin
	    mem_address <= write_block;
	    mem_write <= 1'd1;
	    mem_writedata <= 16'h2222;
	end
    end

endmodule

module check_region(
	input logic [1:0] self_t,
	input logic [1:0] topL_t,
	input logic [1:0] topR_t,
	input logic [1:0] top_t,
	input logic [1:0] left_t,
	input logic [1:0] right_t,
	input logic [1:0] bottom_t,
	input logic [1:0] bottomL_t,
	input logic [1:0] bottomR_t,
	output logic [1:0] dx,
	output logic [1:0] dy);

endmodule




