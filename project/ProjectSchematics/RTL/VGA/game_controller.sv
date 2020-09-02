


module	game_controller	(	
			input	logic	clk,
			input	logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input logic shoot,
			input logic god_mode,
			input logic rapid_fire,
			input logic [10:0] playerCoordinates,
			input logic [7:0] random,
			input logic [3:0] bird_alive,
			input logic collision, // active in case of collision between player and tree
			input logic SingleHitPulse, // critical code, generating A single pulse in a frame 
			input logic pickup_hit,
			input logic out_of_time,		
			
			output logic [2:0] tree_speed,
			output logic [1:0] bird_speed,
			output logic [7:0] deploy_shot,
			output logic [15:0] deploy_tree,
			output logic [3:0] deploy_bird,
			output logic deploy_pickup,
			output logic [3:0] bird_life,
			output logic player_red,
			output logic player_active,
			output logic add_time,
			output logic [1:0] [3:0] time_to_add,
			output logic more_damage,
			output logic shield
);



int number_of_trees = 0;
logic [1:0] num_of_birds;

logic [1:0] trees_to_add;
logic start_level;
logic level_up;

levelFSM level_fsm(
	.clk(clk),
	.resetN(resetN),
	.level_up(level_up),
	.startOfFrame(startOfFrame),
	.bird_life(bird_life),
	.trees_to_add(trees_to_add),
	.tree_speed(tree_speed),
	.bird_speed(bird_speed),
	.number_of_birds(num_of_birds)
                );


int cooldown_time;
int cooldown = 0;
int current_shot = 0;
int current_tree = 0;
int last_birds;
int power_up_time;
int power_up_counter = 0;
logic [3:0] powerups; // invinciblity, rapid fire, damage,life.
logic power_up_collision;

localparam int MAX_SHOTS = 8;
localparam int MAX_TREES = 16;
int tree_wait;
int tree_counter;
int player_life = 3; //player life

logic invincible;
logic bird_hit_flag;
int red_counter;
int level_counter;

assign tree_wait = 400; //should be calculated using tree speed and number of trees
assign cooldown_time = (rapid_fire || powerups[1] ) ? 25 : 100;
assign power_up_time = 1000;
assign more_damage = powerups[2];
assign invincible = (((red_counter > 0) ? 1'b1 : 1'b0) || god_mode || powerups[0]);
assign shield = god_mode || powerups[0];


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		time_to_add <= {4'h9, 4'h9};
		add_time <= 1'b1;
		current_shot <= 0;
		current_tree <= 0;
		cooldown <= 0;
		tree_counter <= 300;
		start_level <= 1'b1;
		level_up <= 1'b0;
		deploy_shot <= 8'h00;
		deploy_bird <= 4'h0;
		deploy_tree <= 16'h0000;
		deploy_pickup <= 1'b0;
		player_active <= 1'b1;
		player_life <= 3;
		red_counter <= 0;
		level_counter <= 0;
		bird_hit_flag <= 1'b0;
		last_birds <= 0;
		power_up_counter <= 0;
		powerups <= 4'b0;
		
	end 
	else begin 
		player_active <= player_active;
		time_to_add <= {4'h0, 4'h0, 4'h0, 4'h0};
		add_time <= 1'b0;
		level_up <= 1'b0;
		bird_hit_flag <= bird_hit_flag;
		if (startOfFrame) begin
			red_counter <= (red_counter > 0) ? red_counter - 1 : 0;
			level_counter <= (level_counter > 0) ? level_counter - 1 : 0;
			deploy_shot <= 8'h00;
			cooldown <= (cooldown == 0) ? 0 : cooldown - 1;
			current_shot <= current_shot;
			start_level <= 1'b0;
			current_tree <= current_tree;
			tree_counter <= (tree_counter == tree_wait) ? 0 : tree_counter + 1;
			deploy_bird <= 4'h0;
			deploy_tree <= 16'h0000;
			deploy_pickup <= 1'b0;
			last_birds <= bird_alive;
			power_up_counter <= (power_up_counter > 0) ? power_up_counter - 1 : 0;
			
			if (shoot && (cooldown == 0)) begin // trying to shoot
				deploy_shot[current_shot] <= 1'b1;
				current_shot <= (current_shot == MAX_SHOTS - 1) ? 0 : current_shot + 1;
				cooldown <= cooldown_time;
			end
			
			if ((number_of_trees > 0) && (tree_counter == (tree_wait - 1))) begin // when to deploy tree
				deploy_tree[current_tree] <= 1'b1;
				current_tree <= current_tree == MAX_TREES - 1 ? 0 : current_tree + 1;
				number_of_trees <= number_of_trees - 1;
			end
			
			if (start_level == 1'b1) begin // at beginning of level
				for (int i = 0; i <= num_of_birds; i++) begin
					deploy_bird[i] <= 1'b1;
				end
				deploy_pickup <= 1'b1;
				number_of_trees <= number_of_trees + trees_to_add;
			end
			
			if (bird_alive != 2'b0) begin
				bird_hit_flag <= 1'b0;
			end
			
			if (SingleHitPulse && !invincible) begin // when hit
				if (player_life > 1) begin
					player_life <= player_life - 1;
					red_counter <= 64;
				end
				else begin
					// game over
					player_active <= 1'b0;
				end
			end
			
			if (out_of_time) begin
				// game over
				player_active <= 1'b0;
			end
			
			if ((bird_hit_flag == 1'b0) && (bird_alive == 4'h0)) begin // finished level
				level_counter <= 100;
				level_up <= 1'b1;
				bird_hit_flag <= 1'b1;
			end
			
			if ((level_counter == 1) && (bird_alive == 4'h0)) begin
				start_level <= 1'b1;
			end
			
			if ((bird_alive < last_birds) && player_active) begin
				time_to_add <= {4'h1, 4'h0};
				add_time <= 1'b1;
			end
			
			if (power_up_counter == 0) begin
				powerups <= 4'b0;
			end
			
			if (pickup_hit) begin
				powerups[random[5:4]] <= 1'b1;
				power_up_counter <= power_up_time;
			end
			
			if (powerups[3] == 1'b1) begin
				player_life <= (player_life > 2) ? player_life : player_life + 1;
				powerups[3] <= 1'b0;
			end
		end
	end 
end

assign player_red = red_counter > 0;

endmodule
