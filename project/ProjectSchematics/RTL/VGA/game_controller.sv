


module	game_controller	(	
			input	logic	clk,
			input	logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input logic shoot,
			input logic [10:0] playerCoordinates,
			input logic [7:0] random,
			input logic [1:0] bird_alive,
			input logic collision, // active in case of collision between player and tree
			input logic SingleHitPulse, // critical code, generating A single pulse in a frame 
		
			
			output logic [1:0] tree_speed,
			output logic [1:0] bird_speed,
			output logic [7:0] deploy_shot,
			output logic [7:0] deploy_tree,
			output logic [1:0] deploy_bird,
			output logic [3:0] bird_life,
			output logic player_red,
			
			output logic total_time
);



int number_of_trees = 0;
const int number_of_birds = 1;
assign tree_speed = 2'b0;
assign bird_speed = 2'b0;


int cooldown_time = 100;
int cooldown = 0;
int current_shot = 0;
int current_tree = 0;

localparam int MAX_SHOTS = 8;
localparam int MAX_TREES = 8;
int tree_wait;
int tree_counter;
int life = 3; //bird life
const int trees_to_add = 0;//VERIFY WITH N
logic start_level;

assign tree_wait = 8; //should be calculated using tree speed and number of trees


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		current_shot <= 0;
		current_tree <= 0;
		cooldown <= 0;
		tree_counter <= 0;
	end 
	else begin 
		if (startOfFrame) begin
			deploy_tree <= 8'h0;
			cooldown <= (cooldown == 0) ? 0 : cooldown - 1;
			current_shot <= current_shot;
			start_level <= 1'b0;
			current_tree <= current_tree;
			tree_counter <= (tree_counter == tree_wait) ? 0 : tree_counter + 1;
			deploy_bird <= 2'b00;
			deploy_shot <= 8'h00;

			
			if (shoot && (cooldown == 0)) begin // trying to shoot
				deploy_shot[current_shot] <= 1'b1;
				current_shot <= (current_shot == MAX_SHOTS - 1) ? 0 : current_shot + 1;
				cooldown <= cooldown_time;
			end
			
			if ((number_of_trees >= 0) && (tree_counter == (tree_wait - 1))) begin // when to deploy tree
				deploy_tree[current_tree] <= 1'b1;
				current_tree <= current_tree == MAX_TREES - 1 ? 0 : current_tree + 1;
				number_of_trees <= number_of_trees - 1;
			end
			
			if (start_level == 1'b1) begin // at beginning of level
				for (int i = 0; i < number_of_birds; i++) begin
					deploy_bird[i] <= 1'b1;
				end
				number_of_trees <= trees_to_add;
			end
			
			if (SingleHitPulse) begin // when hit
				if (life > 1) begin
					life <= life - 1;
					//flash red
				end
				else begin
					// game over
					//remove player untill reset
				end
			end
			
			if (bird_alive == 2'b00) begin // finished level
				start_level <= 1'b1;
			end
		
		end
	end 
end

endmodule
