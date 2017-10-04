`timescale 1ns / 1ps

module conv1_tb;

	// Inputs
	reg [3:0] input1;
	reg [3:0] input2;
	reg [3:0] input3;
	reg [3:0] input4;
	reg [3:0] input5;
	reg clk;

	// Outputs
	wire [7:0] output1;

	// Instantiate the Unit Under Test (UUT)
	Conv1 uut (
		.input1(input1), 
		.input2(input2), 
		.input3(input3), 
		.input4(input4), 
		.input5(input5), 
		.output1(output1), 
		.clk(clk)
	);

	initial begin
		// Initialize Inputs
		input1 = 0;
		input2 = 0;
		input3 = 0;
		input4 = 0;
		input5 = 0;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#95;
      		input1 = 14;
		input2 = 7;
		input3 = 10;
		input4 = 9;
		input5 = 2; 
		#10;
		input1 = 4;
		input2 = 5;
		input3 = 1;
		input4 = 8;
		input5 = 6; 
		#10;
		input1 = 4;
		input2 = 12;
		input3 = 11;
		input4 = 5;
		input5 = 6; 
		#10;
		input1 = 4;
		input2 = 7;
		input3 = 5;
		input4 = 2;
		input5 = 4; 
		// Add stimulus here
	end
		
	always #5 clk = ~clk;	
      
endmodule

