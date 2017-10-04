/*
	Author: Aniket Badhan
	Description: Addition stage 2
*/

`timescale 1ns / 1ps

module adderStage2(
    	input [4:0] input1,
    	input [4:0] input2,
	input [5:0] input3,
    	output reg [6:0] output1,
	input enable,
    	input clk
    );

	always @ (posedge clk) begin
		if(enable) begin
			output1 <= {2'b11, input1} + {2'b11, input2} + {1'b0, input3};
		end
		else begin
			output1 <= 0;	
		end
	end
	
endmodule
