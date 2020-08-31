
module SHOT_TOP	(	
					input logic	clk,
					input logic	resetN,
					input logic startOfFrame,
					input logic left,
					input logic right,
					input logic [1:0] [10:0] playerCoordinates,
					input logic [NUM_OF_SHOTS - 1:0] SingleHitPulse_shots,
					input logic [NUM_OF_SHOTS - 1:0] deploy_shot,
					input logic [1:0] [10:0] drawCoordinates,
					
					output logic [NUM_OF_SHOTS - 1:0] shotsBusRequest,
					output logic [NUM_OF_SHOTS - 1:0] [1:0] [10:0] shotsCoordinates,
					output logic shotsDrawingRequest,
					output logic [7:0] shotsRGB
				
);
 
parameter NUM_OF_SHOTS = 8;
localparam int bit_16 = 16;

logic signed [NUM_OF_SHOTS - 1:0] [1:0] [10:0] Coordinates;
logic [NUM_OF_SHOTS - 1:0] BusRequest;

assign shotsCoordinates = Coordinates;
assign shotsBusRequest = BusRequest;


logic signed [NUM_OF_SHOTS - 1:0] [1:0] [10:0] shotsOffset;

logic [NUM_OF_SHOTS - 1:0] shotsInsideSquare;

logic [NUM_OF_SHOTS - 1:0] [7:0] shotsBusRGB;

logic [NUM_OF_SHOTS - 1:0] shots_active;
			
				
logic [0:bit_16 - 1] [0:bit_16 - 1] [7:0] shot_bitmap;
shotBMP shotBMP(.object_colors(shot_bitmap));

genvar i;
generate
	for (i=0; i < NUM_OF_SHOTS; i++) begin : generate_shots_id
		shotLogic shotlogic(	

			.clk(clk),
			.resetN(resetN),
			.startOfFrame(startOfFrame),
			.deploy(deploy_shot[i]),
			.collision(SingleHitPulse_shots[i]),
			.direction({left,right}),
			.initial_x(playerCoordinates + 10'h8),
			.isActive(shots_active[i]),
			.coordinate(Coordinates[i])			
		);
		
		square_object #(.OBJECT_WIDTH_X(bit_16), .OBJECT_HEIGHT_Y(bit_16))	shotssquare(	
			.clk(clk),
			.resetN(resetN),
			.pixelX(drawCoordinates[0]),
			.pixelY(drawCoordinates[1]),
			.topLeftX(Coordinates[i][0]), 
			.topLeftY(Coordinates[i][1]),
			
			.offsetX(shotsOffset[i][0]), 
			.offsetY(shotsOffset[i][1]),
			.drawingRequest(shotsInsideSquare[i]),
			.RGBout() 
		);
		
		shotDraw	shotdraw(	
			.clk(clk),
			.resetN(resetN),
			.coordinate(shotsOffset[i]),
			.InsideRectangle(shotsInsideSquare[i] && shots_active[i]),
			.object_colors(shot_bitmap),
			.drawingRequest(BusRequest[i]), 
			.RGBout(shotsBusRGB[i])
		) ;

	end
endgenerate



shots_mux shots_mux(	
					.clk(clk),
					.resetN(resetN),
					.shotsBusRequest(BusRequest),
					.shotsBusRGB(shotsBusRGB), 
					.shotsDrawingRequest(shotsDrawingRequest),
					.shotsRGB(shotsRGB)
					
);




endmodule

