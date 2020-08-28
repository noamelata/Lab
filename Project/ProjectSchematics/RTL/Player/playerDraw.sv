
module	playerDraw	(	
					input	logic	clk,
					input	logic	resetN,
					input logic signed [1:0] [10:0]	offsetCoordinate,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					input logic flash,
					input	logic	left,  //turn left
					input	logic	right,  //turn right
					input logic isActive, //player alive

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
 ) ;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 5;  // 2^5 = 32 
localparam  int OBJECT_NUMBER_OF_X_BITS = 5;  // 2^5 = 32 
parameter RED = 8'hE0;

localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_HEIGHT_Y_DIVIDER = OBJECT_NUMBER_OF_Y_BITS - 2; //how many pixel bits are in every collision pixel
localparam  int OBJECT_WIDTH_X_DIVIDER =  OBJECT_NUMBER_OF_X_BITS - 2;

// generating a smiley bitmap

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 

/*
logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
{8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88, 8'h88 },
};
*/

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h4F, 8'h4F, 8'h4A, 8'h4A, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h4F, 8'h4F, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h4F, 8'h4F, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hF1, 8'hF1, 8'h00, 8'h4F, 8'h4F, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h00, 8'hF1, 8'hF1, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'h4F, 8'h4F, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'hFF, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'hE0, 8'h4F, 8'h4A, 8'h4A, 8'h4A, 8'hE0, 8'hFF, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'hE0, 8'hE0, 8'h00, 8'h00, 8'hE0, 8'hE0, 8'hFB, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hE0, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hE0, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hE0, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hE0, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hE0, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hE0, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hE0, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hE0, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hE0, 8'h00, 8'h69, 8'h69, 8'h69, 8'h69, 8'h00, 8'hE0, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCC, 8'hCC, 8'h69, 8'h69, 8'h69, 8'h69, 8'h69, 8'h69, 8'hCC, 8'hCC, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCC, 8'hE0, 8'hCC, 8'h69, 8'h69, 8'h69, 8'h69, 8'h69, 8'h69, 8'hCC, 8'hE0, 8'hCC, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCC, 8'hE0, 8'hE0, 8'hCC, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hCC, 8'hE0, 8'hE0, 8'hCC, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCC, 8'hE0, 8'hE0, 8'hCC, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hCC, 8'hED, 8'hE0, 8'hCC, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCC, 8'hE0, 8'hCC, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hCC, 8'hE0, 8'hCC, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCC, 8'hE0, 8'hCC, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hCC, 8'hE0, 8'hCC, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCC, 8'hE0, 8'hCC, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hCC, 8'hE0, 8'hCC, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCC, 8'hE0, 8'hE0, 8'hCC, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hCC, 8'hE0, 8'hE0, 8'hCC, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCC, 8'hE0, 8'hE0, 8'hCC, 8'hE0, 8'hE0, 8'hF5, 8'hCC, 8'hE0, 8'hE0, 8'hCC, 8'hE0, 8'hE0, 8'hCC, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCC, 8'hE0, 8'hE0, 8'hCC, 8'hE0, 8'hE0, 8'hF5, 8'hCC, 8'hE0, 8'hE0, 8'hCC, 8'hE0, 8'hC9, 8'hCC, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCC, 8'hE0, 8'hE0, 8'hCC, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hCC, 8'hE0, 8'hE0, 8'hCC, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCC, 8'hE0, 8'hCC, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hCC, 8'hE0, 8'hCC, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCC, 8'hCC, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hCC, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCC, 8'hCC, 8'hCC, 8'hCC, 8'hB6, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};

/*
logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [4-1:0] object_colors = {
{128'hFFFFFFFFFFFFFF5555FFFFFFFFFFFFFF},
{128'hFFFFFFFFFFFFF571555FFFFFFFFFFFFF},
{128'hFFFFFFFFFFFFF555555FFFFFFFFFFFFF},
{128'hFFFFFFFFF09905555550990FFFFFFFFF},
{128'hFFFFFFFFFF0FF555554FF0FFFFFFFFFF},
{128'hFFFFFFFFFF0FF555559FF0FFFFFFFFFF},
{128'hFFFFFFFFFF0FF890088FF0FFFFFFFFFF},
{128'hFFFFFFFFFF000000000000FFFFFFFFFF},
{128'hFFFFFFFFFF000000000000FFFFFFFFFF},
{128'hFFFFFFFFFFFF80000008FFFFFFFFFFFF},
{128'hFFFFFFFFFFFF84000048FFFFFFFFFFFF},
{128'hFFFFFFFFFFFF84000048FFFFFFFFFFFF},
{128'hFFFFFFFFFFFF84000048FFFFFFFFFFFF},
{128'hFFFFFFFFFFFF84444448FFFFFFFFFFFF},
{128'hFFFFFFFFFFFEE884488EEFFFFFFFFFFF},
{128'hFFFFFFFFFFE8888888888EFFFFFFFFFF},
{128'hFFFFFFFFFFECECCCCCCECEFFFFFFFFFF},
{128'hFFFFFFFFFE8EECCCCCCEC8EFFFFFFFFF},
{128'hFFFFFFFFFECCCCCCCCCCE8EFFFFFFFFF},
{128'hFFFFFFFFFECCCCCCCCCCECEFFFFFFFFF},
{128'hFFFFFFFFFECCCCCCCCCCC8EFFFFFFFFF},
{128'hFFFFFFFFFECCCCCCCCCECCEFFFFFFFFF},
{128'hFFFFFFFFFECCECCEECCCC8EFFFFFFFFF},
{128'hFFFFFFFFFACCCCCEECCCC8EFFFFFFFFF},
{128'hFFFFFFFFFFE8CECCCCCCCEFFFFFFFFFF},
{128'hFFFFFFFFFFFE8ECCCCE8EFFFFFFFFFFF},
{128'hFFFFFFFFFFFFEECCCCEFFFFFFFFFFFFF},
{128'hFFFFFFFFFFFFFFEEEEFBFFFFFFFFFFFF},
{128'hFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFF},
{128'hFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFF},
{128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF},
{128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
};
*/


// pipeline (ff) to get the pixel color from the array 	 

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin
	
		if (InsideRectangle == 1'b1 ) begin  // inside an external bracket 
			if (flash && (object_colors[offsetCoordinate[1]][offsetCoordinate[0]] != TRANSPARENT_ENCODING)) begin
				RGBout <= RED;
			end else begin
				RGBout <= object_colors[offsetCoordinate[1]][offsetCoordinate[0]];
			end
		end else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = ((RGBout != TRANSPARENT_ENCODING) && isActive) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule
