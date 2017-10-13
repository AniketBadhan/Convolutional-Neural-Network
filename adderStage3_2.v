/*
	Author: Aniket Badhan
	Description: Addition stage 3 of Convolution layer 2, convolution of convolved image and convolved pattern
*/

`timescale 1ns / 1ps

module adderStage3_2(
    	input [17:0] input1,
    	input [17:0] input2,
    	output reg [18:0] output1,
	input enable,
    	input clk,
	output reg done
    );
	
	always @ (posedge clk) begin
		if(enable) begin
			output1 <= {input1[17], input1} + {input2[17], input2};
			done <= 1'b1;
		end
		else begin
			output1 <= 0;
			done <= 1'b0;
		end
	end
	
endmodule
