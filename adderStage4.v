/*
	Author: Aniket Badhan
	Description: Addition stage 4 of Convolution with Laplacian filter
*/

`timescale 1ns / 1ps

module adderStage4(
    	input [6:0] input1,
    	input [5:0] input2,
    	output reg [7:0] output1,
    	input clk,
	input enable,
	output reg done
    );

	always @ (posedge clk) begin
		if(enable) begin
			output1 <= {input1[6], input1} + {{2{input2[5]}}, input2};	
			done <= 1'b1;
		end
		else begin
			output1 <= 0;	
			done <= 1'b0;
		end
	end

endmodule
