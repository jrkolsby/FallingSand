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
	
	assign new_region[31:30] = ro[15];
	assign new_region[29:28] = ro[14];
	assign new_region[27:26] = ro[13];
	assign new_region[25:24] = ro[12];
	assign new_region[23:22] = ro[11];
	assign new_region[21:20] = ro[10];
	assign new_region[19:18] = ro[9];
	assign new_region[17:16] = ro[8];
	assign new_region[15:14] = ro[7];
	assign new_region[13:12] = ro[6];
	assign new_region[11:10] = ro[5];
	assign new_region[9:8] = ro[4];
	assign new_region[7:6] = ro[3];
	assign new_region[5:4] = ro[2];
	assign new_region[3:2] = ro[1];
	assign new_region[1:0] = ro[0];
	
	assign new_floor[31:30] = fo[15];
	assign new_floor[29:28] = fo[14];
	assign new_floor[27:26] = fo[13];
	assign new_floor[25:24] = fo[12];
	assign new_floor[23:22] = fo[11];
	assign new_floor[21:20] = fo[10];
	assign new_floor[19:18] = fo[9];
	assign new_floor[17:16] = fo[8];
	assign new_floor[15:14] = fo[7];
	assign new_floor[13:12] = fo[6];
	assign new_floor[11:10] = fo[5];
	assign new_floor[9:8] = fo[4];
	assign new_floor[7:6] = fo[3];
	assign new_floor[5:4] = fo[2];
	assign new_floor[3:2] = fo[1];
	assign new_floor[1:0] = fo[0];
	
	always @(docalculations) begin
		for (i=8; i>0; i=i-1) begin
			if (screenbegin) begin//leftmost pixel in row
			
			end
			
			else if (screenend) begin//rightmost pixel in row
				
			end
			
			else begin//middle pixels
			
			end
		end
	end
endmodule
