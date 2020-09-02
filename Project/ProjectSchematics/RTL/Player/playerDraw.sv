
module	playerDraw	(	
					input	logic	clk,
					input	logic	resetN,
					input logic signed [1:0] [10:0]	offsetCoordinate,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					input logic flash,
					input	logic	left,  //turn left
					input	logic	right,  //turn right
					input logic isActive, //player alive
					input logic invincible, //shield active

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

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] regular_player;

logic [0:OBJECT_WIDTH_X-1] [0:OBJECT_HEIGHT_Y-1] [8-1:0] shielded_player;

assign regular_player = object_colors;
assign shielded_player = object_colors;

*/


logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] regular_player = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h4F, 8'h4F, 8'h4A, 8'h4A, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h4F, 8'h4F, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h4F, 8'h4F, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hF1, 8'hF1, 8'h00, 8'h4F, 8'h4F, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'h00, 8'hF1, 8'hF1, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'h4F, 8'h4F, 8'h4A, 8'h4A, 8'h4A, 8'h4A, 8'hFF, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'hE0, 8'h4F, 8'h4A, 8'h4A, 8'h4A, 8'hE0, 8'hFF, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'hE0, 8'hE0, 8'h00, 8'h00, 8'hE0, 8'hE0, 8'hFF, 8'hFF, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
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
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCC, 8'hE0, 8'hE0, 8'hCC, 8'hE0, 8'hE0, 8'hF5, 8'hCC, 8'hE0, 8'hE0, 8'hCC, 8'hE0, 8'hE0, 8'hCC, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCC, 8'hE0, 8'hE0, 8'hCC, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hCC, 8'hE0, 8'hE0, 8'hCC, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCC, 8'hE0, 8'hCC, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hCC, 8'hE0, 8'hCC, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCC, 8'hCC, 8'hE0, 8'hE0, 8'hE0, 8'hE0, 8'hCC, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hCC, 8'hCC, 8'hCC, 8'hCC, 8'hB6, 8'hB6, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};



logic [0:OBJECT_WIDTH_X-1] [0:OBJECT_HEIGHT_Y-1] [8-1:0] shielded_player = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h16, 8'h67, 8'h67, 8'h67, 8'h67, 8'h16, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h16, 8'hBB, 8'h67, 8'h67, 8'h26, 8'h26, 8'h26, 8'h26, 8'hBB, 8'h16, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h16, 8'hBB, 8'hBB, 8'hBB, 8'h67, 8'h26, 8'h26, 8'h26, 8'h26, 8'h26, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBB, 8'h49, 8'h13, 8'h13, 8'h49, 8'h67, 8'h26, 8'h26, 8'h26, 8'h26, 8'h26, 8'h49, 8'h13, 8'h13, 8'h49, 8'hBB, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBB, 8'hBB, 8'hBB, 8'h49, 8'hBB, 8'hBB, 8'h67, 8'h26, 8'h26, 8'h26, 8'h26, 8'h26, 8'hBB, 8'hBB, 8'h49, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBB, 8'hBB, 8'hDF, 8'hDF, 8'h49, 8'hBB, 8'hBB, 8'hA3, 8'h26, 8'h26, 8'h26, 8'h26, 8'hA3, 8'hBB, 8'hBB, 8'h49, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBB, 8'hDF, 8'hDF, 8'hDF, 8'h49, 8'hBB, 8'hBB, 8'hA3, 8'hA3, 8'h49, 8'h49, 8'hA3, 8'hA3, 8'hBB, 8'hBB, 8'h49, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBB, 8'hBB, 8'hDF, 8'hDF, 8'hDF, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBB, 8'hDF, 8'hDF, 8'hDF, 8'hDF, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBB, 8'hBB, 8'hDF, 8'hDF, 8'hDF, 8'hDF, 8'hBB, 8'hBB, 8'hA3, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'hA3, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBB, 8'hDF, 8'hDF, 8'hDF, 8'hDF, 8'hBB, 8'hBB, 8'hBB, 8'hA3, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'hA3, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBB, 8'hDF, 8'hDF, 8'hDF, 8'hDF, 8'hBB, 8'hBB, 8'hBB, 8'hA3, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'hA3, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h16, 8'hBB, 8'hBB, 8'hDF, 8'hDF, 8'hDF, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hA3, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'h49, 8'hA3, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h16, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hA3, 8'h49, 8'h44, 8'h44, 8'h44, 8'h44, 8'h49, 8'hA3, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h16, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h6A, 8'h6A, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h6A, 8'h6A, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF, 8'hFF },
{8'hFF, 8'h16, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h6A, 8'hA3, 8'hA3, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'h44, 8'hA3, 8'hA3, 8'h6A, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF },
{8'hFF, 8'h16, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h6A, 8'hA3, 8'h6A, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'h6A, 8'hA3, 8'h6A, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF },
{8'hFF, 8'h16, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h6A, 8'hA3, 8'h6A, 8'h6A, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'h6A, 8'h6A, 8'hA3, 8'h6A, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF },
{8'hFF, 8'h16, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h6A, 8'hA3, 8'h6A, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'h6A, 8'hA3, 8'h6A, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF },
{8'hFF, 8'h16, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h6A, 8'hA3, 8'h6A, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'h6A, 8'hA3, 8'h6A, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF },
{8'hFF, 8'hFF, 8'h16, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h6A, 8'hA3, 8'h6A, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'h6A, 8'hA3, 8'h6A, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h16, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h6A, 8'hA3, 8'hA3, 8'h6A, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'h6A, 8'hA3, 8'hA3, 8'h6A, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h16, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h6A, 8'hA3, 8'hA3, 8'h6A, 8'hA3, 8'hA3, 8'h95, 8'h12, 8'hA3, 8'hA3, 8'h6A, 8'hA3, 8'hA3, 8'h6A, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h6A, 8'hA3, 8'hA3, 8'h6A, 8'hA3, 8'hA3, 8'h95, 8'h12, 8'hA3, 8'hA3, 8'h6A, 8'hA3, 8'hA3, 8'h6A, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h6A, 8'hA3, 8'hA3, 8'h6A, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'h6A, 8'hA3, 8'hA3, 8'h6A, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h6A, 8'hA3, 8'h6A, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'h6A, 8'hA3, 8'h6A, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h6A, 8'h6A, 8'hA3, 8'hA3, 8'hA3, 8'hA3, 8'h6A, 8'hB6, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h6A, 8'h6A, 8'h6A, 8'h6A, 8'hB6, 8'hB6, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h16, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h49, 8'h49, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h16, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h49, 8'h49, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h16, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'hBB, 8'h16, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h16, 8'h16, 8'h16, 8'h16, 8'h16, 8'h16, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};



logic [0:OBJECT_WIDTH_X-1] [0:OBJECT_HEIGHT_Y-1] [8-1:0] object_colors; 
assign object_colors = invincible ? shielded_player : regular_player;





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
