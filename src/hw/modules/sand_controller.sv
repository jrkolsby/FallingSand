// By: James Kolsby and Jeremy Adkins
// Uni: JRK2181 & JA3072

module controller( input logic        CLOCK_50, 
	     input logic [3:0] 	KEY, // Pushbuttons; KEY[0] is rightmost
	     // 7-segment LED displays; HEX0 is rightmost
	     output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
	     );

   logic [3:0] 		      a;         // Address
   logic [7:0] 		      din, dout; // RAM data in and out
   logic 		      we;        // RAM write enable

   logic 		      clk;
   assign clk = CLOCK_50;

   hex7seg h0( .a(a),         .y(HEX5) ), // Leftmost digit
           h1( .a(dout[7:4]), .y(HEX3) ), // left middle
           h2( .a(dout[3:0]), .y(HEX2) ); // right middle

   controller c( .* ); // Connect everything with matching names
   memory m( .* );

   assign HEX4 = 7'b111_1111; // Display a blank; LEDs are active-low
   assign HEX1 = 7'b111_1111;
   assign HEX0 = 7'b111_1111;
  
endmodule

module controller(input logic        clk,
		  input logic [3:0]  KEY,
		  input logic [7:0]  dout,
		  output logic [3:0] a,
		  output logic [7:0] din,
		  output logic 	     we);

    logic [3:0] _a;
    logic 	_we;
    logic [7:0] _din;
    logic [22:0] counter;

    always_ff @(posedge clk) begin
	counter = counter + 1;
	if (counter == 23'b0)
	    case (KEY)
		4'b0111:	{_a, _we} = {_a + 4'b1, 1'b0};
		4'b1011:	{_a, _we} = {_a - 4'b1, 1'b0};
		4'b1101:	{_din, _we} = {dout + 8'b1, 1'b1};
		4'b1110:	{_din, _we} = {dout - 8'b1, 1'b1};
		default:	begin _we = 1'b0; counter = 0; end
	    endcase
    end

    assign a = _a;
    assign we = _we;
    assign din = _din;

    /*
    * hex7seg tester
    always_ff @(posedge clk) begin
	case (KEY)
	    4'b1110:	_a = 4'h1;
	    4'b1101:	_a = 4'h2;
	    4'b1100:	_a = 4'h3;
	    4'b1011:	_a = 4'h4;
	    4'b1010:	_a = 4'h5;
	    4'b1001:	_a = 4'h6;
	    4'b1000:	_a = 4'h7;
	    4'b0111:	_a = 4'h8;
	    4'b0110:	_a = 4'h9;
	    4'b0101:	_a = 4'hA;
	    4'b0100:	_a = 4'hB;
	    4'b0011:	_a = 4'hC;
	    4'b0010:	_a = 4'hD;
	    4'b0001:	_a = 4'hE;
	    4'b0000:	_a = 4'hF;
	    default:	_a = 4'h0;
	endcase
    end
    */

   
endmodule
		  
module hex7seg(input logic [3:0] a,
	       output logic [6:0] y);

    always_comb
      case (a)
    	4'h0:	 y = 7'b100_0000;
	4'h1:	 y = 7'b111_1001;
	4'h2:	 y = 7'b010_0100;
	4'h3:	 y = 7'b011_0000;
	4'h4:	 y = 7'b001_1001;
	4'h5:	 y = 7'b001_0010;
	4'h6:	 y = 7'b000_0010;
	4'h7:	 y = 7'b111_1000;
	4'h8:	 y = 7'b000_0000;
	4'h9: 	 y = 7'b001_0000;
	4'hA: 	 y = 7'b000_1000;
	4'hB: 	 y = 7'b000_0011;
	4'hC: 	 y = 7'b100_0110;
	4'hD: 	 y = 7'b010_0001;
	4'hE: 	 y = 7'b000_0110;
	4'hF: 	 y = 7'b000_1110;
	default: y = 7'b111_1111;
    endcase
   
endmodule

// 16 X 8 synchronous RAM with old data read-during-write behavior
module memory(input logic        clk,
	      input logic [3:0]  a,
	      input logic [7:0]  din,
	      input logic 	 we,
	      output logic [7:0] dout);
   
   logic [7:0] 			 mem [15:0];

   always_ff @(posedge clk) begin
      if (we) mem[a] <= din;
      dout <= mem[a];
   end
        
endmodule
