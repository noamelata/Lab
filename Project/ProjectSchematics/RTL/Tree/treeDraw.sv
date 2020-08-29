
module	treeDraw (
					input	logic	clk,
					input	logic	resetN,
					input logic signed  [1:0] [10:0] coordinate,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					input logic isActive, //input that tree should be desplayed 

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout  //rgb value from the bitmap 
 ) ;

 
// this is the devider used to acess the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 6;  // 2^6 = 64 
localparam  int OBJECT_NUMBER_OF_X_BITS = 5;  // 2^5 = 32 


localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_HEIGHT_Y_DIVIDER = OBJECT_NUMBER_OF_Y_BITS - 2; //how many pixel bits are in every collision pixel
localparam  int OBJECT_WIDTH_X_DIVIDER =  OBJECT_NUMBER_OF_X_BITS - 2;

parameter COLOR = 8'hFF;//PLACEHOLDER PLEASE CHANGE
//localparam int speedY;
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// RGB value in the bitmap representing a transparent pixel 

/*
logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h16, 8'h16, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h79, 8'h16, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'h16, 8'h79, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h79, 8'h79, 8'h79, 8'h16, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'h16, 8'h79, 8'h79, 8'h79, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'h16, 8'h16, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBD, 8'h16, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'h16, 8'hBD, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'h16, 8'h16, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h79, 8'h16, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'h16, 8'h79, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h79, 8'h79, 8'h79, 8'h16, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'h16, 8'h79, 8'h79, 8'h79, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'h16, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'h16, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'h16, 8'h16, 8'h16, 8'h16, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h16, 8'hBD, 8'h16, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'h16, 8'hBD, 8'h16, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'h16, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'h16, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'h16, 8'h16, 8'h16, 8'h16, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'hFF, 8'hFF },
{8'hFF, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'hFF },
{8'h16, 8'h79, 8'h16, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'h16, 8'h79, 8'h16 },
{8'h16, 8'h79, 8'h79, 8'h79, 8'h16, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'h16, 8'h79, 8'h79, 8'h79, 8'h16 },
{8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'h16, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'h16, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16 },
{8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'h16, 8'h16, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'hBD, 8'h16, 8'h16, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16 },
{8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'h16, 8'h16, 8'h16, 8'h16, 8'h16, 8'h16, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16 },
{8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16 },
{8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16 },
{8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16 },
{8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16 },
{8'hFF, 8'h16, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'h16, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'h16, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h16, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'h16, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h16, 8'h16, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h79, 8'h16, 8'h16, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h16, 8'h16, 8'h16, 8'h16, 8'h16, 8'h16, 8'h16, 8'h16, 8'h16, 8'h16, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h8D, 8'h69, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h69, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h8D, 8'h69, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h69, 8'h69, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h69, 8'h69, 8'h69, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h69, 8'h8D, 8'h69, 8'h69, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h69, 8'h8D, 8'h8D, 8'h69, 8'h69, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h69, 8'h8D, 8'h69, 8'h69, 8'h8D, 8'h8D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h69, 8'h8D, 8'h8D, 8'h8D, 8'h69, 8'h69, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h69, 8'h69, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h69, 8'h69, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h69, 8'h69, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h69, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h8D, 8'h8D, 8'h8D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h8D, 8'h8D, 8'h8D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h69, 8'h8D, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF }
};

*/

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors = {
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D },
{8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D, 8'h8D }
};



// pipeline (ff) to get the pixel color from the array 	 

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00;
	end
	else begin
		//HitEdgeCode <= hit_colors[offsetY >> OBJECT_HEIGHT_Y_DIVIDER][offsetX >> OBJECT_WIDTH_X_DIVIDER];	//get hitting edge from the colors table  

	
		if ((InsideRectangle == 1'b1))  // inside an external bracket 
			RGBout <= object_colors[coordinate[1]][coordinate[0]];
//			RGBout <=  {HitEdgeCode, 4'b0000 } ;  //get RGB from the colors table, option  for debug 
		else 
			RGBout <= TRANSPARENT_ENCODING ; // force color to transparent so it will not be displayed 
	end 
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING && isActive) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule