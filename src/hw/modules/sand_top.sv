module sand_top(input logic  CLOCK_50,
		input [3:0]  KEY,
		input [12:0] DRAM_ADDR,
		input [1:0]  DRAM_BA,
		input        DRAM_CAS_N,
		input        DRAM_CKE,
		input        DRAM_CLK,
		input        DRAM_CS_N,
		inout [15:0]  DRAM_DQ,
		output        DRAM_LDQM,
		input        DRAM_RAS_N,
		input        DRAM_UDQM,
		input        DRAM_WE_N,
		input logic reset,
		input chipselect,
		input logic write_enable, // write_enable
		input logic [2:0] action , // action type
		input logic [7:0] payload,
		output logic error);

    logic [7:0] background_r, background_g, background_b;
    logic [7:0] write_x, write_y, write_radius;
    logic [1:0] write_type;

    logic [17:0] kernel_buffer;

    always_ff @(posedge clk) begin
	/* Default values on reset */
	if (reset) begin
	    write_x <= 8'h0;
	    write_y <= 8'h0;
	    write_radius <= 8'h0;
	    write_type <= 2'h0;
	/* if chipselect, write to local memory */
	end else if (chipselect && write_enable)
	    case (action)
		3'h0 : write_x <= payload;
		3'h1 : write_y <= payload;
		3'h2 : write_radius <= payload;
		3'h3 : write_type <= payload[2:0];
	    endcase
    end

endmodule
