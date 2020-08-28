
module	birdDraw	(	
					input	logic	clk,
					input	logic	resetN,
					input logic signed [1:0] [10:0]	coordinate,
					input	logic	InsideRectangle, //input that the pixel is within a leftside bracket  
					input logic flash,
					input logic alive,

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
 ) ;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 5;  // 2^5 = 32 
localparam  int OBJECT_NUMBER_OF_X_BITS = 2;  // 2^5 = 32 

//for left wing (invert of right wing BITMAP)
logic [10:0] Inverted_offsetX;
logic [10:0] Inverted_offsetY;
assign Inverted_offsetX = OBJECT_WIDTH_X - coordinate[0];
assign Inverted_offsetY = OBJECT_HEIGHT_Y - coordinate[1];


localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_HEIGHT_Y_DIVIDER = OBJECT_NUMBER_OF_Y_BITS - 2; //how many pixel bits are in every collision pixel
localparam  int OBJECT_WIDTH_X_DIVIDER =  OBJECT_NUMBER_OF_X_BITS - 2;

parameter DARK_COLOR = 8'hFF; //PLACEHOLDER PLEASE CHANGE
parameter LIGHT_COLOR = 8'hFF; //PLACEHOLDER PLEASE CHANGE
parameter RED = 8'hE0;
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 

/*
logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
{8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F, 8'h0F },
};

*/

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h86, 8'h86, 8'h86, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h86, 8'h86, 8'h86, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h86, 8'h86, 8'h00, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h00, 8'h86, 8'h86, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86 },
{8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86 },
{8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86 },
{8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86 },
{8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86 },
{8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h00, 8'h86, 8'h86, 8'h00, 8'h00, 8'h86, 8'h86, 8'h00, 8'h00, 8'h86, 8'h86, 8'h00, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86 },
{8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h00, 8'h00, 8'h86, 8'h86, 8'h00, 8'h00, 8'h86, 8'h86, 8'h00, 8'h00, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86 },
{8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86 },
{8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86 },
{8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86 },
{8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86 },
{8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86 },
{8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86 },
{8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86 },
{8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h00, 8'h00, 8'h00, 8'h00, 8'h86, 8'h86, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86 },
{8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h86, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};








// pipeline (ff) to get the pixel color from the array 	 

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else
	begin
		if (InsideRectangle == 1'b1 ) // inside an external leftside bracket 
		begin
			if (flash && (object_colors[coordinate[1]][coordinate[0]] != TRANSPARENT_ENCODING))
			begin
				RGBout <= RED;
			end
			else 
			begin
				RGBout <= object_colors[coordinate[1]][coordinate[0]];	
			end
		end 
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = ((RGBout != TRANSPARENT_ENCODING) && alive) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule
