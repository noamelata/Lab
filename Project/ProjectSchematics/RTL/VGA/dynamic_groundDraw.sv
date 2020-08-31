
module	dynamic_groundDraw (
					input	logic	clk,
					input	logic	resetN,
					input logic signed  [1:0] [10:0] coordinate,
					input	logic	InsideRectangle, //input that the pixel is within a bracket  
					input logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors,

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
 ) ;

// this is the devider used to access the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 6;  // 2^5 = 32 
localparam  int OBJECT_NUMBER_OF_X_BITS = 5;  // 2^5 = 32 


localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;
 

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 



// pipeline (ff) to get the pixel color from the array 	 

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin 

		RGBout <= object_colors[coordinate[1]][coordinate[0]];
		
		/*
		if ((InsideRectangle == 1'b1))  // inside an external bracket 
			RGBout <= object_colors[coordinate[1]][coordinate[0]];
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
		*/
		
	end 
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule
