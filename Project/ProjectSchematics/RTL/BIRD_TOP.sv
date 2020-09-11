
module BIRD_TOP	(	
	input logic	clk,
	input logic	resetN,
	input logic startOfFrame,
	input logic [7:0] random_number,
	input logic duty50,
	input logic [NUM_OF_BIRDS - 1:0] SingleHitPulse_birds, // flag for bird hit
	input logic [NUM_OF_BIRDS - 1:0] deploy_bird, // which birds should be deployed
	input logic [1:0] bird_speed, // left/right movement speed
	input logic [3:0] bird_life, // how many lives per bird
	input logic [1:0] [10:0] drawCoordinates,
	input logic [1:0] damage, // damge bird sustains

	output logic [NUM_OF_BIRDS - 1:0] deploy_poop, // which bomb to deploy
	output logic [NUM_OF_BIRDS - 1:0] birdsBusRequest,
	output logic [NUM_OF_BIRDS - 1:0] [1:0] [10:0] birdsCoordinates,
	output logic birdsDrawingRequest,
	output logic [7:0] birdsRGB,
	output logic [NUM_OF_BIRDS - 1:0] bird_alive	// which bird is alive								
);
 
parameter NUM_OF_BIRDS = 4;

logic signed [NUM_OF_BIRDS - 1:0] [1:0] [10:0] Coordinates;
logic signed [NUM_OF_BIRDS - 1:0] [1:0] [10:0] birdsOffset;
logic [NUM_OF_BIRDS - 1:0] BusRequest;
logic [NUM_OF_BIRDS - 1:0] birdsInsideSquare;
logic [NUM_OF_BIRDS - 1:0] [7:0] birdsBusRGB;
logic [NUM_OF_BIRDS - 1:0] bird_red; // cosmetic red color for when bird is hit
logic [0:31] [0:31] [7:0] wings_up_bitmap;
logic [0:31] [0:31] [7:0] wings_down_bitmap;

localparam int BIT_32 = 32;
localparam int BIT_64 = 64;
localparam int BIT_128 = 128;
localparam int bird_color[0:NUM_OF_BIRDS - 1] = '{8'h33, 8'hE2, 8'hFC, 8'h1F}; //different colors for birds

birdBMP birdBMP(.wings_up_object_colors(wings_up_bitmap), .wings_down_object_colors(wings_down_bitmap));
 
genvar i;
generate
	for (i=0; i < NUM_OF_BIRDS; i++) begin : generate_birds_id // instantiations of enemy birds
		birdLogic #(.RANDOM_OFFSET(i * BIT_64), .INITIAL_Y(BIT_128 - ((i - 1) * BIT_32))) birdlogic (	
			.clk(clk),
			.resetN(resetN),
			.startOfFrame(startOfFrame),
			.collision(SingleHitPulse_birds[i]),
			.random(random_number), 
			.starting_life(bird_life),
			.deploy(deploy_bird[i]),
			.speed(bird_speed),
			.damage(damage),
			.deploy_poop(deploy_poop[i]),
			.alive(bird_alive[i]),
			.red(bird_red[i]),
			.coordinate(Coordinates[i])					
		);

		square_object	birdssquare( //bird within limits	
			.clk(clk),
			.resetN(resetN),
			.pixelX(drawCoordinates[0]),
			.pixelY(drawCoordinates[1]),
			.topLeftX(Coordinates[i][0]), 
			.topLeftY(Coordinates[i][1]),
			.offsetX(birdsOffset[i][0]), 
			.offsetY(birdsOffset[i][1]),
			.drawingRequest(birdsInsideSquare[i]),
			.RGBout() 
		);

		birdDraw #(.COLOR(bird_color[i])) birddraw	(	//which pixel of bird
			.clk(clk),
			.resetN(resetN),
			.coordinate(birdsOffset[i]),
			.InsideRectangle(birdsInsideSquare[i]), 
			.flash(bird_red[i]),
			.alive(bird_alive[i]),
			.duty50(duty50),
			.wings_up_object_colors(wings_up_bitmap),
			.wings_down_object_colors(wings_down_bitmap),
			.drawingRequest(BusRequest[i]), 
			.RGBout(birdsBusRGB[i])
		) ;


	end
endgenerate
			


birds_mux	birds_mux(	// incase birds overlap (should not happen currently)
	.clk(clk),
	.resetN(resetN),
	.birdsBusRequest(BusRequest),
	.birdsBusRGB(birdsBusRGB), 
	.birdsDrawingRequest(birdsDrawingRequest),
	.birdsRGB(birdsRGB)	
);


assign birdsCoordinates = Coordinates;
assign birdsBusRequest = BusRequest;
						

endmodule

