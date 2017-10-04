/*
	Author: Aniket Badhan
	Description: Convolution with convoultion of pattern to be tested using pipelining technique
*/

`timescale 1ns / 1ps

module Conv2_Full(
	input clk,
	input rst,
	input enable,
	output reg packetRead,
	input [7:0] image,
	input [7:0] pattern,
	output reg [21:0] convSum
);
	
	reg [7:0] imageArray [0:35];
	reg [7:0] patternArray [0:35];

	reg [5:0] count;
	
	wire [15:0] tempOutput1;
	wire [15:0] tempOutput2;
	wire [15:0] tempOutput3;
	wire [15:0] tempOutput4;
	wire [15:0] tempOutput5;
	wire [15:0] tempOutput6;
	wire [15:0] tempOutput7;
	wire [15:0] tempOutput8;
	wire [15:0] tempOutput9;
	wire [15:0] tempOutput10;
	wire [15:0] tempOutput11;
	wire [15:0] tempOutput12;
	wire [15:0] tempOutput13;
	wire [15:0] tempOutput14;
	wire [15:0] tempOutput15;
	wire [15:0] tempOutput16;
	wire [15:0] tempOutput17;
	wire [15:0] tempOutput18;
	wire [15:0] tempOutput19;
	wire [15:0] tempOutput20;
	wire [15:0] tempOutput21;
	wire [15:0] tempOutput22;
	wire [15:0] tempOutput23;
	wire [15:0] tempOutput24;
	wire [15:0] tempOutput25;
	wire [15:0] tempOutput26;
	wire [15:0] tempOutput27;
	wire [15:0] tempOutput28;
	wire [15:0] tempOutput29;
	wire [15:0] tempOutput30;
	wire [15:0] tempOutput31;
	wire [15:0] tempOutput32;
	wire [15:0] tempOutput33;
	wire [15:0] tempOutput34;
	wire [15:0] tempOutput35;
	wire [15:0] tempOutput36;
	
	wire [17:0] tempOutput37;
	wire [17:0] tempOutput38;
	wire [17:0] tempOutput39;
	wire [17:0] tempOutput40;
	wire [17:0] tempOutput41;
	wire [17:0] tempOutput42;
	wire [17:0] tempOutput43;
	wire [17:0] tempOutput44;
	wire [17:0] tempOutput45;
	wire [17:0] tempOutput46;
	wire [17:0] tempOutput47;
	wire [17:0] tempOutput48;
	
	wire [18:0] tempOutput49;
	wire [18:0] tempOutput50;
	wire [18:0] tempOutput51;
	wire [18:0] tempOutput52;
	wire [18:0] tempOutput53;
	wire [18:0] tempOutput54;
	
	wire [20:0] tempOutput55;
	wire [20:0] tempOutput56;
	
	wire [21:0] tempOutput57;
	
	reg subEnable;
	
	always @ (posedge clk or posedge rst) begin
		if(rst) begin
			packetRead <= 0;
			count <= 0;
		end
		else begin
			if(count < 36) begin
				packetRead <= 1'b1;
				subEnable <= 1'b0;
			end
			else begin
				packetRead <= 1'b0;
				subEnable <= 1'b1;
			end
			if(enable) begin
				imageArray[count] <= image;
				patternArray[count] <= pattern;
				count <= count + 1'b1;
			end
			else begin
				count <= count;
			end
		end
	end
	
	ConvolutionStage2 c1(
		.clk(clk),
		.enable(subEnable),
		.input1(imageArray[0]),
		.input2(imageArray[1]),
		.input3(imageArray[2]),
		.input4(imageArray[3]),
		.input5(imageArray[4]),
		.input6(imageArray[5]),
		.input7(patternArray[0]),
		.input8(patternArray[1]),
		.input9(patternArray[2]),
		.input10(patternArray[3]),
		.input11(patternArray[4]),
		.input12(patternArray[5]),
		.output1(tempOutput1),
		.output2(tempOutput2),
		.output3(tempOutput3),
		.output4(tempOutput4),
		.output5(tempOutput5),
		.output6(tempOutput6)
	);
	
	ConvolutionStage2 c2(
		.clk(clk),
		.enable(subEnable),
		.input1(imageArray[6]),
		.input2(imageArray[7]),
		.input3(imageArray[8]),
		.input4(imageArray[9]),
		.input5(imageArray[10]),
		.input6(imageArray[11]),
		.input7(patternArray[6]),
		.input8(patternArray[7]),
		.input9(patternArray[8]),
		.input10(patternArray[9]),
		.input11(patternArray[10]),
		.input12(patternArray[11]),
		.output1(tempOutput7),
		.output2(tempOutput8),
		.output3(tempOutput9),
		.output4(tempOutput10),
		.output5(tempOutput11),
		.output6(tempOutput12)
	);
	
	ConvolutionStage2 c3(
		.clk(clk),
		.enable(subEnable),
		.input1(imageArray[12]),
		.input2(imageArray[13]),
		.input3(imageArray[14]),
		.input4(imageArray[15]),
		.input5(imageArray[16]),
		.input6(imageArray[17]),
		.input7(patternArray[12]),
		.input8(patternArray[13]),
		.input9(patternArray[14]),
		.input10(patternArray[15]),
		.input11(patternArray[16]),
		.input12(patternArray[17]),
		.output1(tempOutput13),
		.output2(tempOutput14),
		.output3(tempOutput15),
		.output4(tempOutput16),
		.output5(tempOutput17),
		.output6(tempOutput18)
	);
	
	ConvolutionStage2 c4(
		.clk(clk),
		.enable(subEnable),
		.input1(imageArray[18]),
		.input2(imageArray[19]),
		.input3(imageArray[20]),
		.input4(imageArray[21]),
		.input5(imageArray[22]),
		.input6(imageArray[23]),
		.input7(patternArray[18]),
		.input8(patternArray[19]),
		.input9(patternArray[20]),
		.input10(patternArray[21]),
		.input11(patternArray[22]),
		.input12(patternArray[23]),
		.output1(tempOutput19),
		.output2(tempOutput20),
		.output3(tempOutput21),
		.output4(tempOutput22),
		.output5(tempOutput23),
		.output6(tempOutput24)
	);
	
	ConvolutionStage2 c5(
		.clk(clk),
		.enable(subEnable),
		.input1(imageArray[24]),
		.input2(imageArray[25]),
		.input3(imageArray[26]),
		.input4(imageArray[27]),
		.input5(imageArray[28]),
		.input6(imageArray[29]),
		.input7(patternArray[24]),
		.input8(patternArray[25]),
		.input9(patternArray[26]),
		.input10(patternArray[27]),
		.input11(patternArray[28]),
		.input12(patternArray[29]),
		.output1(tempOutput25),
		.output2(tempOutput26),
		.output3(tempOutput27),
		.output4(tempOutput28),
		.output5(tempOutput29),
		.output6(tempOutput30)
	);
	
	ConvolutionStage2 c6(
		.clk(clk),
		.enable(subEnable),
		.input1(imageArray[30]),
		.input2(imageArray[31]),
		.input3(imageArray[32]),
		.input4(imageArray[33]),
		.input5(imageArray[34]),
		.input6(imageArray[35]),
		.input7(patternArray[30]),
		.input8(patternArray[31]),
		.input9(patternArray[32]),
		.input10(patternArray[33]),
		.input11(patternArray[34]),
		.input12(patternArray[35]),
		.output1(tempOutput31),
		.output2(tempOutput32),
		.output3(tempOutput33),
		.output4(tempOutput34),
		.output5(tempOutput35),
		.output6(tempOutput36)
	);
	
	adderStage2_2 add1(
		.input1(tempOutput1),
		.input2(tempOutput2),
		.input3(tempOutput3),
		.output1(tempOutput37),
		.enable(subEnable),
		.clk(clk)
	);
	
	adderStage2_2 add2(
		.input1(tempOutput4),
		.input2(tempOutput5),
		.input3(tempOutput6),
		.output1(tempOutput38),
		.enable(subEnable),
		.clk(clk)
	);
	
	adderStage2_2 add3(
		.input1(tempOutput7),
		.input2(tempOutput8),
		.input3(tempOutput9),
		.output1(tempOutput39),
		.enable(subEnable),
		.clk(clk)
	);
	
	adderStage2_2 add4(
		.input1(tempOutput10),
		.input2(tempOutput11),
		.input3(tempOutput12),
		.output1(tempOutput40),
		.enable(subEnable),
		.clk(clk)
	);
	
	adderStage2_2 add5(
		.input1(tempOutput13),
		.input2(tempOutput14),
		.input3(tempOutput15),
		.output1(tempOutput41),
		.enable(subEnable),
		.clk(clk)
	);
	
	adderStage2_2 add6(
		.input1(tempOutput16),
		.input2(tempOutput17),
		.input3(tempOutput18),
		.output1(tempOutput42),
		.enable(subEnable),
		.clk(clk)
	);
	
	adderStage2_2 add7(
		.input1(tempOutput19),
		.input2(tempOutput20),
		.input3(tempOutput21),
		.output1(tempOutput43),
		.enable(subEnable),
		.clk(clk)
	);
	
	adderStage2_2 add8(
		.input1(tempOutput22),
		.input2(tempOutput23),
		.input3(tempOutput24),
		.output1(tempOutput44),
		.enable(subEnable),
		.clk(clk)
	);
	
	adderStage2_2 add9(
		.input1(tempOutput25),
		.input2(tempOutput26),
		.input3(tempOutput27),
		.output1(tempOutput45),
		.enable(subEnable),
		.clk(clk)
	);
	
	adderStage2_2 add10(
		.input1(tempOutput28),
		.input2(tempOutput29),
		.input3(tempOutput30),
		.output1(tempOutput46),
		.enable(subEnable),
		.clk(clk)
	);
	
	adderStage2_2 add11(
		.input1(tempOutput31),
		.input2(tempOutput32),
		.input3(tempOutput33),
		.output1(tempOutput47),
		.enable(subEnable),
		.clk(clk)
	);
	
	adderStage2_2 add12(
		.input1(tempOutput34),
		.input2(tempOutput35),
		.input3(tempOutput36),
		.output1(tempOutput48),
		.enable(subEnable),
		.clk(clk)
	);
	
	adderStage3_2 add3_1(
		.input1(tempOutput37),
		.input2(tempOutput38),
		.output1(tempOutput49),
		.enable(subEnable),
		.clk(clk)
	);
	adderStage3_2 add3_2(
		.input1(tempOutput39),
		.input2(tempOutput40),
		.output1(tempOutput50),
		.enable(subEnable),
		.clk(clk)
	);
	adderStage3_2 add3_3(
		.input1(tempOutput41),
		.input2(tempOutput42),
		.output1(tempOutput51),
		.enable(subEnable),
		.clk(clk)
	);
	adderStage3_2 add3_4(
		.input1(tempOutput43),
		.input2(tempOutput44),
		.output1(tempOutput52),
		.enable(subEnable),
		.clk(clk)
	);
	adderStage3_2 add3_5(
		.input1(tempOutput45),
		.input2(tempOutput46),
		.output1(tempOutput53),
		.enable(subEnable),
		.clk(clk)
	);
	adderStage3_2 add3_6(
		.input1(tempOutput47),
		.input2(tempOutput48),
		.output1(tempOutput54),
		.enable(subEnable),
		.clk(clk)
	);
	
	adderStage4_2 add4_1(
		.input1(tempOutput49),
		.input2(tempOutput50),
		.input3(tempOutput51),
		.output1(tempOutput55),
		.enable(subEnable),
		.clk(clk)
	);
	adderStage4_2 add4_2(
		.input1(tempOutput52),
		.input2(tempOutput53),
		.input3(tempOutput54),
		.output1(tempOutput56),
		.enable(subEnable),
		.clk(clk)
	);
	
	adderStage5_2 add5_1(
		.input1(tempOutput55),
		.input2(tempOutput56),
		.output1(tempOutput57),
		.enable(subEnable),
		.clk(clk)
	);
	
	always @ (posedge clk, posedge rst) begin
		if(rst) begin
			convSum <= 0;
		end
		else begin
			convSum <= tempOutput57;
		end
	end

endmodule