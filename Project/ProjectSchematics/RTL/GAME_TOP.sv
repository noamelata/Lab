
module GAME_TOP	(	
					input logic	CLOCK_50,
					input logic	resetN,
					input logic [3:0] KEY,
					input logic [9:0] SW,
					
					output logic [7:0] VGA_R,
					output logic [7:0] VGA_G,
					output logic [7:0] VGA_B,
					output logic VGA_HS,
					output logic VGA_VS,
					output logic VGA_SYNC_N,
					output logic VGA_BLANK_N,
					output logic VGA_CLK
				
);
 
 
logic startOfFrame;
logic signed [1:0] [10:0] drawCoordinates;
logic signed [1:0] [10:0] playerCoordinates;
logic signed [1:0] [10:0] dynamic_ground_Coordinates; 
logic signed [1:0] [1:0] [10:0] birdsCoordinates;
logic signed [7:0] [1:0] [10:0] shotsCoordinates;
logic signed [7:0] [1:0] [10:0] treesCoordinates;

logic signed [1:0] [10:0] playerOffset;
logic signed [1:0] [1:0] [10:0] birdsOffset;
logic signed [7:0] [1:0] [10:0] shotsOffset;
logic signed [7:0] [1:0] [10:0] treesOffset;
logic signed [1:0] [10:0] dynamic_ground_Offset;
logic playerInsideSquare;
logic dynamic_ground_InsideSquare;
logic [1:0] birdsInsideSquare;
logic [7:0] shotsInsideSquare;
logic [7:0] treesInsideSquare;
logic playerDrawingRequest;
logic [1:0] birdsBusRequest;
logic [7:0] shotsBusRequest;
logic [7:0] treesBusRequest;
logic [3:0] timerBusRequest;
logic birdsDrawingRequest;
logic shotsDrawingRequest;
logic treesDrawingRequest;
logic dynamic_ground_Request;
logic [7:0] playerRGB;
logic [1:0] [7:0] birdsBusRGB;
logic [7:0] [7:0] shotsBusRGB;
logic [7:0] [7:0] treesBusRGB;
logic [3:0] [7:0] timerBusRGB;	
logic [7:0] birdsRGB;
logic [7:0] shotsRGB;
logic [7:0] treesRGB;
logic [7:0] backgroundRGB;
logic [7:0] dynamic_ground_RGB;

logic [1:0] SingleHitPulse_birds;
logic [7:0] SingleHitPulse_shots;
logic [1:0] bird_alive;
logic player_SingleHitPulse;
logic player_collision;

logic [1:0] tree_speed;
logic [1:0] bird_speed;
logic [7:0] deploy_shot;
logic [7:0] deploy_tree;
logic [1:0] deploy_bird;
logic [3:0] bird_life;

logic [7:0] shots_active;
logic [7:0] trees_active;
logic player_active;
logic player_red;

logic total_time;
logic [1:0] bird_red;
logic [7:0] redOut;
logic [7:0] greenOut; 
logic [7:0] blueOut;
logic shoot;
logic left;
logic right;
logic clk;

logic [3:0] [3:0] time_to_add;
logic [3:0] [3:0] timer_digit;
logic timer_load;

logic god_mode;
logic rapid_fire;

logic [7:0] random_number;
logic turbo;
logic one_sec;
logic duty50;


assign clk = CLOCK_50;
assign right = !KEY[1];
assign shoot = !KEY[2] || SW[0];
assign left = !KEY[3];
assign god_mode = SW[9];
assign rapid_fire = SW[8];
assign backgroundRGB = 8'h5c;

game_controller gamecontroller (.clk(clk),
			.resetN(resetN),
			.startOfFrame(startOfFrame),   
			.shoot(shoot),
			.god_mode(god_mode),
			.rapid_fire(rapid_fire),
			.playerCoordinates(playerCoordinates),
			.random(random_number),
			.bird_alive(bird_alive),
			.collision(player_collision), 
			.SingleHitPulse(player_SingleHitPulse), 
			
			.tree_speed(tree_speed),
			.bird_speed(bird_speed),
			.deploy_shot(deploy_shot),
			.deploy_tree(deploy_tree),
			.deploy_bird(deploy_bird),
			.bird_life(bird_life),
			.player_red(player_red),
			.player_active(player_active),
			.add_time(timer_load),
			.time_to_add(time_to_add)
			);

