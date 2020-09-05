
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
logic signed [3:0] [1:0] [10:0] birdsCoordinates;
logic signed [7:0] [1:0] [10:0] shotsCoordinates;
logic signed [15:0] [1:0] [10:0] treesCoordinates;
logic signed [1:0] [10:0] pickupCoordinates;
logic signed [7:0] [1:0] [10:0] poopsCoordinates;


logic playerDrawingRequest;
logic [3:0] birdsBusRequest;
logic [7:0] shotsBusRequest;
logic [15:0] treesBusRequest;
logic [1:0] timerBusRequest;
logic [7:0] poopsBusRequest;
logic birdsDrawingRequest;
logic shotsDrawingRequest;
logic treesDrawingRequest;
logic dynamic_ground_Request;
logic pickupDrawingRequest;
logic poopsDrawingRequest;


logic [7:0] playerRGB;	
logic [7:0] birdsRGB;
logic [7:0] shotsRGB;
logic [7:0] treesRGB;
logic [7:0] backgroundRGB;
logic [7:0] dynamic_ground_RGB;
logic [7:0] pickupRGB;
logic [7:0] poopsRGB;

logic barDrawingRequest;
logic [7:0] barRGB;

logic [3:0] SingleHitPulse_birds;
logic [7:0] SingleHitPulse_shots;
logic [3:0] bird_alive;
logic player_SingleHitPulse;
logic pickup_SingleHitPulse;
logic poop_SingleHitPulse;
logic player_collision;

logic [2:0] tree_speed;
logic [1:0] bird_speed;
logic [7:0] deploy_shot;
logic [15:0] deploy_tree;
logic [3:0] deploy_bird;
logic deploy_pickup;
logic [7:0] deploy_poop;
logic [3:0] bird_life;

logic player_active;
logic player_red;

logic total_time;
logic [7:0] redOut;
logic [7:0] greenOut; 
logic [7:0] blueOut;
logic shoot;
logic left;
logic right;
logic clk;

logic [1:0] [3:0] time_to_add;
logic [1:0] [3:0] timer_digits;
logic timer_load;
logic timer_on;

logic god_mode;
logic rapid_fire;
logic [1:0] damage;
logic more_damage;
logic shield;

logic [7:0] random_number;
logic turbo;
logic one_sec;
logic duty50;
logic out_of_time;

logic [1:0] num_of_hearts;
logic [1:0] [3:0] level_num;


assign clk = CLOCK_50;
assign right = !KEY[1];
assign shoot = player_active && (!KEY[2] || SW[0]);
assign left = !KEY[3];
assign god_mode = SW[9];
assign rapid_fire = SW[8];
assign damage = (SW[7] || more_damage) ? 2'b11 : 2'b01;
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
			.SingleHitPulse(player_SingleHitPulse || poop_SingleHitPulse), 
			.pickup_hit(pickup_SingleHitPulse),
			.out_of_time(out_of_time),
			
			.tree_speed(tree_speed),
			.bird_speed(bird_speed),
			.deploy_shot(deploy_shot),
			.deploy_tree(deploy_tree),
			.deploy_bird(deploy_bird),
			.deploy_pickup(deploy_pickup),
			.bird_life(bird_life),
			.player_red(player_red),
			.player_active(player_active),
			.add_time(timer_load),
			.time_to_add(time_to_add),
			.more_damage(more_damage),
			.shield(shield),
			.num_of_hearts(num_of_hearts),
			.level_num(level_num)
			);

PLAYER_TOP player_top (
					.clk(clk),
					.resetN(resetN),
					.startOfFrame(startOfFrame),
					.left(left),
					.right(right),
					.player_SingleHitPulse(player_SingleHitPulse),
					.drawCoordinates(drawCoordinates),
					.player_red(player_red),
					.player_active(player_active),
					.invincible(shield),
					
					.playerCoordinates(playerCoordinates),
					.playerDrawingRequest(playerDrawingRequest),
					.playerRGB(playerRGB)
);

