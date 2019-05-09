module sand_update(
	input logic clock,
	input logic reset,
	output logic [22:0] address,
	output logic read,
	output logic write,
	input logic waitrequest,
	input logic [7:0] readdata,
	output logic [7:0] writedata
    );
    
    logic [7:0] hcount;
    logic [7:0] vcount;

    logic [17:0] particle_kernel;

/*
    always_ff @(posedge clk) begin
	logic addr = scene_addr
    end
*/

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




