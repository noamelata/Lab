
module GAME_TOP	(	
	input logic	CLOCK_50,
	input logic	resetN,
	input logic [3:0] KEY,
	input logic [9:0] SW,
	input logic AUD_ADCDAT,
	
	output logic [7:0] VGA_R,
	output logic [7:0] VGA_G,
	output logic [7:0] VGA_B,
	output logic VGA_HS,
	output logic VGA_VS,
	output logic VGA_SYNC_N,
	output logic VGA_BLANK_N,
	output logic VGA_CLK,
	
	output logic MICROPHON_LED,
	inout logic AUD_ADCLRCK,
	inout logic AUD_BCLK,
	output logic AUD_DACDAT,
	inout logic AUD_DACLRCK,
	output logic AUD_XCK,
	output logic AUD_I2C_SCLK,
	inout logic AUD_I2C_SDAT
				
);
 
localparam NUM_OF_BIRDS = 4;
localparam NUM_OF_TREES = 16;
localparam NUM_OF_SHOTS = 8;
localparam NUM_OF_POOPS = 8;

//inputs
logic startOfFrame; // 30 hz
logic shoot;
logic left;
logic right;
logic clk;

//coordinates
logic signed [1:0] [10:0] drawCoordinates;
logic signed [1:0] [10:0] playerCoordinates;
logic signed [1:0] [10:0] dynamic_ground_Coordinates; 
logic signed [NUM_OF_BIRDS - 1:0] [1:0] [10:0] birdsCoordinates;
logic signed [NUM_OF_SHOTS - 1:0] [1:0] [10:0] shotsCoordinates;
logic signed [NUM_OF_TREES - 1:0] [1:0] [10:0] treesCoordinates;
logic signed [1:0] [10:0] pickupCoordinates;
logic signed [NUM_OF_POOPS - 1:0] [1:0] [10:0] poopsCoordinates;

//drawing requests
logic playerDrawingRequest;
logic [NUM_OF_BIRDS - 1:0] birdsBusRequest;
logic [NUM_OF_SHOTS - 1:0] shotsBusRequest;
logic [NUM_OF_TREES - 1:0] treesBusRequest;
logic [1:0] timerBusRequest;
logic [NUM_OF_POOPS - 1:0] poopsBusRequest;
logic birdsDrawingRequest;
logic shotsDrawingRequest;
logic treesDrawingRequest;
logic dynamic_ground_Request;
logic pickupDrawingRequest;
logic poopsDrawingRequest;
logic barDrawingRequest;

//objects RGBs
logic [7:0] playerRGB;	
logic [7:0] birdsRGB;
logic [7:0] shotsRGB;
logic [7:0] treesRGB;
logic [7:0] backgroundRGB;
logic [7:0] dynamic_ground_RGB;
logic [7:0] pickupRGB;
logic [7:0] poopsRGB;
logic [7:0] barRGB;

//vga
logic [7:0] redOut;
logic [7:0] greenOut; 
logic [7:0] blueOut;

//flags
logic [NUM_OF_BIRDS - 1:0] SingleHitPulse_birds;
logic [NUM_OF_SHOTS - 1:0] SingleHitPulse_shots;
logic [NUM_OF_BIRDS - 1:0] bird_alive;
logic player_SingleHitPulse;
logic pickup_SingleHitPulse;
logic poop_SingleHitPulse;
logic player_collision;

//deployment of objects
logic [NUM_OF_SHOTS - 1:0] deploy_shot;
logic [NUM_OF_TREES - 1:0] deploy_tree;
logic [NUM_OF_BIRDS - 1:0] deploy_bird;
logic deploy_pickup;
logic [NUM_OF_POOPS - 1:0] deploy_poop;
logic any_shot;
assign any_shot = (deploy_shot[0] || deploy_shot[1]
						|| deploy_shot[2] || deploy_shot[3]
						|| deploy_shot[4] || deploy_shot[5]
						|| deploy_shot[6] || deploy_shot[7]);
logic any_hit_bird;
assign any_hit_bird = (SingleHitPulse_birds[0] || SingleHitPulse_birds[1]
						|| SingleHitPulse_birds[2] || SingleHitPulse_birds[3]);

//active game related				
logic [2:0] tree_speed;
logic [1:0] bird_speed;		
logic [3:0] bird_life;
logic player_active;
logic player_red;
logic [1:0] num_of_hearts;
logic [1:0] [3:0] level_num;
logic level_up;


//timer
logic total_time;
logic [1:0] [3:0] time_to_add;
logic [1:0] [3:0] timer_digits;
logic timer_load;
logic timer_on;
logic out_of_time;

