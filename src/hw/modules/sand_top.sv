module sand_top(input [3:0] KEY,
		
		/*
		// SLAVE FROM RAM
		input [12:0] DRAM_ADDR,
		input [1:0] DRAM_BA,
		input DRAM_CAS_N,
		input DRAM_CKE,
		input DRAM_CLK,
		input DRAM_CS_N,
		inout [15:0] DRAM_DQ,
		output DRAM_LDQM,
		input DRAM_RAS_N,
		input DRAM_UDQM,
		input DRAM_WE_N,
		*/

		input logic reset,
		input logic clock,

		// SLAVE TO HPS
		input logic write, 		// write enable
		input logic [7:0] writedata,	// writedata
		input chipselect,		// chipselect
		input logic [2:0] address 	// address type
);

    logic [7:0] background_r, background_g, background_b;
    logic [7:0] write_x, write_y, write_radius;
    logic [1:0] write_type;

    logic [17:0] kernel_buffer;

    always_ff @(posedge clock) begin
	// Default values on reset
	if (reset) begin
	    write_x <= 8'h0;
	    write_y <= 8'h0;
	    write_radius <= 8'h0;
	    write_type <= 2'h0;
	// if chipselect, write to local memory
	end else if (chipselect && write)
	    case (address)
		3'h0 : write_x <= writedata;
		3'h1 : write_y <= writedata;
		3'h2 : write_radius <= writedata;
		3'h3 : write_type <= writedata[2:0];
	    endcase
    end

endmodule