playerLogic playerlogic(.clk(clk),
					.resetN(resetN),
					.startOfFrame(startOfFrame), 
					.left(left),  
					.right(right),  
					.collision(player_SingleHitPulse),  
					.invincible(),
					.coordinate(playerCoordinates)
					);
					
square_object	playersquare(	
					.clk(clk),
					.resetN(resetN),
					.pixelX(drawCoordinates[0]),
					.pixelY(drawCoordinates[1]),
					.topLeftX(playerCoordinates[0]), 
					.topLeftY(playerCoordinates[1]),
					.offsetX(playerOffset[0]), 
					.offsetY(playerOffset[1]),
					.drawingRequest(playerInsideSquare),
					.RGBout() 
);

					
playerDraw playerdraw	(	
					.clk(clk),
					.resetN(resetN),
					.offsetCoordinate(playerOffset),
					.InsideRectangle(playerInsideSquare),
					.flash(player_red),
					.left(left),
					.right(right),
					.isActive(player_active),
					.invincible(god_mode),

					.drawingRequest(playerDrawingRequest),
					.RGBout(playerRGB)
 ) ;

logic [0:31] [0:31] [7:0] wings_up_bitmap;
logic [0:31] [0:31] [7:0] wings_down_bitmap;
birdBMP birdBMP(.wings_up_object_colors(wings_up_bitmap), .wings_down_object_colors(wings_down_bitmap));
 
genvar i;
generate
	for (i=0; i < 2; i++) begin : generate_birds_id
		birdLogic #(.RANDOM_OFFSET(i * 128), .INITIAL_Y(128 - (i * 64))) birdlogic (	
							.clk(clk),
							.resetN(resetN),
							.startOfFrame(startOfFrame),
							.collision(SingleHitPulse_birds[i]),
							.random(random_number), 
							.starting_life(bird_life),
							.deploy(deploy_bird[i]),
							.speed(bird_speed),
							.alive(bird_alive[i]),
							.red(bird_red[i]),
							.coordinate(birdsCoordinates[i])					
		);

		square_object	birdssquare(	
			.clk(clk),
			.resetN(resetN),
			.pixelX(drawCoordinates[0]),
			.pixelY(drawCoordinates[1]),
			.topLeftX(birdsCoordinates[i][0]), 
			.topLeftY(birdsCoordinates[i][1]),
			.offsetX(birdsOffset[i][0]), 
			.offsetY(birdsOffset[i][1]),
			.drawingRequest(birdsInsideSquare[i]),
			.RGBout() 
		);

		birdDraw #(.COLOR(i == 0 ? 8'h33 : 8'hE2)) birddraw	(	
			.clk(clk),
			.resetN(resetN),
			.coordinate(birdsOffset[i]),
			.InsideRectangle(birdsInsideSquare[i]), 
			.flash(bird_red[i]),
			.alive(bird_alive[i]),
			.duty50(duty50),
			.wings_up_object_colors(wings_up_bitmap),
			.wings_down_object_colors(wings_down_bitmap),
			.drawingRequest(birdsBusRequest[i]), 
			.RGBout(birdsBusRGB[i])
		) ;


	end
endgenerate
			
				
logic [0:15] [0:15] [7:0] shot_bitmap;
shotBMP shotBMP(.object_colors(shot_bitmap));

generate
	for (i=0; i < 8; i++) begin : generate_shots_id
		shotLogic shotlogic(	

			.clk(clk),
			.resetN(resetN),
			.startOfFrame(startOfFrame),
			.deploy(deploy_shot[i]),
			.collision(SingleHitPulse_shots[i]),
			.direction({left,right}),
			.initial_x(playerCoordinates + 10'h8), //might not work (shot is now 8 bit)
			.isActive(shots_active[i]),
			.coordinate(shotsCoordinates[i])			
		);
		
		square_object #(.OBJECT_WIDTH_X(16), .OBJECT_HEIGHT_Y(16))	shotssquare(	
			.clk(clk),
			.resetN(resetN),
			.pixelX(drawCoordinates[0]),
			.pixelY(drawCoordinates[1]),
			.topLeftX(shotsCoordinates[i][0]), 
			.topLeftY(shotsCoordinates[i][1]),
			
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
			.drawingRequest(shotsBusRequest[i]), 
			.RGBout(shotsBusRGB[i])
		) ;

	end
