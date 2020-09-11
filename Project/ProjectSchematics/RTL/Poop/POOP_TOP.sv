
module POOP_TOP	(	
	input logic	clk,
	input logic	resetN,
	input logic startOfFrame,
	input logic signed [NUM_OF_POOPS - 1:0] [1:0] [10:0] initial_coordinates,
	input logic [2:0] poop_speed, //same as tree and ground speed
	input logic [NUM_OF_POOPS - 1:0] deploy_poop, //which bomb to deploy
	input logic [1:0] [10:0] drawCoordinates,
	
	output logic [NUM_OF_POOPS - 1:0] poopsBusRequest, //which bomb to display
	output logic [NUM_OF_POOPS - 1:0] [1:0] [10:0] poopsCoordinates,
	output logic poopsDrawingRequest,
	output logic [7:0] poopsRGB
				
);
 
 //paramaters
parameter NUM_OF_POOPS = 8;

localparam int bit_8 = 8;
localparam int bit_16 = 16;

logic signed [NUM_OF_POOPS - 1:0] [1:0] [10:0] Coordinates;
logic signed [NUM_OF_POOPS - 1:0] [1:0] [10:0] poopsOffset;
logic [NUM_OF_POOPS - 1:0] BusRequest;
logic [NUM_OF_POOPS - 1:0] poopsInsideSquare;
logic [NUM_OF_POOPS - 1:0] [7:0] poopsBusRGB;
logic [NUM_OF_POOPS - 1:0] poops_active; //is bomb active
logic [7:0] splash; //is bomb fallen
logic [0:bit_16 - 1] [0:bit_16 - 1] [7:0] poop_fall_object_colors; //bitmap for falling bomb	
logic [0:bit_16 - 1] [0:bit_16 - 1] [7:0] poop_splash_object_colors; //bitmap for fallen bomb

poopBMP poopBMP(.poop_fall_object_colors(poop_fall_object_colors),
						.poop_splash_object_colors(poop_splash_object_colors));

genvar i;
generate
	for (i=0; i < NUM_OF_POOPS; i++) begin : generate_poops_id
		poopLogic pooplogic(	
			.clk(clk),
			.resetN(resetN),
			.startOfFrame(startOfFrame),
			.deploy(deploy_poop[i]),
			.initial_x(initial_coordinates[i][0] + bit_8),
			.initial_y(initial_coordinates[i][1] + bit_16),
			.speed(poop_speed),
			.coordinate(Coordinates[i]),		
			.isActive(poops_active[i]),
			.splash(splash[i])
		);

		square_object #(.OBJECT_WIDTH_X(bit_16), .OBJECT_HEIGHT_Y(bit_16)) poopssquare(	
			.clk(clk),
			.resetN(resetN),
			.pixelX(drawCoordinates[0]),
			.pixelY(drawCoordinates[1]),
			.topLeftX(Coordinates[i][0]), 
			.topLeftY(Coordinates[i][1]),

			.offsetX(poopsOffset[i][0]), 
			.offsetY(poopsOffset[i][1]),
			.drawingRequest(poopsInsideSquare[i]),
			.RGBout() 
		);
		
		poopDraw poopdraw(
			.clk(clk),
			.resetN(resetN),
			.coordinate(poopsOffset[i]),
			.InsideRectangle(poopsInsideSquare[i]),
			.isActive(poops_active[i]), 
			.poop_fall_object_colors(poop_fall_object_colors),
			.poop_splash_object_colors(poop_splash_object_colors),
			.splash(splash[i]),

			.drawingRequest(BusRequest[i]), 
			.RGBout(poopsBusRGB[i])
		) ;

  end
endgenerate


poop_mux poop_mux(	
	.clk(clk),
	.resetN(resetN),
	.poopCoordinates(Coordinates),
	.poopsBusRequest(BusRequest),
	.poopsBusRGB(poopsBusRGB), 
	.poopsDrawingRequest(poopsDrawingRequest),
	.poopsRGB(poopsRGB)
);

assign poopsCoordinates = Coordinates;
assign poopsBusRequest = BusRequest;

endmodule