BIRD_TOP bird_top(
					.clk(clk),
					.resetN(resetN),
					.startOfFrame(startOfFrame),
					.random_number(random_number),
					.duty50(duty50),
					.SingleHitPulse_birds(SingleHitPulse_birds),
					.deploy_bird(deploy_bird),
					.bird_speed(bird_speed),
					.bird_life(bird_life),
					.drawCoordinates(drawCoordinates),
					.damage(damage),
					
					.deploy_poop(deploy_poop),
					.birdsBusRequest(birdsBusRequest),
					.birdsCoordinates(birdsCoordinates),
					.birdsDrawingRequest(birdsDrawingRequest),
					.birdsRGB(birdsRGB),
					.bird_alive(bird_alive)
);
			
				
SHOT_TOP shot_top(
					.clk(clk),
					.resetN(resetN),
					.startOfFrame(startOfFrame),
					.left(left),
					.right(right),
					.playerCoordinates(playerCoordinates),
					.SingleHitPulse_shots(SingleHitPulse_shots),
					.deploy_shot(deploy_shot),
					.drawCoordinates(drawCoordinates),
					.high_damage((damage == 2'b11) ? 1'b1 : 1'b0),
					
					.shotsBusRequest(shotsBusRequest),
					.shotsCoordinates(shotsCoordinates),
					.shotsDrawingRequest(shotsDrawingRequest),
					.shotsRGB(shotsRGB)
);

TREE_TOP tree_top(
					.clk(clk),
					.resetN(resetN),
					.startOfFrame(startOfFrame),
					.random_number(random_number),
					.tree_speed(tree_speed),
					.deploy_tree(deploy_tree),
					.drawCoordinates(drawCoordinates),
					
					.treesBusRequest(treesBusRequest),
					.treesCoordinates(treesCoordinates),
					.treesDrawingRequest(treesDrawingRequest),
					.treesRGB(treesRGB)
);

GROUND_TOP ground_top(.clk(clk),
					.resetN(resetN),
					.startOfFrame(startOfFrame),
					.tree_speed(tree_speed),
					.drawCoordinates(drawCoordinates),
					
					.dynamic_ground_Coordinates(dynamic_ground_Coordinates),
					.dynamic_ground_Request(dynamic_ground_Request),
					.dynamic_ground_RGB(dynamic_ground_RGB)
);


TOP_BAR_TOP top_bar_top(
					.clk(clk),
					.resetN(resetN),
					.startOfFrame(startOfFrame),
					.timer_load(timer_load),
					.time_to_add(time_to_add),
					.drawCoordinates(drawCoordinates),
					.num_of_hearts(num_of_hearts),
					.level_num(level_num),
					
					.timer(timer_digits),
					.one_sec_out(one_sec),
					.duty50_out(duty50),
					.out_of_time(out_of_time),
					.barDrawingRequest(barDrawingRequest),
					.barRGB(barRGB)
					);
					
PICKUP_TOP pickup_top (
					.clk(clk),
					.resetN(resetN),
					.startOfFrame(startOfFrame),
					.random_number(random_number),
					.pickup_speed(tree_speed),
					.deploy_pickup(deploy_pickup),
					.drawCoordinates(drawCoordinates),
					.pickup_hit(pickup_SingleHitPulse),
					
					.pickupCoordinates(pickupCoordinates),
					.pickupDrawingRequest(pickupDrawingRequest),
					.pickupRGB(pickupRGB)
					);
					
POOP_TOP poop_top(
					.clk(clk),
					.resetN(resetN),
					.startOfFrame(startOfFrame),
					.initial_Coordinates(birdsCoordinates),
					.poop_speed(tree_speed),
					.deploy_poop(deploy_poop),
					.drawCoordinates(drawCoordinates),
					
					.poopsBusRequest(poopsBusRequest),
					.poopsCoordinates(poopsCoordinates),
					.poopsDrawingRequest(poopsDrawingRequest),
					.poopsRGB(poopsRGB)
);


 
objects_mux_all	mux_all(	
					.clk(clk),
					.resetN(resetN),
					.digitsDrawingRequest(barDrawingRequest),
					.digitsRGB(barRGB), 
					.playerDrawingRequest(playerDrawingRequest),
					.playerRGB(playerRGB), 
					.birdsDrawingRequest(birdsDrawingRequest),
					.birdsRGB(birdsRGB), 
					.shotsDrawingRequest(shotsDrawingRequest),
					.shotsRGB(shotsRGB), 
					.pickupDrawingRequest(pickupDrawingRequest),
					.pickupRGB(pickupRGB),
					.poopsDrawingRequest(poopsDrawingRequest),
					.poopsRGB(poopsRGB), 
					.treesDrawingRequest(treesDrawingRequest),
					.treesRGB(treesRGB), 
					.dynamic_ground_Request(dynamic_ground_Request),
					.dynamic_ground_RGB(dynamic_ground_RGB), 
					.backGroundRGB(backgroundRGB), 
					.redOut(redOut),
					.greenOut(greenOut), 
					.blueOut(blueOut) 
					
);




collision_player_tree	collision_player_tree(	
					.clk(clk),
					.resetN(resetN),
					.startOfFrame(startOfFrame),
					.playerDrawingRequest(playerDrawingRequest),	
					.treesDrawingRequest(treesBusRequest),			
					.SingleHitPulse(player_SingleHitPulse)			
);

collision_player_pickup	collision_player_pickup(	
					.clk(clk),
					.resetN(resetN),
					.startOfFrame(startOfFrame),
					.playerDrawingRequest(playerDrawingRequest),	
					.pickupDrawingRequest(pickupDrawingRequest),			
					.SingleHitPulse(pickup_SingleHitPulse)			
);

collision_player_poop	collision_player_poop(	
					.clk(clk),
					.resetN(resetN),
					.startOfFrame(startOfFrame),
					.playerDrawingRequest(playerDrawingRequest),	
					.poopsDrawingRequest(poopsBusRequest),			
					.SingleHitPulse(poop_SingleHitPulse)			
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
		

endmodule