endgenerate

logic [0:63] [0:31] [7:0] tree_bitmap;
treeBMP treeBMP(.object_colors(tree_bitmap));

generate
	for (i=0; i < 8; i++) begin : generate_trees_id
		treeLogic treelogic(	
			.clk(clk),
			.resetN(resetN),
			.startOfFrame(startOfFrame),
			.deploy(deploy_tree[i]),
			.random(random_number),
			.speed(tree_speed),
			.coordinate(treesCoordinates[i]),		
			.isActive(trees_active[i])
		);

		square_object #(.OBJECT_WIDTH_X(32), .OBJECT_HEIGHT_Y(64)) treessquare(	
			.clk(clk),
			.resetN(resetN),
			.pixelX(drawCoordinates[0]),
			.pixelY(drawCoordinates[1]),
			.topLeftX(treesCoordinates[i][0]), 
			.topLeftY(treesCoordinates[i][1]),

			.offsetX(treesOffset[i][0]), 
			.offsetY(treesOffset[i][1]),
			.drawingRequest(treesInsideSquare[i]),
			.RGBout() 
		);

			
		treeDraw treedraw(
			.clk(clk),
			.resetN(resetN),
			.coordinate(treesOffset[i]),
			.InsideRectangle(treesInsideSquare[i]),
			.isActive(trees_active[i]), 
			.object_colors(tree_bitmap),

			.drawingRequest(treesBusRequest[i]), 
			.RGBout(treesBusRGB[i])
		) ;

  end
endgenerate

logic [0:31] [0:31] [7:0] dynamic_ground_bitmap;
dynamic_groundBMP dynamic_groundBMP(.object_colors(dynamic_ground_bitmap));

dynamic_groundLogic dynamic_groundlogic(	
			.clk(clk),
			.resetN(resetN),
			.startOfFrame(startOfFrame),
			.speed(tree_speed),
			.coordinate(dynamic_ground_Coordinates)		
		);
		
		
		square_object #(.OBJECT_WIDTH_X(640), .OBJECT_HEIGHT_Y(1000)) dynamic_ground_square(	
			.clk(clk),
			.resetN(resetN),
			.pixelX(drawCoordinates[0]),
			.pixelY(drawCoordinates[1]),
			.topLeftX(dynamic_ground_Coordinates[0]), 
			.topLeftY(dynamic_ground_Coordinates[1]),

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

