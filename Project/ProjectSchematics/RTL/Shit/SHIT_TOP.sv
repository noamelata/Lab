
module SHIT_TOP	(	
					input logic	clk,
					input logic	resetN,
					input logic startOfFrame,
					input logic signed [NUM_OF_SHITS - 1:0] [1:0] [10:0] initial_Coordinates,
					input logic [2:0] shit_speed,
					input logic [NUM_OF_SHITS - 1:0] deploy_shit,
					input logic [1:0] [10:0] drawCoordinates,
					
					output logic [NUM_OF_SHITS - 1:0] shitsBusRequest,
					output logic [NUM_OF_SHITS - 1:0] [1:0] [10:0] shitsCoordinates,
					output logic shitsDrawingRequest,
					output logic [7:0] shitsRGB
				
);
 
parameter NUM_OF_SHITS = 8;
localparam int bit_8 = 8;
localparam int bit_16 = 16;
localparam int bit_64 = 64;

logic signed [NUM_OF_SHITS - 1:0] [1:0] [10:0] Coordinates;
logic [NUM_OF_SHITS - 1:0] BusRequest;

assign shitsCoordinates = Coordinates;
assign shitsBusRequest = BusRequest;


logic signed [NUM_OF_SHITS - 1:0] [1:0] [10:0] shitsOffset;

logic [NUM_OF_SHITS - 1:0] shitsInsideSquare;

logic [NUM_OF_SHITS - 1:0] [7:0] shitsBusRGB;

logic [NUM_OF_SHITS - 1:0] shits_active;

logic [7:0] splash;

logic [0:bit_16 - 1] [0:bit_16 - 1] [7:0] shit_fall_object_colors;	
logic [0:bit_16 - 1] [0:bit_16 - 1] [7:0] shit_splash_object_colors;
shitBMP shitBMP(.shit_fall_object_colors(shit_fall_object_colors),
						.shit_splash_object_colors(shit_splash_object_colors));

genvar i;
generate
	for (i=0; i < NUM_OF_SHITS; i++) begin : generate_shits_id
		shitLogic shitlogic(	
			.clk(clk),
			.resetN(resetN),
			.startOfFrame(startOfFrame),
			.deploy(deploy_shit[i]),
			.initial_x(initial_Coordinates[i][0] + bit_8),
			.initial_y(initial_Coordinates[i][1] + bit_16),
			.speed(shit_speed),
			.coordinate(Coordinates[i]),		
			.isActive(shits_active[i]),
			.splash(splash[i])
		);

		square_object #(.OBJECT_WIDTH_X(bit_16), .OBJECT_HEIGHT_Y(bit_16)) shitssquare(	
			.clk(clk),
			.resetN(resetN),
			.pixelX(drawCoordinates[0]),
			.pixelY(drawCoordinates[1]),
			.topLeftX(Coordinates[i][0]), 
			.topLeftY(Coordinates[i][1]),

			.offsetX(shitsOffset[i][0]), 
			.offsetY(shitsOffset[i][1]),
			.drawingRequest(shitsInsideSquare[i]),
			.RGBout() 
		);

			
		shitDraw shitdraw(
			.clk(clk),
			.resetN(resetN),
			.coordinate(shitsOffset[i]),
			.InsideRectangle(shitsInsideSquare[i]),
			.isActive(shits_active[i]), 
			.shit_fall_object_colors(shit_fall_object_colors),
			.shit_splash_object_colors(shit_splash_object_colors),
			.splash(splash[i]),

			.drawingRequest(BusRequest[i]), 
			.RGBout(shitsBusRGB[i])
		) ;

  end
endgenerate




shit_mux shit_mux(	
					.clk(clk),
					.resetN(resetN),
					.shitCoordinates(Coordinates),
					.shitsBusRequest(BusRequest),
					.shitsBusRGB(shitsBusRGB), 
					.shitsDrawingRequest(shitsDrawingRequest),
					.shitsRGB(shitsRGB)
					
);



endmodule

