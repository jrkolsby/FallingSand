module sand_update(input logic clk,
		input logic reset,
		input logic scene_addr,
		input logic [1:0] self_t
		input logic [1:0] topL_t,
		input logic [1:0] topR_t,
		input logic [1:0] top_t,
		input logic [1:0] left_t,
		input logic [1:0] right_t,
		input logic [1:0] bottom_t,
		input logic [1:0] bottomL_t,
		input logic [1:0] bottomR_t,
		output logic [1:0] new_x
	    );
    
    logic [7:0] hcount;
    logic [7:0] vcount;

    always_ff @(posedge clk) begin
	logic addr = scene_addr + hcount * 
	
    end



