/*
	Author: Aniket Badhan
	Description: Multiplication stage
*/

`timescale 1ns / 1ps

module ConvolutionStage1(
	input clk,
	input enable,
    	input [3:0] input2,
    	input [3:0] input4,
   	input [3:0] input5,
    	input [3:0] input6,
    	input [3:0] input8,
    	output reg signed [4:0] output1,
   	output reg signed [4:0] output2,
    	output reg signed [5:0] output3,
    	output reg signed [4:0] output4,
    	output reg signed [4:0] output5 
    );
	
	always @ (posedge clk) begin
		if(enable) begin
			output1 <= {1'b1, ~(input2)} + 5'b00001;			//To multiply by -1, add 1 to 1's complement of the original number
			output2 <= {1'b1, ~(input4)} + 5'b00001;
			output3 <= {2'b00, input5} << 2;				//multiplication by 4
			output4 <= {1'b1, ~(input6)} + 5'b00001;
			output5 <= {1'b1, ~(input8)} + 5'b00001;
		end
		else begin
			output1 <= 0;	
			output2 <= 0;
			output3 <= 0;
			output4 <= 0;
			output5 <= 0;
		end
	end
	
endmodule
