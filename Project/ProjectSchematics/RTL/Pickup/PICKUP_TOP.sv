
module PICKUP_TOP	(	
	input logic	clk,
	input logic	resetN,
	input logic startOfFrame,
	input logic [7:0] random_number,
	input logic [2:0] pickup_speed, //how fast going sown
	input logic deploy_pickup, //should pickup apear
	input logic [1:0] [10:0] drawCoordinates,
	input logic pickup_hit, //did player take pickup
	
	output logic [1:0] [10:0] pickupCoordinates,
	output logic pickupDrawingRequest,
	output logic [7:0] pickupRGB
				
);
 
localparam int bit_16 = 16;

logic signed [1:0] [10:0] Coordinates;
logic signed [1:0] [10:0] pickupOffset;
logic pickupInsideSquare;
logic pickup_active;			
logic [0:bit_16 - 1] [0:bit_16 - 1] [7:0] pickup_bitmap;

pickupBMP pickupBMP(.object_colors(pickup_bitmap));


pickupLogic pickuplogic(	
	.clk(clk),
	.resetN(resetN),
	.startOfFrame(startOfFrame),
	.deploy(deploy_pickup),
	.remove(pickup_hit),
	.random(random_number),
	.speed(pickup_speed),
	.coordinate(Coordinates),		
	.isActive(pickup_active)
);

square_object #(.OBJECT_WIDTH_X(bit_16), .OBJECT_HEIGHT_Y(bit_16)) pickupssquare(	
	.clk(clk),
	.resetN(resetN),
	.pixelX(drawCoordinates[0]),
	.pixelY(drawCoordinates[1]),
	.topLeftX(Coordinates[0]), 
	.topLeftY(Coordinates[1]),

	.offsetX(pickupOffset[0]), 
	.offsetY(pickupOffset[1]),
	.drawingRequest(pickupInsideSquare),
	.RGBout() 
);

	
pickupDraw pickupdraw(
	.clk(clk),
	.resetN(resetN),
	.coordinate(pickupOffset),
	.InsideRectangle(pickupInsideSquare),
	.isActive(pickup_active), 
	.object_colors(pickup_bitmap),

	.drawingRequest(pickupDrawingRequest), 
	.RGBout(pickupRGB)
) ;

assign pickupCoordinates = Coordinates;

endmodule

