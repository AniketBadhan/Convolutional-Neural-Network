/*
	Author: Aniket Badhan
	Description: Max Pooling implementation (to find out the max of the 4 inputs of 2X2 sub matrix	)
*/

`timescale 1ns / 1ps

module maxPooling(
    input clk,
	input [21:0] input1,
	input [21:0] input2,
	input [21:0] input3,
	input [21:0] input4,
	input enable,
    output reg signed [21:0] output1,
	output reg maxPoolingDone
    );
	
	reg [21:0] initialMax = 22'b1000000000000000000000;
	reg [21:0] tempOutput;
	
	always @ (posedge clk) begin
		if(enable) begin
			if($signed(initialMax) < $signed(input1)) begin
				if($signed(input2) < $signed(input1)) begin
					if($signed(input3) < $signed(input1)) begin
						if($signed(input4) < $signed(input1)) begin
							output1 <= input1;
							maxPoolingDone <= 1;
						end
						else begin
							output1 <= input4;
							maxPoolingDone <= 1;
						end
					end
					else begin
						if($signed(input3) < $signed(input4)) begin
							output1 <= input4;
							maxPoolingDone <= 1;
						end
						else begin
							output1 <= input3;
							maxPoolingDone <= 1;
						end
					end
				end
				else begin
					if($signed(input3) < $signed(input2)) begin
						if($signed(input4) < $signed(input2)) begin
							output1 <= input2;
							maxPoolingDone <= 1;
						end
						else begin
							output1 <= input4;
							maxPoolingDone <= 1;
						end
					end
					else begin
						if($signed(input3) < $signed(input4)) begin
							output1 <= input4;
							maxPoolingDone <= 1;
						end
						else begin
							output1 <= input3;
							maxPoolingDone <= 1;
						end
					end
				end
			end
			else begin
				output1 <= initialMax;
				maxPoolingDone <= 1;
			end
		end
		else begin
			output1 <= 0;
			maxPoolingDone <= 0;
		end
	end


endmodule
