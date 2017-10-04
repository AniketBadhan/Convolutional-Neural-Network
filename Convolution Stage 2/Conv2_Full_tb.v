`timescale 1ns / 1ps

module Conv2_Full_tb;

	// Inputs
	reg [7:0] pattern;
	reg [7:0] image;
	reg rst;
	reg clk;
	reg enable;

	// Outputs
	wire [21:0] convSum;
	wire packetRead;

	Conv2_Full dut (
		.clk(clk),
		.rst(rst),
		.enable(enable),
		.packetRead(packetRead),
		.image(image),
		.pattern(pattern),
		.convSum(convSum)
	);
	
	reg [7:0] imageArray [0:35];
	reg [7:0] patternArray [0:35];
	integer i = 0;
	
	
	initial $readmemb("image.txt", imageArray, 0, 35);
	initial $readmemb("pattern.txt", patternArray, 0, 35);
	
	initial begin
		pattern = 0;
		image = 0;
		enable = 0;
		clk = 0;
		rst = 1;
		#5;
		rst = 0;
	end
	
	always #5 clk = ~clk;
	
	always @ (negedge clk) begin
		if(packetRead && !rst && i < 36) begin
			enable = 1'b1;
			image = imageArray[i];
			pattern = patternArray[i];
			i = i + 1;
		end
		else begin
			enable = 0;
		end
	end
      
endmodule

