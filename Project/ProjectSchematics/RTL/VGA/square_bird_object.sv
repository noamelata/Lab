//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// System-Verilog Alex Grinshpun May 2018
// New coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	square_bird_object	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	[10:0] pixelX,// current VGA pixel 
					input 	logic	[10:0] pixelY,
					input 	logic signed [10:0] topLeftX, //position on the screen 
					input 	logic	signed [10:0] topLeftY,
					
					output 	logic	[10:0] offsetX,// offset inside bracket from top left position 
					output 	logic	[10:0] offsetY,
					output	logic	drawingRequest_left, // indicates pixel inside the left side of bracket
					output	logic	drawingRequest_middle, // indicates pixel inside the middle of bracket
					output	logic	drawingRequest_right, // indicates pixel inside the right side of bracket
					output	logic	[7:0]	 RGBout //optional color output for mux 
);

parameter  int OBJECT_WIDTH_X = 96;
parameter  int OBJECT_HEIGHT_Y = 32;
parameter  logic [7:0] OBJECT_COLOR = 8'h5b ; 
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// bitmap  representation for a transparent pixel 
 
int rightX ; //coordinates of the sides  
int bottomY ;
logic insideBracket_left ; 
logic insideBracket_middle ; 
logic insideBracket_right ; 

//////////--------------------------------------------------------------------------------------------------------------=
// Calculate object right  & bottom  boundaries
assign right_firstX	= (topLeftX + 32);
assign right_secondX	= (topLeftX + 64);
assign right_thirdX	= (topLeftX + OBJECT_WIDTH_X);
assign bottomY	= (topLeftY + OBJECT_HEIGHT_Y);


//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout			<=	8'b0;
		drawingRequest_left	<=	1'b0;
		drawingRequest_middle	<=	1'b0;
		drawingRequest_right	<=	1'b0;
	end
	else begin 
	
//		if ( (pixelX  >= topLeftX) &&  (pixelX < rightX) 
//			&& (pixelY  >= topLeftY) &&  (pixelY < bottomY) ) // test if it is inside the rectangle 

		//this is an example of using blocking sentence inside an always_ff block, 
		//and not waiting a clock to use the result  
		insideBracket_left  = 	 ( (pixelX  >= topLeftX) &&  (pixelX < right_firstX) // ----- LEGAL BLOCKING ASSINGMENT in ALWAYS_FF CODE 
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY) )  ; 
		insideBracket_middle  = 	 ( (pixelX  >= right_firstX) &&  (pixelX < right_secondX) 
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY) )  ; 
		insideBracket_right  = 	 ( (pixelX  >= right_secondX) &&  (pixelX < right_thirdX)
						   && (pixelY  >= topLeftY) &&  (pixelY < bottomY) )  ; 
		
		drawingRequest_left <= 1'b0 ;// transparent color 
		drawingRequest_middle <= 1'b0 ;
		drawingRequest_right <= 1'b0 ;
		offsetX	<= (pixelX - topLeftX); //calculate relative offsets from top left corner
		offsetY	<= (pixelY - topLeftY);
		
		if (insideBracket_left) // test if it is inside the rectangle 
		begin 
			RGBout  <= OBJECT_COLOR ;	// colors table 
			drawingRequest_left <= 1'b1 ;	
		end 
		else if (insideBracket_middle) begin
			RGBout  <= OBJECT_COLOR ;	// colors table 
			drawingRequest_middle <= 1'b1 ;
		end 
		else if (insideBracket_right) begin
			RGBout  <= OBJECT_COLOR ;	// colors table 
			drawingRequest_right <= 1'b1 ;
		end 
		else begin  
			RGBout <= TRANSPARENT_ENCODING ; // so it will not be displayed 
			offsetX	<= 0; //no offset
			offsetY	<= 0; //no offset
		end 
	end
end 
endmodule 