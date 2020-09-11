
module PLAYER_TOP	(	
					input logic	clk,
					input logic	resetN,
					input logic startOfFrame,
					input logic left,
					input logic right,
					input logic player_SingleHitPulse,
					input logic [1:0] [10:0] drawCoordinates,
					input logic player_red,
					input logic player_active,
					input logic invincible,
					
					output logic [1:0] [10:0] playerCoordinates,
					output logic playerDrawingRequest,
					output logic [7:0] playerRGB				
);
 
 
logic signed [1:0] [10:0] Coordinates;
logic signed [1:0] [10:0] playerOffset;


logic playerInsideSquare;



playerLogic playerlogic(.clk(clk), //player movement and life 
	.resetN(resetN),
	.startOfFrame(startOfFrame), 
	.left(left),  
	.right(right),  
	.collision(player_SingleHitPulse),  
	.invincible(),
	.coordinate(Coordinates)
);
					
square_object	playersquare(	//is player within bounds
	.clk(clk),
	.resetN(resetN),
	.pixelX(drawCoordinates[0]),
	.pixelY(drawCoordinates[1]),
	.topLeftX(Coordinates[0]), 
	.topLeftY(Coordinates[1]),
	.offsetX(playerOffset[0]), 
	.offsetY(playerOffset[1]),
	.drawingRequest(playerInsideSquare),
	.RGBout() 
);

					
playerDraw playerdraw	(	//which pixel to send out from bitmap
	.clk(clk),
	.resetN(resetN),
	.offsetCoordinate(playerOffset),
	.InsideRectangle(playerInsideSquare),
	.flash(player_red),
	.left(left),
	.right(right),
	.isActive(player_active),
	.invincible(invincible),

	.drawingRequest(playerDrawingRequest),
	.RGBout(playerRGB)
) ;
 
assign playerCoordinates = Coordinates;
 

endmodule
