module sand_update(
	input logic docalculations,
	input logic [15:0] region,
	input logic [15:0] floor,
	output logic [15:0] new_region,
	output logic [15:0] new_floor);
	
	logic[1:0] r1;
	assign r1 = region[15:14];
	logic[1:0] r2;
	assign r2 = region[13:12];
	logic[1:0] r3;
	assign r3 = region[15:10];
	logic[1:0] r4;
	assign r4 = region[15:8];
	logic[1:0] r5;
	assign r5 = region[7:6];
	logic[1:0] r6;
	assign r6 = region[5:4];
	logic[1:0] r7;
	assign r7 = region[3:2];
	logic[1:0] r8;
	assign r8 = region[1:0];
	
	logic[1:0] f1;
	assign f1 = floor[15:14];
	logic[1:0] f2;
	assign f2 = floor[13:12];
	logic[1:0] f3;
	assign f3 = floor[15:10];
	logic[1:0] f4;
	assign f4 = floor[15:8];
	logic[1:0] f5;
	assign f5 = floor[7:6];
	logic[1:0] f6;
	assign f6 = floor[5:4];
	logic[1:0] f7;
	assign f7 = floor[3:2];
	logic[1:0] f8;
	assign f8 = floor[1:0];
	
	always @(docalculations) begin
		for (i=7; i>=0; i=i-1) begin
			else if (i == 7) begin//leftmost region pixel
			
			end
			
			if (i == 0) begin//rightmost region pixel
				
			end
			
			else begin//middle pixels
			
			end
		end
	end
endmodule
