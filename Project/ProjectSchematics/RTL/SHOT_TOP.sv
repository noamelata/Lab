
module SHOT_TOP	(	
	input logic	clk,
	input logic	resetN,
	input logic startOfFrame,
	input logic left, //left angle for shot
	input logic right, //right angle for shot
	input logic [1:0] [10:0] playerCoordinates,
	input logic [NUM_OF_SHOTS - 1:0] SingleHitPulse_shots, //shots flag
	input logic [NUM_OF_SHOTS - 1:0] deploy_shot, //which shot should be deployed
	input logic [1:0] [10:0] drawCoordinates,
	input logic high_damage, //tripple damage for shot
	
	output logic [NUM_OF_SHOTS - 1:0] shotsBusRequest,
	output logic [NUM_OF_SHOTS - 1:0] [1:0] [10:0] shotsCoordinates,
	output logic shotsDrawingRequest,
	output logic [7:0] shotsRGB
				
);
 
parameter NUM_OF_SHOTS = 8; //max number of shots

localparam int bit_16 = 16;
localparam Y_AXIS_SHOT_GAP = 8;

logic signed [NUM_OF_SHOTS - 1:0] [1:0] [10:0] Coordinates;
logic signed [NUM_OF_SHOTS - 1:0] [1:0] [10:0] shotsOffset;
logic [NUM_OF_SHOTS - 1:0] BusRequest;
logic [NUM_OF_SHOTS - 1:0] shotsInsideSquare;
logic [NUM_OF_SHOTS - 1:0] [7:0] shotsBusRGB;
logic [NUM_OF_SHOTS - 1:0] shots_active;				
logic [0:bit_16 - 1] [0:bit_16 - 1] [7:0] shot_bitmap;

shotBMP shotBMP(.object_colors(shot_bitmap));

genvar i;
generate
	for (i=0; i < NUM_OF_SHOTS; i++) begin : generate_shots_id
		shotLogic shotlogic(	 //shot movement 

			.clk(clk),
			.resetN(resetN),
			.startOfFrame(startOfFrame),
			.deploy(deploy_shot[i]),
			.collision(SingleHitPulse_shots[i]),
			.direction({left,right}),
			.initial_x(playerCoordinates + Y_AXIS_SHOT_GAP),
			.isActive(shots_active[i]),
			.coordinate(Coordinates[i])			
		);
		
		square_object #(.OBJECT_WIDTH_X(bit_16), .OBJECT_HEIGHT_Y(bit_16))	shotssquare(	 //shot within bounds
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
		
		shotDraw	shotdraw( //which pixel from bitmap to send (red and blue)
			.clk(clk),
			.resetN(resetN),
			.coordinate(shotsOffset[i]),
			.InsideRectangle(shotsInsideSquare[i] && shots_active[i]),
			.object_colors(shot_bitmap),
			.high_damage(high_damage),
			.drawingRequest(BusRequest[i]), 
			.RGBout(shotsBusRGB[i])
		) ;

	end
endgenerate

//which shot should be displayed per pixel
shots_mux shots_mux(	
					.clk(clk),
					.resetN(resetN),
					.shotsBusRequest(BusRequest),
					.shotsBusRGB(shotsBusRGB), 
					.shotsDrawingRequest(shotsDrawingRequest),
					.shotsRGB(shotsRGB)
					
);

assign shotsCoordinates = Coordinates;
assign shotsBusRequest = BusRequest;


endmodule

