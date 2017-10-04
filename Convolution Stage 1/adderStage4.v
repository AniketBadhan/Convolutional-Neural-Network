/*
	Author: Aniket Badhan
	Description: Addition stage 4
*/

`timescale 1ns / 1ps

module adderStage4(
    	input [6:0] input1,
    	input [5:0] input2,
    	output reg [7:0] output1,
	input enable,
    	input clk
    );

	always @ (posedge clk) begin
		if(enable) begin
			output1 <= {input1[6], input1} + {2'b11, input2};	
		end
		else begin
			output1 <= 0;	
		end
	end

endmodule
