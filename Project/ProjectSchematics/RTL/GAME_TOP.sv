
module GAME_TOP	(	
					input logic	CLOCK_50,
					input logic	resetN,
					input logic [3:0] KEY,
					
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
logic signed [1:0] [1:0] [10:0] birdsCoordinates;
logic signed [7:0] [1:0] [10:0] shotsCoordinates;
logic signed [7:0] [1:0] [10:0] treesCoordinates;
logic signed [1:0] [10:0] playerOffset;
logic signed [1:0] [1:0] [10:0] birdsOffset;
logic signed [7:0] [1:0] [10:0] shotsOffset;
logic signed [7:0] [1:0] [10:0] treesOffset;
logic playerInsideSquare;
logic [1:0] birdsInsideSquare;
logic [7:0] shotsInsideSquare;
logic [7:0] treesInsideSquare;
logic playerDrawingRequest;
logic [1:0] birdsBusRequest;
logic [7:0] shotsBusRequest;
logic [7:0] treesBusRequest;
logic birdsDrawingRequest;
logic shotsDrawingRequest;
logic treesDrawingRequest;
logic [7:0] playerRGB;
logic [1:0] [7:0] birdsBusRGB;
logic [7:0] [7:0] shotsBusRGB;
logic [7:0] [7:0] treesBusRGB;
logic [7:0] birdsRGB;
logic [7:0] shotsRGB;
logic [7:0] treesRGB;
logic [7:0] backgroundRGB;
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

logic [7:0] random_number;


assign clk = CLOCK_50;
assign right = !KEY[1];
assign shoot = !KEY[2];
assign left = !KEY[3];
assign backgroundRGB = 8'h5c;

game_controller gamecontroller (.clk(clk),
			.resetN(resetN),
			.startOfFrame(startOfFrame),   
			.shoot(shoot),
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
			.total_time(total_time));

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

					.drawingRequest(playerDrawingRequest),
					.RGBout(playerRGB)
 ) ;

genvar i;
generate
	for (i=0; i < 2; i++) begin : generate_birds_id
		birdLogic birdlogic (	
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

		birdDraw birddraw	(	
			.clk(clk),
			.resetN(resetN),
			.coordinate(birdsOffset[i]),
			.InsideRectangle(birdsInsideSquare[i]), 
			.flash(bird_red[i]),
			.alive(bird_alive[i]),
			.drawingRequest(birdsBusRequest[i]), 
			.RGBout(birdsBusRGB[i])
		) ;


	end
endgenerate
			
				


generate
	for (i=0; i < 8; i++) begin : generate_shots_id
		shotLogic shotlogic(	

			.clk(clk),
			.resetN(resetN),
			.startOfFrame(startOfFrame),
			.deploy(deploy_shot[i]),
			.collision(SingleHitPulse_shots[i]),
			.direction({left,right}),
			.initial_x(playerCoordinates),
			.isActive(shots_active[i]),
			.coordinate(shotsCoordinates[i])			
		);
		
		square_object	shotssquare(	
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
			.drawingRequest(shotsBusRequest[i]), 
			.RGBout(shotsBusRGB[i])
		) ;

	end
endgenerate


generate
	for (i=0; i < 8; i++) begin : generate_trees_id
		treeLogic treelogic(	
			.clk(clk),
			.resetN(resetN),
			.startOfFrame(startOfFrame),
			//.collision(???),
			.deploy(deploy_tree[i]),
			//.remove(???),
			.random(random_number),
			.speed(tree_speed),
			.coordinate(treesCoordinates[i]),		
			.isActive(trees_active[i])
		);

		square_object	treessquare(	
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

			.drawingRequest(treesBusRequest[i]), 
			.RGBout(treesBusRGB[i])
		) ;

  end
endgenerate


 
objects_mux_all	mux_all(	
					.clk(clk),
					.resetN(resetN),
					.playerDrawingRequest(playerDrawingRequest),
					.playerRGB(playerRGB), 
					.birdsDrawingRequest(birdsDrawingRequest),
					.birdsRGB(birdsRGB), 
					.shotsDrawingRequest(shotsDrawingRequest),
					.shotsRGB(shotsRGB), 
					.treesDrawingRequest(treesDrawingRequest),
					.treesRGB(treesRGB), 
					.backGroundRGB(backgroundRGB), 
					.redOut(redOut),
					.greenOut(greenOut), 
					.blueOut(blueOut) 
					
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
					.resetN(resetN),
					);
					
random randomizer (
						.clk(clk),
						.resetN(resetN),
						.rise(startOfFrame),
						.dout(random_number)	
						);


endmodule

