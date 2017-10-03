/*
	Author: Aniket Badhan
	Description: Addition stage 3
*/

`timescale 1ns / 1ps

module adderStage3(
    input [4:0] input1,
    input [4:0] input2,
    output reg [5:0] output1,
    input clk
    //input adderEnable
    );

	always @ (posedge clk) begin
		output1 <= input1 + input2;	
	end
	
endmodule
