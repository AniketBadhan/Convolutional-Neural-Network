/*
	Author: Aniket Badhan
	Description: Addition stage 3 of Convolution with Laplacian filter
*/

`timescale 1ns / 1ps

module adderStage3(
    	input [4:0] input1,
    	input [4:0] input2,
    	output reg [5:0] output1,
    	input clk,
    	input enable,
	output reg done
    );

	always @ (posedge clk) begin
		if(enable) begin
			output1 <= {input1[4], input1} + {input2[4], input2};	
			done <= 1'b1;
		end
		else begin
			output1 <= 0;
			done <= 1'b0;
		end
	end
	
endmodule
