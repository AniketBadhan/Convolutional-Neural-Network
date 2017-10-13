/*
	Author: Aniket Badhan
	Description: Addition stage 2
*/

`timescale 1ns / 1ps

module adderStage3_2(
    	input [17:0] input1,
    	input [17:0] input2,
    	output reg [18:0] output1,
	input enable,
    	input clk
    );
	
	always @ (posedge clk) begin
		if(enable) begin
			output1 <= {input1[17], input1} + {input2[17], input2};
		end
		else begin
			output1 <= 0;
		end
	end
	
endmodule
