
module	barDraw (
		input	logic	clk,
		input	logic	resetN,
		input logic signed  [1:0] [10:0] coordinate,
		input	logic	InsideRectangle, //input that the pixel is within a bracket  

		output	logic	drawingRequest, //output that the pixel should be dispalyed 
		output	logic	[7:0] RGBout  //rgb value from the bitmap 
 ) ;

// this is the devider used to access the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 0;  // 2^0 = 1 
localparam  int OBJECT_NUMBER_OF_X_BITS = 0;  // 2^0 = 1 
localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;
 
localparam logic [7:0] top_bar_color = 8'h88 ;
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 



// pipeline (ff) to get the pixel color from the array 	 

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin 
		if(InsideRectangle)
			RGBout <= top_bar_color;
		else
			RGBout <= TRANSPARENT_ENCODING;
		
	end 
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule