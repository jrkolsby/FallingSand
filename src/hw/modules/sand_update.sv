module sand_update(
	input logic docalculations,
	input logic screenbegin,
	input logic screenend,
	input logic [31:0] region,
	input logic [31:0] floor,
	output logic [31:0] new_region,
	output logic [31:0] new_floor);
	
	logic[1:0] ri[15:0];
	logic[1:0] fi[15:0];
	logic[1:0] ro[15:0];
	logic[1:0] fo[15:0];
	
	parameter AIR 	= 2'b00,
		SAND	= 2'b01,
		SAND_AM	= 2'b10,
		WALL	= 2'b11;
	
	assign ri[15] = region[31:30];
	assign ri[14] = region[29:28];
	assign ri[13] = region[27:26];
	assign ri[12] = region[25:24];
	assign ri[11] = region[23:22];
	assign ri[10] = region[21:20];
	assign ri[9] = region[19:18];
	assign ri[8] = region[17:16];
	assign ri[7] = region[15:14];
	assign ri[6] = region[13:12];
	assign ri[5] = region[11:10];
	assign ri[4] = region[9:8];
	assign ri[3] = region[7:6];
	assign ri[2] = region[5:4];
	assign ri[1] = region[3:2];
	assign ri[0] = region[1:0];
	
	assign fi[15] = floor[31:30];
	assign fi[14] = floor[29:28];
	assign fi[13] = floor[27:26];
	assign fi[12] = floor[25:24];
	assign fi[11] = floor[23:22];
	assign fi[10] = floor[21:20];
	assign fi[9] = floor[19:18];
	assign fi[8] = floor[17:16];
	assign fi[7] = floor[15:14];
	assign fi[6] = floor[13:12];
	assign fi[5] = floor[11:10];
	assign fi[4] = floor[9:8];
	assign fi[3] = floor[7:6];
	assign fi[2] = floor[5:4];
	assign fi[1] = floor[3:2];
	assign fi[0] = floor[1:0];
	
	always_comb begin
		if (screenbegin) begin //leftmost pixel in row
			if (ri[15] == SAND) begin
				if (fi[15] == AIR) begin
					ro[15] = AIR;
					fo[15] = SAND_AM;
				end else if (fi[14] == AIR) begin
					ro[15] = AIR;
					fo[15] = fi[15];
					fo[14] = SAND_AM;
				end else begin
					ro[15] = ri[15];
					fo[15] = fi[15];
				end
			end
				
			else if (ri[15] == SAND_AM) //
				ro[15] = SAND;
		end
		
		for (i=15; i>0; i=i-1) begin

		end
		
		else if (screenend) begin//rightmost pixel in row
				
		end
	end
endmodule
