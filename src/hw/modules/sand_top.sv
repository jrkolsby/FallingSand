module sand_top(input logic clk,
		input logic reset
		input chipselect,
		input logic write,
		input logic [2:0] address,
		input logic [7:0] writedata);

   logic [7:0] background_r, background_g, background_b;
   logic [7:0] ball_x, ball_y;

   always_ff @(posedge clk)
     /* Default values on reset */
     if (reset) begin
	background_r <= 8'h0;
	background_g <= 8'h40;
	background_b <= 8'h80;
	ball_x <= 8'h4;
	ball_y <= 8'h4;
     /* if chipselect, write to local memory */
     end else if (chipselect && write)
       case (address)
	 3'h0 : background_r <= writedata;
	 3'h1 : background_g <= writedata;
	 3'h2 : background_b <= writedata;
	 3'h3 : ball_x <= writedata;
	 3'h4 : ball_y <= writedata;
       endcase

endmodule
