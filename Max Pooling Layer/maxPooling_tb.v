`timescale 1ns / 1ps

module maxPooling_tb;

	// Inputs
	reg [21:0] input1;
	reg [21:0] input2;
	reg [21:0] input3;
	reg [21:0] input4;
	reg clk;
	reg enable;

	// Outputs
	wire [21:0] output1;
	wire maxPoolingDone;
	
	reg [21:0] array_image [0:15];
	integer i = 0;

	// Instantiate the Unit Under Test (UUT)
	maxPooling uut (
		.input1(input1), 
		.input2(input2), 
		.input3(input3), 
		.input4(input4), 
		.clk(clk), 
		.enable(enable), 
		.output1(output1), 
		.maxPoolingDone(maxPoolingDone)
	);
	
	initial begin
		// Initialize Inputs
		input1 = 0;
		input2 = 0;
		input3 = 0;
		input4 = 0;
		array_image[0] = 22'b1110000000000011001000;
		array_image[1] = 22'b1111111111111111100100;
		array_image[2] = 22'b1111111111111110011100;
		array_image[3] = 22'b1111111111111100111000;
		array_image[4] = 22'b0000000000000001100100;
		array_image[5] = 22'b0000000000000100101100;
		array_image[6] = 22'b0000000000000011001000;
		array_image[7] = 22'b1111111111111110011100;
		array_image[8] = 22'b0000000000000001100100;
		array_image[9] = 22'b0000000000000100101100;
		array_image[10] = 22'b0000000000001010111100;
		array_image[11] = 22'b1111111111111011010100;
		array_image[12] = 22'b0000000000000000000111;
		array_image[13] = 22'b1111111111111111111101;
		array_image[14] = 22'b0000000000000000001000;
		array_image[15] = 22'b0000000000000000001111;
		enable = 0;
		clk = 0;
	end
	
	always #5 clk = ~clk;	
	
	always @ (posedge clk) begin
		if(i < 16) begin
			enable = 1;
			input1 = array_image[i];
			input2 = array_image[i+1];
			input3 = array_image[i+2];
			input4 = array_image[i+3];
			i = i + 4;
		end
		else begin
			enable = 0;
		end
	end
      
endmodule

