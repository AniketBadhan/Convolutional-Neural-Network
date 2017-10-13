/*
	
	Author: Aniket Badhan
	Description: Top Module, combining all the layers of the CNN, Convolution Stage 1, Convolution Stage 2 and Max Pooling Layer

*/

`define IMAGEROW	128
`define IMAGECOL	128
`define PATTERNROW	8
`define PATTERNCOL	8
`define FILTERROW	3
`define FILTERCOL	3
`define CONVROW		126
`define CONVCOL		126
`define MAXROW 		121
`define MAXCOL		121

module CNN (
	input clk,
	input rst,
	output reg [3:0] numberOfTimes_PatterDetected
);

	reg [7:0] imageArray [0:16383];									//memory buffer for storing image and the convolution of it with the laplacian filter
	reg [7:0] patternArray [0:63];									//memory buffer for storing pattern and the convolution of it with the laplacian filter
	reg [21:0] stage2Output [0:16383];	
	reg [21:0] stage3Output [0:4095];
	
	initial $readmemb("image1.txt", imageArray, 0, 16383);			//reading image
	initial $readmemb("pattern.txt", patternArray, 0, 63);			//reading pattern
	

	//internal signals for the Convolution of Image with the laplacian filter
	wire [3:0] input1_stage1_image;
	wire [3:0] input2_stage1_image;
	wire [3:0] input3_stage1_image;
	wire [3:0] input4_stage1_image;
	wire [3:0] input5_stage1_image;
	wire [4:0] tempOutput1_stage1_image;
	wire [4:0] tempOutput2_stage1_image;
	wire [5:0] tempOutput3_stage1_image;
	wire [4:0] tempOutput4_stage1_image;
	wire [4:0] tempOutput5_stage1_image;
	wire [6:0] tempOutput6_stage1_image;
	wire [5:0] tempOutput7_stage1_image;
	wire [7:0] tempFinalOutput_stage1_image;
	
	reg enable_stage1_image;
	wire done1_image;
	wire done2_image;
	wire done3_image;
	wire done4_image;
	
	reg [14:0] count_stage1_image;
	reg [14:0] writeCount_stage1_image = 0;
	reg [6:0] rowCount_image;
	
	ConvolutionStage1 c1_image(
		.clk(clk),
		.enable(enable_stage1_image),
		.input2(input1_stage1_image),
		.input4(input2_stage1_image),
		.input5(input3_stage1_image),
		.input6(input4_stage1_image),
		.input8(input5_stage1_image),
		.output1(tempOutput1_stage1_image),
		.output2(tempOutput2_stage1_image),
		.output3(tempOutput3_stage1_image),
		.output4(tempOutput4_stage1_image),
		.output5(tempOutput5_stage1_image),
		.done(done1_image)
	);
	
	adderStage2 add2_image(
		.input1(tempOutput1_stage1_image),
		.input2(tempOutput2_stage1_image),
		.input3(tempOutput3_stage1_image),
		.output1(tempOutput6_stage1_image),
		.clk(clk),
		.enable(done1_image),
		.done(done2_image)
	);
	
	adderStage3 add3_image(
		.input1(tempOutput4_stage1_image),
		.input2(tempOutput5_stage1_image),
		.output1(tempOutput7_stage1_image),
		.clk(clk),
		.enable(done1_image),
		.done(done3_image)
	);
	
	adderStage4 add4_image(
		.input1(tempOutput6_stage1_image),
		.input2(tempOutput7_stage1_image),
		.output1(tempFinalOutput_stage1_image),
		.clk(clk),
		.enable(done2_image),
		.done(done4_image)
	);
	
	//assigning values to the input signals for the convolution of image with the laplcian filter
	assign input1_stage1_image = (enable_stage1_image && (rowCount_image < `IMAGEROW - 1)) ? imageArray[count_stage1_image + 1][3:0] : 4'b0000;
	assign input2_stage1_image = (enable_stage1_image && (rowCount_image < `IMAGEROW - 1)) ? imageArray[count_stage1_image + 128][3:0] : 4'b0000;
	assign input3_stage1_image = (enable_stage1_image && (rowCount_image < `IMAGEROW - 1)) ? imageArray[count_stage1_image + 129][3:0] : 4'b0000;
	assign input4_stage1_image = (enable_stage1_image && (rowCount_image < `IMAGEROW - 1)) ? imageArray[count_stage1_image + 130][3:0] : 4'b0000;
	assign input5_stage1_image = (enable_stage1_image && (rowCount_image < `IMAGEROW - 1)) ? imageArray[count_stage1_image + 257][3:0] : 4'b0000;
	
	//always block for generating the address for creating the input signals and writing the output of convolution to the memory
	always @ (posedge clk) begin
		if(rst) begin
			enable_stage1_image <= 1'b0;
			count_stage1_image <= 0;
			rowCount_image <= 7'b0000001;
		end
		else begin
			enable_stage1_image <= 1'b1;
			if(enable_stage1_image) begin												//Once the enable_stage1_image is high, start generating the count_stage1_image values for creating the input values to ConvolutionStage1 module for image convolution
				if(rowCount_image < `IMAGEROW - 1) begin
					if(count_stage1_image < (rowCount_image*`IMAGECOL - 3)) begin
						count_stage1_image <= count_stage1_image + 1'b1; 
						rowCount_image <= rowCount_image;
					end
					else begin
						count_stage1_image <= rowCount_image*`IMAGECOL;
						rowCount_image <= rowCount_image + 1'b1;
					end
				end
				else begin
					count_stage1_image <= count_stage1_image;
					rowCount_image <= rowCount_image;
				end
			end
			else begin
				count_stage1_image <= 0;
				rowCount_image <= 7'b0000001;
			end
		end
		//start writing the output of convolution to the memory buffer once the done signal from the last stage of addition arrives
		if(done4_image && (writeCount_stage1_image < `CONVCOL*`CONVROW)) begin
			imageArray[writeCount_stage1_image] <= tempFinalOutput_stage1_image;
			writeCount_stage1_image <= writeCount_stage1_image + 1'b1;
		end
		else begin
			writeCount_stage1_image <= writeCount_stage1_image;
		end
	end	
	
	
	//internal signals for the Convolution of Image with the laplacian filter
	wire [3:0] input1_stage1_pattern;
	wire [3:0] input2_stage1_pattern;
	wire [3:0] input3_stage1_pattern;
	wire [3:0] input4_stage1_pattern;
	wire [3:0] input5_stage1_pattern;
	wire [4:0] tempOutput1_stage1_pattern;
	wire [4:0] tempOutput2_stage1_pattern;
	wire [5:0] tempOutput3_stage1_pattern;
	wire [4:0] tempOutput4_stage1_pattern;
	wire [4:0] tempOutput5_stage1_pattern;
	wire [6:0] tempOutput6_stage1_pattern;
	wire [5:0] tempOutput7_stage1_pattern;
	wire [7:0] tempFinalOutput_stage1_pattern;
		
	reg enable_stage1_pattern;
	wire done1_pattern;
	wire done2_pattern;
	wire done3_pattern;
	wire done4_pattern;
		
	reg [6:0] count_stage1_pattern;
	reg [6:0] writeCount_stage1_pattern = 0;
	reg [3:0] rowCount_pattern;
	
	ConvolutionStage1 c2_pattern(
		.clk(clk),
		.enable(enable_stage1_pattern),
		.input2(input1_stage1_pattern),
		.input4(input2_stage1_pattern),
		.input5(input3_stage1_pattern),
		.input6(input4_stage1_pattern),
		.input8(input5_stage1_pattern),
		.output1(tempOutput1_stage1_pattern),
		.output2(tempOutput2_stage1_pattern),
		.output3(tempOutput3_stage1_pattern),
		.output4(tempOutput4_stage1_pattern),
		.output5(tempOutput5_stage1_pattern),
		.done(done1_pattern)
	);
	
	adderStage2 add2_pattern(
		.input1(tempOutput1_stage1_pattern),
		.input2(tempOutput2_stage1_pattern),
		.input3(tempOutput3_stage1_pattern),
		.output1(tempOutput6_stage1_pattern),
		.clk(clk),
		.enable(done1_pattern),
		.done(done2_pattern)
	);
	
	adderStage3 add3_pattern(
		.input1(tempOutput4_stage1_pattern),
		.input2(tempOutput5_stage1_pattern),
		.output1(tempOutput7_stage1_pattern),
		.clk(clk),
		.enable(done1_pattern),
		.done(done3_pattern)
	);
	
	adderStage4 add4_pattern(
		.input1(tempOutput6_stage1_pattern),
		.input2(tempOutput7_stage1_pattern),
		.output1(tempFinalOutput_stage1_pattern),
		.clk(clk),
		.enable(done2_pattern),
		.done(done4_pattern)
	);
	
	//assigning values to the input signals for the convolution of pattern with the laplcian filter
	assign input1_stage1_pattern = (enable_stage1_pattern && (rowCount_pattern < `PATTERNROW - 1)) ? patternArray[count_stage1_pattern + 1][3:0] : 4'b0000;
	assign input2_stage1_pattern = (enable_stage1_pattern && (rowCount_pattern < `PATTERNROW - 1)) ? patternArray[count_stage1_pattern + 8][3:0] : 4'b0000;
	assign input3_stage1_pattern = (enable_stage1_pattern && (rowCount_pattern < `PATTERNROW - 1)) ? patternArray[count_stage1_pattern + 9][3:0] : 4'b0000;
	assign input4_stage1_pattern = (enable_stage1_pattern && (rowCount_pattern < `PATTERNROW - 1)) ? patternArray[count_stage1_pattern + 10][3:0] : 4'b0000;
	assign input5_stage1_pattern = (enable_stage1_pattern && (rowCount_pattern < `PATTERNROW - 1)) ? patternArray[count_stage1_pattern + 17][3:0] : 4'b0000;
	
	//always block for generating the address for creating the input signals and writing the output of convolution to the memory
	always @ (posedge clk) begin
		if(rst) begin
			enable_stage1_pattern <= 1'b0;
			count_stage1_pattern <= 0;
			rowCount_pattern <= 4'b0001;
		end
		else begin
			enable_stage1_pattern <= 1'b1;															//Once the enable_stage1_pattern is high, start generating the count_stage1_pattern values for creating the input values to ConvolutionStage1 module for pattern convolution
			if(enable_stage1_pattern) begin
				if(rowCount_pattern < `PATTERNROW - 1) begin
					if(count_stage1_pattern < (rowCount_pattern*`PATTERNCOL - 3)) begin
						count_stage1_pattern <= count_stage1_pattern + 1'b1; 
						rowCount_pattern <= rowCount_pattern;
					end
					else begin
						count_stage1_pattern <= rowCount_pattern*`PATTERNCOL;
						rowCount_pattern <= rowCount_pattern + 1'b1;
					end
				end
				else begin
					count_stage1_pattern <= count_stage1_pattern;
					rowCount_pattern <= rowCount_pattern;
				end
			end
			else begin
				count_stage1_pattern <= 0;
				rowCount_pattern <= 4'b0001;
			end
		end
		//start writing the output of convolution to the memory buffer once the done signal from the last stage of addition arrives
		if(done4_pattern && (writeCount_stage1_pattern<36)) begin
			patternArray[writeCount_stage1_pattern] <= tempFinalOutput_stage1_pattern;
			writeCount_stage1_pattern <= writeCount_stage1_pattern + 1'b1;
		end
		else begin
			writeCount_stage1_pattern <= writeCount_stage1_pattern;
		end
	end
	
	//internal signals for the Stage 2 of CNN, convolution of the outputs at the stage 1
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
	
	wire done1_1;
	wire done1_2;
	wire done1_3;
	wire done1_4;
	wire done1_5;
	wire done1_6;
	
	wire done2_1;
	wire done2_2;
	wire done2_3;
	wire done2_4;
	wire done2_5;
	wire done2_6;
	wire done2_7;
	wire done2_8;
	wire done2_9;
	wire done2_10;
	wire done2_11;
	wire done2_12;
	
	wire done3_1;
	wire done3_2;
	wire done3_3;
	wire done3_4;
	wire done3_5;
	wire done3_6;
	
	wire done4_1;
	wire done4_2;
	
	wire done5_1;
	
	reg enable_stage2_imagePattern;
	
	reg [6:0] rowCount_Stage2;
	reg [14:0] count_Stage2;
	reg [14:0] write_Stage2 = 0;
	
	wire [7:0] image_stage2_1;
	wire [7:0] image_stage2_2;
	wire [7:0] image_stage2_3;
	wire [7:0] image_stage2_4;
	wire [7:0] image_stage2_5;
	wire [7:0] image_stage2_6;
	wire [7:0] image_stage2_7;
	wire [7:0] image_stage2_8;
	wire [7:0] image_stage2_9;
	wire [7:0] image_stage2_10;
	wire [7:0] image_stage2_11;
	wire [7:0] image_stage2_12;
	wire [7:0] image_stage2_13;
	wire [7:0] image_stage2_14;
	wire [7:0] image_stage2_15;
	wire [7:0] image_stage2_16;
	wire [7:0] image_stage2_17;
	wire [7:0] image_stage2_18;
	wire [7:0] image_stage2_19;
	wire [7:0] image_stage2_20;
	wire [7:0] image_stage2_21;
	wire [7:0] image_stage2_22;
	wire [7:0] image_stage2_23;
	wire [7:0] image_stage2_24;
	wire [7:0] image_stage2_25;
	wire [7:0] image_stage2_26;
	wire [7:0] image_stage2_27;
	wire [7:0] image_stage2_28;
	wire [7:0] image_stage2_29;
	wire [7:0] image_stage2_30;
	wire [7:0] image_stage2_31;
	wire [7:0] image_stage2_32;
	wire [7:0] image_stage2_33;
	wire [7:0] image_stage2_34;
	wire [7:0] image_stage2_35;
	wire [7:0] image_stage2_36;
	
	ConvolutionStage2 c1(
		.clk(clk),
		.enable(enable_stage2_imagePattern),
		.input1(image_stage2_1),
		.input2(image_stage2_2),
		.input3(image_stage2_3),
		.input4(image_stage2_4),
		.input5(image_stage2_5),
		.input6(image_stage2_6),
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
		.output6(tempOutput6),
		.done(done1_1)
	);
	
	ConvolutionStage2 c2(
		.clk(clk),
		.enable(enable_stage2_imagePattern),
		.input1(image_stage2_7),
		.input2(image_stage2_8),
		.input3(image_stage2_9),
		.input4(image_stage2_10),
		.input5(image_stage2_11),
		.input6(image_stage2_12),
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
		.output6(tempOutput12),
		.done(done1_2)
	);
	
	ConvolutionStage2 c3(
		.clk(clk),
		.enable(enable_stage2_imagePattern),
		.input1(image_stage2_13),
		.input2(image_stage2_14),
		.input3(image_stage2_15),
		.input4(image_stage2_16),
		.input5(image_stage2_17),
		.input6(image_stage2_18),
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
		.output6(tempOutput18),
		.done(done1_3)
	);
	
	ConvolutionStage2 c4(
		.clk(clk),
		.enable(enable_stage2_imagePattern),
		.input1(image_stage2_19),
		.input2(image_stage2_20),
		.input3(image_stage2_21),
		.input4(image_stage2_22),
		.input5(image_stage2_23),
		.input6(image_stage2_24),
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
		.output6(tempOutput24),
		.done(done1_4)
	);
	
	ConvolutionStage2 c5(
		.clk(clk),
		.enable(enable_stage2_imagePattern),
		.input1(image_stage2_25),
		.input2(image_stage2_26),
		.input3(image_stage2_27),
		.input4(image_stage2_28),
		.input5(image_stage2_29),
		.input6(image_stage2_30),
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
		.output6(tempOutput30),
		.done(done1_5)
	);
	
	ConvolutionStage2 c6(
		.clk(clk),
		.enable(enable_stage2_imagePattern),
		.input1(image_stage2_31),
		.input2(image_stage2_32),
		.input3(image_stage2_33),
		.input4(image_stage2_34),
		.input5(image_stage2_35),
		.input6(image_stage2_36),
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
		.output6(tempOutput36),
		.done(done1_6)
	);
	
	adderStage2_2 add1(
		.input1(tempOutput1),
		.input2(tempOutput2),
		.input3(tempOutput3),
		.output1(tempOutput37),
		.enable(done1_1),
		.clk(clk),
		.done(done2_1)
	);
	
	adderStage2_2 add2(
		.input1(tempOutput4),
		.input2(tempOutput5),
		.input3(tempOutput6),
		.output1(tempOutput38),
		.enable(done1_1),
		.clk(clk),
		.done(done2_2)
	);
	
	adderStage2_2 add3(
		.input1(tempOutput7),
		.input2(tempOutput8),
		.input3(tempOutput9),
		.output1(tempOutput39),
		.enable(done1_2),
		.clk(clk),
		.done(done2_3)
	);
	
	adderStage2_2 add4(
		.input1(tempOutput10),
		.input2(tempOutput11),
		.input3(tempOutput12),
		.output1(tempOutput40),
		.enable(done1_2),
		.clk(clk),
		.done(done2_4)
	);
	
	adderStage2_2 add5(
		.input1(tempOutput13),
		.input2(tempOutput14),
		.input3(tempOutput15),
		.output1(tempOutput41),
		.enable(done1_3),
		.clk(clk),
		.done(done2_5)
	);
	
	adderStage2_2 add6(
		.input1(tempOutput16),
		.input2(tempOutput17),
		.input3(tempOutput18),
		.output1(tempOutput42),
		.enable(done1_3),
		.clk(clk),
		.done(done2_6)
	);
	
	adderStage2_2 add7(
		.input1(tempOutput19),
		.input2(tempOutput20),
		.input3(tempOutput21),
		.output1(tempOutput43),
		.enable(done1_4),
		.clk(clk),
		.done(done2_7)
	);
	
	adderStage2_2 add8(
		.input1(tempOutput22),
		.input2(tempOutput23),
		.input3(tempOutput24),
		.output1(tempOutput44),
		.enable(done1_4),
		.clk(clk),
		.done(done2_8)
	);
	
	adderStage2_2 add9(
		.input1(tempOutput25),
		.input2(tempOutput26),
		.input3(tempOutput27),
		.output1(tempOutput45),
		.enable(done1_5),
		.clk(clk),
		.done(done2_9)
	);
	
	adderStage2_2 add10(
		.input1(tempOutput28),
		.input2(tempOutput29),
		.input3(tempOutput30),
		.output1(tempOutput46),
		.enable(done1_5),
		.clk(clk),
		.done(done2_10)
	);
	
	adderStage2_2 add11(
		.input1(tempOutput31),
		.input2(tempOutput32),
		.input3(tempOutput33),
		.output1(tempOutput47),
		.enable(done1_6),
		.clk(clk),
		.done(done2_11)
	);
	
	adderStage2_2 add12(
		.input1(tempOutput34),
		.input2(tempOutput35),
		.input3(tempOutput36),
		.output1(tempOutput48),
		.enable(done1_6),
		.clk(clk),
		.done(done2_12)
	);
	
	adderStage3_2 add3_1(
		.input1(tempOutput37),
		.input2(tempOutput38),
		.output1(tempOutput49),
		.enable(done2_1),
		.clk(clk),
		.done(done3_1)
	);
	adderStage3_2 add3_2(
		.input1(tempOutput39),
		.input2(tempOutput40),
		.output1(tempOutput50),
		.enable(done2_3),
		.clk(clk),
		.done(done3_2)
	);
	adderStage3_2 add3_3(
		.input1(tempOutput41),
		.input2(tempOutput42),
		.output1(tempOutput51),
		.enable(done2_5),
		.clk(clk),
		.done(done3_3)
	);
	adderStage3_2 add3_4(
		.input1(tempOutput43),
		.input2(tempOutput44),
		.output1(tempOutput52),
		.enable(done2_7),
		.clk(clk),
		.done(done3_4)
	);
	adderStage3_2 add3_5(
		.input1(tempOutput45),
		.input2(tempOutput46),
		.output1(tempOutput53),
		.enable(done2_9),
		.clk(clk),
		.done(done3_5)
	);
	adderStage3_2 add3_6(
		.input1(tempOutput47),
		.input2(tempOutput48),
		.output1(tempOutput54),
		.enable(done2_11),
		.clk(clk),
		.done(done3_6)
	);
	
	adderStage4_2 add4_1(
		.input1(tempOutput49),
		.input2(tempOutput50),
		.input3(tempOutput51),
		.output1(tempOutput55),
		.enable(done3_1),
		.clk(clk),
		.done(done4_1)
	);
	adderStage4_2 add4_2(
		.input1(tempOutput52),
		.input2(tempOutput53),
		.input3(tempOutput54),
		.output1(tempOutput56),
		.enable(done3_4),
		.clk(clk),
		.done(done4_2)
	);
	
	adderStage5_2 add5_1(
		.input1(tempOutput55),
		.input2(tempOutput56),
		.output1(tempOutput57),
		.enable(done4_1),
		.clk(clk),
		.done(done5_1)
	);
	
	//assigning values to the input signals for the convolution operation in stage 2
	assign image_stage2_1 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+0] : 8'b00000000;
	assign image_stage2_2 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+1] : 8'b00000000;
	assign image_stage2_3 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+2] : 8'b00000000;
	assign image_stage2_4 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+3] : 8'b00000000;
	assign image_stage2_5 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+4] : 8'b00000000;
	assign image_stage2_6 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+5] : 8'b00000000;
	assign image_stage2_7 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+126] : 8'b00000000;
	assign image_stage2_8 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+127] : 8'b00000000;
	assign image_stage2_9 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+128] : 8'b00000000;
	assign image_stage2_10 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+129] : 8'b00000000;
	assign image_stage2_11 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+130] : 8'b00000000;
	assign image_stage2_12 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+131] : 8'b00000000;
	assign image_stage2_13 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+252] : 8'b00000000;
	assign image_stage2_14 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+253] : 8'b00000000;
	assign image_stage2_15 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+254] : 8'b00000000;
	assign image_stage2_16 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+255] : 8'b00000000;
	assign image_stage2_17 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+256] : 8'b00000000;
	assign image_stage2_18 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+257] : 8'b00000000;
	assign image_stage2_19 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+378] : 8'b00000000;
	assign image_stage2_20 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+379] : 8'b00000000;
	assign image_stage2_21 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+380] : 8'b00000000;
	assign image_stage2_22 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+381] : 8'b00000000;
	assign image_stage2_23 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+382] : 8'b00000000;
	assign image_stage2_24 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+383] : 8'b00000000;
	assign image_stage2_25 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+504] : 8'b00000000;
	assign image_stage2_26 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+505] : 8'b00000000;
	assign image_stage2_27 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+506] : 8'b00000000;
	assign image_stage2_28 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+507] : 8'b00000000;
	assign image_stage2_29 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+508] : 8'b00000000;
	assign image_stage2_30 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+509] : 8'b00000000;
	assign image_stage2_31 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+630] : 8'b00000000;
	assign image_stage2_32 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+631] : 8'b00000000;
	assign image_stage2_33 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+632] : 8'b00000000;
	assign image_stage2_34 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+633] : 8'b00000000;
	assign image_stage2_35 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+634] : 8'b00000000;
	assign image_stage2_36 = (enable_stage2_imagePattern && (rowCount_pattern < `CONVROW - 1)) ? imageArray[count_Stage2+635] : 8'b00000000;
	
	//always block for generating the address for creating the input signals and writing the output of convolution to the memory
	always @ (posedge clk) begin
		if(rst || count_stage1_image < 16128) begin														//enable_stage2_imagePattern will be high only only after all the output values are written to imageArray		
			enable_stage2_imagePattern <= 1'b0;
			count_Stage2 <= 0;
			rowCount_Stage2 <= 7'b0000001;
		end
		else begin
			enable_stage2_imagePattern <= 1'b1;															//Once the enable_stage2_imagePattern is high, start generating the count_Stage2 values for creating the input values to ConvolutionStage1 module for pattern convolution
			if(enable_stage2_imagePattern) begin
				if(rowCount_Stage2 < `CONVROW - 4) begin
					if(count_Stage2 < (rowCount_Stage2*`CONVCOL - 6)) begin
						count_Stage2 <= count_Stage2 + 1'b1; 
						rowCount_Stage2 <= rowCount_Stage2;
					end
					else begin
						count_Stage2 <= rowCount_Stage2*`CONVCOL;
						rowCount_Stage2 <= rowCount_Stage2 + 1'b1;
					end
				end
				else begin
					count_Stage2 <= count_Stage2;
					rowCount_Stage2 <= rowCount_Stage2;
				end
			end
			else begin
				count_Stage2 <= 0;
				rowCount_Stage2 <= 7'b0000001;
			end
		end
		//start writing the output of convolution to the memory buffer once the done signal from the last stage of addition arrives
		if(done5_1 && (write_Stage2 < 14641)) begin
			stage2Output[write_Stage2] <= tempOutput57;
			write_Stage2 <= write_Stage2 + 1'b1;
		end
		else begin
			write_Stage2 <= write_Stage2;
		end
	end
	
	
	//internal signals for maxPooling layer
	wire [21:0] input_maxpooling_1;
	wire [21:0] input_maxpooling_2;
	wire [21:0] input_maxpooling_3;
	wire [21:0] input_maxpooling_4;
	
	wire maxPoolingDone;
	reg enable_maxPooling;
	
	reg [6:0] rowCount_Stage_maxpooling;
	reg [14:0] count_Stage_maxpooling;
	reg [11:0] write_Stage_maxpooling = 0;
	
	wire [21:0] maxPooling_Output;
	
	maxPooling m1(
		.clk(clk),
		.input1(input_maxpooling_1),
		.input2(input_maxpooling_2),
		.input3(input_maxpooling_3),
		.input4(input_maxpooling_4),
		.enable(enable_maxPooling),
		.output1(maxPooling_Output),
		.maxPoolingDone(maxPoolingDone)
    	);
	//assigning values to the input signals for the max pooling layer
	assign input_maxpooling_1 = (enable_maxPooling && (rowCount_Stage_maxpooling < `MAXROW - 1)) ?  stage2Output[count_Stage_maxpooling+0] : 22'b0;
	assign input_maxpooling_2 = (enable_maxPooling && (rowCount_Stage_maxpooling < `MAXROW - 1)) ?  stage2Output[count_Stage_maxpooling+1] : 22'b0;
	assign input_maxpooling_3 = (enable_maxPooling && (rowCount_Stage_maxpooling < `MAXROW - 1)) ?  stage2Output[count_Stage_maxpooling+121] : 22'b0;
	assign input_maxpooling_4 = (enable_maxPooling && (rowCount_Stage_maxpooling < `MAXROW - 1)) ?  stage2Output[count_Stage_maxpooling+122] : 22'b0;
	
	//always block for generating the address for creating the input signals and writing the output of convolution to the memory
	always @ (posedge clk) begin
		if(rst || count_Stage2 < 15246) begin													//enable_maxPooling will be high only only after all the output values are written to imageArray		
			enable_maxPooling <= 1'b0;
			count_Stage_maxpooling <= 0;
			rowCount_Stage_maxpooling <= 6'b000001;
		end
		else begin
			enable_maxPooling <= 1'b1;															//Once the enable_maxPooling is high, start generating the count_Stage_maxpooling values for creating the input values to ConvolutionStage1 module for pattern convolution
			if(enable_maxPooling) begin
				if(rowCount_Stage_maxpooling < `MAXROW) begin
					if(count_Stage_maxpooling + 2 < (rowCount_Stage_maxpooling*`MAXCOL - 1)) begin
						count_Stage_maxpooling <= count_Stage_maxpooling + 2'b10; 
						rowCount_Stage_maxpooling <= rowCount_Stage_maxpooling;
					end
					else begin
						count_Stage_maxpooling <= (rowCount_Stage_maxpooling + 1'b1)*`MAXCOL;
						rowCount_Stage_maxpooling <= rowCount_Stage_maxpooling + 2'b10;
					end
				end
				else begin
					count_Stage_maxpooling <= count_Stage_maxpooling;
					rowCount_Stage_maxpooling <= rowCount_Stage_maxpooling;
				end
			end
			else begin
				count_Stage_maxpooling <= 0;
				rowCount_Stage_maxpooling <= 6'b000001;
			end
		end
		//start writing the output of convolution to the memory buffer once the done signal from the last stage of addition arrives
		if(maxPoolingDone && (write_Stage_maxpooling < 3600)) begin
			stage3Output[write_Stage_maxpooling] <= maxPooling_Output;
			write_Stage_maxpooling <= write_Stage_maxpooling + 1'b1;
		end
		else begin
			write_Stage_maxpooling <= write_Stage_maxpooling;
		end
	end
	
	reg [11:0] sort_counter = 0;
	
	//using thresholding to find the number of times the test pattern is detected in the input image
	always @ (posedge clk) begin
		if(write_Stage_maxpooling == 3600) begin
			if(sort_counter < 3600) begin
				if($signed(22'b0000000000101001000110) <= $signed(stage3Output[sort_counter])) begin
					numberOfTimes_PatterDetected <= numberOfTimes_PatterDetected + 1'b1;
				end
				else begin
					numberOfTimes_PatterDetected <= numberOfTimes_PatterDetected;
				end
				sort_counter <= sort_counter + 1'b1;
			end
			else begin
				numberOfTimes_PatterDetected <= numberOfTimes_PatterDetected;
				sort_counter <= sort_counter;
			end
		end
		else begin
			numberOfTimes_PatterDetected <= 0;
			sort_counter <= 0;
		end
	end
	

endmodule
