`timescale 1ns / 1ps

module CNN_tb;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire [3:0] numberOfTimes_PatterDetected;

	// Instantiate the Unit Under Test (UUT)
	CNN uut (
		.clk(clk),
		.rst(rst),
		.numberOfTimes_PatterDetected(numberOfTimes_PatterDetected)		
	);
	
	initial begin
		clk = 0;
		rst = 1;
		#10;
		rst = 0;
	end
	
	always #5 clk = ~clk;
endmodule