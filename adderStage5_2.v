/*
	Author: Aniket Badhan
	Description: Addition stage 5 of Convolution layer 2, convolution of convolved image and convolved pattern
*/

`timescale 1ns / 1ps

module adderStage5_2(
    	input [20:0] input1,
    	input [20:0] input2,
    	output reg [21:0] output1,
	input enable,
    	input clk,
	output reg done
    );
	
	always @ (posedge clk) begin
		if(enable) begin
			output1 <= {input1[20], input1} + {input2[20], input2};
			done <= 1'b1;
		end
		else begin
			output1 <= 0;
			done <= 1'b0;
		end
	end
	
endmodule