timer_4_digits_counter timer (
			.clk(clk),
			.resetN(resetN),
			.ena(1'b1), 
			.ena_cnt(one_sec), 
			.loadN(!timer_load), 
			.add_time(time_to_add),
			.Count_out(timer_digit),
			.tc()
			);

generate
	for (i=0; i < 4; i++) begin : generate_timers_id
		logic InsideSquare;
		logic [1:0] [10:0] number_offset;
		square_object #(.OBJECT_WIDTH_X(16)) digitssquare(	
			.clk(clk),
			.resetN(resetN),
			.pixelX(drawCoordinates[0]),
			.pixelY(drawCoordinates[1]),
			.topLeftX(i*16), 
			.topLeftY(10'h000),

			.offsetX(number_offset[0]), 
			.offsetY(number_offset[1]),
			.drawingRequest(InsideSquare),
			.RGBout(timerBusRGB[i]) 
		);

			
		NumbersBitMap	(	
					.clk(clk),
					.resetN(resetN),
					.offsetX(number_offset[0]), 
					.offsetY(number_offset[1]),
					.InsideRectangle(InsideSquare), //input that the pixel is within a bracket 
					.digit(timer_digit[i]), // digit to display
					
					.drawingRequest(timerBusRequest[i]), //output that the pixel should be dispalyed 
					.RGBout()
		);

  end
endgenerate



 
objects_mux_all	mux_all(	
					.clk(clk),
					.resetN(resetN),
					.digitsDrawingRequest(digitsDrawingRequest),
					.digitsRGB(digitsRGB), 
					.playerDrawingRequest(playerDrawingRequest),
					.playerRGB(playerRGB), 
					.birdsDrawingRequest(birdsDrawingRequest),
					.birdsRGB(birdsRGB), 
					.shotsDrawingRequest(shotsDrawingRequest),
					.shotsRGB(shotsRGB), 
					.treesDrawingRequest(treesDrawingRequest),
					.treesRGB(treesRGB), 
					.dynamic_ground_Request(dynamic_ground_Request),
					.dynamic_ground_RGB(dynamic_ground_RGB), 
					.backGroundRGB(backgroundRGB), 
					.redOut(redOut),
					.greenOut(greenOut), 
					.blueOut(blueOut) 
					
);

logic timerDrawingRequest;
logic timerRGB;

digits_mux digits_mux(
					.clk(clk),
					.resetN(resetN),
					.digitsBusRequest(timerBusRequest),
					.digitsBusRGB(timerBusRGB), 
					.digitsDrawingRequest(timerDrawingRequest),
					.digitsRGB(timerRGB)
					
);


birds_mux	birds_mux(	
					.clk(clk),
					.resetN(resetN),
					.bird1DrawingRequest(birdsBusRequest[0]),
					.bird1RGB(birdsBusRGB[0]), 
					.bird2DrawingRequest(birdsBusRequest[1]),
					.bird2RGB(birdsBusRGB[1]), 
					.birdsDrawingRequest(birdsDrawingRequest),
					.birdsRGB(birdsRGB)
					
);


shots_mux shots_mux(	
					.clk(clk),
					.resetN(resetN),
					.shotsBusRequest(shotsBusRequest),
					.shotsBusRGB(shotsBusRGB), 
					.shotsDrawingRequest(shotsDrawingRequest),
					.shotsRGB(shotsRGB)
					
);

trees_mux trees_mux(	
					.clk(clk),
					.resetN(resetN),
					.treesBusRequest(treesBusRequest),
					.treesBusRGB(treesBusRGB), 
					.treesDrawingRequest(treesDrawingRequest),
					.treesRGB(treesRGB)
					
);


collision_player_tree	collision_player_tree(	
					.clk(clk),
					.resetN(resetN),
					.startOfFrame(startOfFrame),
					.playerDrawingRequest(playerDrawingRequest),	
					.treesDrawingRequest(treesBusRequest),			
					.SingleHitPulse(player_SingleHitPulse)			
);


collision_bird_shot collision_bird_shot(	
					.clk(clk),
					.resetN(resetN),
					.startOfFrame(startOfFrame),
					.birdsDrawingRequest(birdsBusRequest),
					.shotsDrawingRequest(shotsBusRequest),									
					.SingleHitPulse_birds(SingleHitPulse_birds),
					.SingleHitPulse_shots(SingleHitPulse_shots)				
					);

					
VGA_Controller	vga (	
					.Red(redOut),
					.Green(greenOut),
					.Blue(blueOut),
					.PixelX(drawCoordinates[0]),
					.PixelY(drawCoordinates[1]),
					.StartOfFrame(startOfFrame),
					.oVGA_R(VGA_R),
					.oVGA_G(VGA_G),
					.oVGA_B(VGA_B),
					.oVGA_HS(VGA_HS),
					.oVGA_VS(VGA_VS),
					.oVGA_SYNC(VGA_SYNC_N),
					.oVGA_BLANK(VGA_BLANK_N),
					.oVGA_CLOCK(VGA_CLK),
					.clk(clk),
					.resetN(resetN)
					);
					
random randomizer (
						.clk(clk),
						.resetN(resetN),
						.rise(startOfFrame),
						.dout(random_number)	
						);

						
one_sec_counter one_sec_counter  (

						.clk(clk), 
						.resetN(resetN), 
						.turbo(turbo),
						.one_sec(one_sec), 
						.duty50(duty50)
						);
	
						

endmodule

