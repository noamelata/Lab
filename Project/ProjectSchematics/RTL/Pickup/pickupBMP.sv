
module	pickupBMP (		 
	output	logic	[0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [8-1:0] object_colors  //rgb value from the bitmap 
 ) ;
 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 4;  
localparam  int OBJECT_NUMBER_OF_X_BITS = 4; 
localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;

assign object_colors = {
{8'hFF, 8'hFF, 8'hFF, 8'hE9, 8'hE9, 8'hE9, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hE9, 8'hE9, 8'hE9, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hE9, 8'hFF, 8'hE9, 8'hE9, 8'hFF, 8'hFF, 8'hE9, 8'hE9, 8'hFF, 8'hE9, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hE9, 8'hFF, 8'hFF, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hFF, 8'hFF, 8'hE9, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hFF, 8'hFF, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hFF, 8'hFF, 8'hFF },
{8'hFF, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hE9, 8'hE9, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hFF },
{8'hFF, 8'hF4, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF4, 8'hE9, 8'hE9, 8'hF4, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF4, 8'hFF },
{8'hFF, 8'hF4, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF4, 8'hE9, 8'hE9, 8'hF4, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF4, 8'hFF },
{8'hFF, 8'hF4, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF4, 8'hE9, 8'hE9, 8'hF4, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF4, 8'hFF },
{8'hFF, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hE9, 8'hE9, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hFF },
{8'hFF, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hFF },
{8'hFF, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hE9, 8'hFF },
{8'hFF, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hE9, 8'hE9, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hFF },
{8'hFF, 8'hF4, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF4, 8'hE9, 8'hE9, 8'hF4, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF4, 8'hFF },
{8'hFF, 8'hF4, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF4, 8'hE9, 8'hE9, 8'hF4, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF4, 8'hFF },
{8'hFF, 8'hF4, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF4, 8'hE9, 8'hE9, 8'hF4, 8'hF9, 8'hF9, 8'hF9, 8'hF9, 8'hF4, 8'hFF },
{8'hFF, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hE9, 8'hE9, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hF4, 8'hFF }
};

endmodule