//powerups
logic god_mode;
logic rapid_fire;
logic [1:0] damage;
logic more_damage;
logic shield;

//helpers
logic [7:0] random_number;
logic one_sec;
logic duty50;


//sound				
logic [9:0] freq;
logic sound_en;

localparam logic [1:0] SINGLE_DAMAGE = 2'h1;
localparam logic [1:0] TRIPPLE_DAMAGE = 2'h3;

//inputs and cheats
assign clk = CLOCK_50;
assign right = !KEY[1];
assign shoot = player_active && (!KEY[2] || SW[0]);
assign left = !KEY[3];
assign god_mode = SW[9];
assign rapid_fire = SW[8];
assign damage = (SW[7] || more_damage) ? TRIPPLE_DAMAGE : SINGLE_DAMAGE;

//background solid color
assign backgroundRGB = 8'h5c;

//game controller unit
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
	.level_num(level_num),
	.lvl_up(level_up)
	);

//player unit
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

//enemy unit
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
			
//shot unit
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
	.high_damage((damage == TRIPPLE_DAMAGE) ? 1'b1 : 1'b0),
	
	.shotsBusRequest(shotsBusRequest),
	.shotsCoordinates(shotsCoordinates),
	.shotsDrawingRequest(shotsDrawingRequest),
	.shotsRGB(shotsRGB)
);

//tree unit
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

//dynamic grass unit
GROUND_TOP ground_top(
	.clk(clk),
	.resetN(resetN),
	.startOfFrame(startOfFrame),
	.tree_speed(tree_speed),
	.drawCoordinates(drawCoordinates),
	
	.dynamic_ground_Coordinates(dynamic_ground_Coordinates),
	.dynamic_ground_Request(dynamic_ground_Request),
	.dynamic_ground_RGB(dynamic_ground_RGB)
);

//top bar unit
TOP_BAR_TOP top_bar_top(
	.clk(clk),
	.resetN(resetN),
	.startOfFrame(startOfFrame),
	.timer_load(timer_load),
	.time_to_add(time_to_add),
	.drawCoordinates(drawCoordinates),
	.num_of_hearts(num_of_hearts),
	.level_num(level_num),
	.gameOver(!player_active),
	
	.timer(timer_digits),
	.one_sec_out(one_sec),
	.duty50_out(duty50),
	.out_of_time(out_of_time),
	.barDrawingRequest(barDrawingRequest),
	.barRGB(barRGB)
	);
					
//powerups unit				
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
					
//bomb unit					
POOP_TOP poop_top(
	.clk(clk),
	.resetN(resetN),
	.startOfFrame(startOfFrame),
	.initial_coordinates(birdsCoordinates),
	.poop_speed(tree_speed),
	.deploy_poop(deploy_poop),
	.drawCoordinates(drawCoordinates),
	
	.poopsBusRequest(poopsBusRequest),
	.poopsCoordinates(poopsCoordinates),
	.poopsDrawingRequest(poopsDrawingRequest),
	.poopsRGB(poopsRGB)
);

// decides which pixel is printed
objects_mux_all mux_all(	
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

//collision unit
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

//sound unit					
sound_machine sound_machine(
	.clk(clk),
	.resetN(resetN),
	.startOfFrame(startOfFrame),
	.shot_deploy(any_shot),
	.player_hit(player_SingleHitPulse || poop_SingleHitPulse),
	.bird_hit(any_hit_bird),
	.level_up(level_up),
	.pickup(pickup_SingleHitPulse),
	
	.freq(freq),
	.sound_en(sound_en)
	);
				
TOP_MSS_DEMO top_mss_demo (
	.CLOCK_50(clk),
	.resetN(resetN),
	.EnableSound(sound_en),
	.freq(freq),
	.AUD_ADCDAT(AUD_ADCDAT),

	.MICROPHON_LED(MICROPHON_LED),
	.AUD_ADCLRCK(AUD_ADCLRCK),
	.AUD_BCLK(AUD_BCLK),
	.AUD_DACDAT(AUD_DACDAT),
	.AUD_DACLRCK(AUD_DACLRCK),
	.AUD_XCK(AUD_XCK),
	.AUD_I2C_SCLK(AUD_I2C_SCLK),
	.AUD_I2C_SDAT(AUD_I2C_SDAT)
	);				

random randomizer (
	.clk(clk),
	.resetN(resetN),
	.rise(startOfFrame),
	.dout(random_number)	
	);	

endmodule

