
module GROUND_TOP	(	
					input logic	clk,
					input logic	resetN,
					input logic startOfFrame,
					input logic [2:0] tree_speed,
					input logic [1:0] [10:0] drawCoordinates,			

					output logic [1:0] [10:0] dynamic_ground_Coordinates,
					output logic dynamic_ground_Request,
					output logic [7:0] dynamic_ground_RGB
				
);
 

logic signed [1:0] [10:0] Coordinates;

assign dynamic_ground_Coordinates = Coordinates;

logic signed [1:0] [10:0] dynamic_ground_Offset;

logic dynamic_ground_InsideSquare;


logic [0:63] [0:31] [7:0] dynamic_ground_bitmap;
dynamic_groundBMP dynamic_groundBMP(.object_colors(dynamic_ground_bitmap));

dynamic_groundLogic dynamic_groundlogic(	
			.clk(clk),
			.resetN(resetN),
			.startOfFrame(startOfFrame),
			.speed(tree_speed),
			.coordinate(Coordinates)		
		);
		
		
		square_object #(.OBJECT_WIDTH_X(640), .OBJECT_HEIGHT_Y(550)) dynamic_ground_square(	
			.clk(clk),
			.resetN(resetN),
			.pixelX(drawCoordinates[0]),
			.pixelY(drawCoordinates[1]),
			.topLeftX(Coordinates[0]), 
			.topLeftY(Coordinates[1]),

			.offsetX(dynamic_ground_Offset[0]), 
			.offsetY(dynamic_ground_Offset[1]),
			.drawingRequest(dynamic_ground_InsideSquare),
			.RGBout() 
		);
	

			
		dynamic_groundDraw dynamic_groundDraw(
			.clk(clk),
			.resetN(resetN),
			.coordinate(dynamic_ground_Offset),
			.object_colors(dynamic_ground_bitmap),
			.InsideRectangle(dynamic_ground_InsideSquare),
			
			.drawingRequest(dynamic_ground_Request), 
			.RGBout(dynamic_ground_RGB)
		) ;

endmodule

