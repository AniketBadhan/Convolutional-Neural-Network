/*
	Author: Aniket Badhan
	Description: Convolution with Laplacian Filter using pipelining technique
*/

`timescale 1ns / 1ps

module Conv1(
    	input [3:0] input1,
    	input [3:0] input2,
   	input [3:0] input3,
    	input [3:0] input4,
    	input [3:0] input5,
    	output reg [7:0] output1,
    	input clk
    );

	wire [4:0] tempOutput1;
	wire [4:0] tempOutput2;
	wire [5:0] tempOutput3;
	wire [4:0] tempOutput4;
	wire [4:0] tempOutput5;
	wire [6:0] tempOutput6;
	wire [5:0] tempOutput7;
	wire [7:0] tempFinalOutput;
	
	reg enable = 1'b1;

	ConvolutionStage1 c1(
		.clk(clk),
		.enable(enable),
		.input2(input1),
		.input4(input2),
		.input5(input3),
		.input6(input4),
		.input8(input5),
		.output1(tempOutput1),
		.output2(tempOutput2),
		.output3(tempOutput3),
		.output4(tempOutput4),
		.output5(tempOutput5)
	);
	
	adderStage2 add1(
		.input1(tempOutput1),
		.input2(tempOutput2),
		.input3(tempOutput3),
		.output1(tempOutput6),
		.enable(enable),
		.clk(clk)
	);
	
	adderStage3 add3(
		.input1(tempOutput4),
		.input2(tempOutput5),
		.output1(tempOutput7),
		.enable(enable),
		.clk(clk)
	);
	
	adderStage4 add4(
		.input1(tempOutput6),
		.input2(tempOutput7),
		.output1(tempFinalOutput),
		.enable(enable),
		.clk(clk)
	);
	
	always @ (posedge clk) begin
		output1 <= tempFinalOutput;
	end
	
endmodule
