
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2020 


module	game_controller	(	
			input		logic	clk,
			input		logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input logic shoot,
			input logic [10:0] playerCoordinates,
			input logic random,
			input logic [1:0] bird_alive,
		
			
			output logic [1:0] tree_speed,
			output logic [1:0] bird_speed,
			output logic [7:0] deploy_shot,
			output logic [7:0] deploy_tree,
			output logic [1:0] deploy_bird,

			output logic collision, // active in case of collision between two objects
			output logic SingleHitPulse, // critical code, generating A single pulse in a frame 
			output logic total_time,
);

int number_of_trees = 0;
int number_of_birds = 1;
logic [1:0] tree_speed = 2'b0;
logic [1:0] bird_speed = 2'b0;

int cooldown_time = 20;
int cooldown = 0;
int current_shot = 0;
int current_tree = 0;

localparam int MAX_SHOTS = 8;
localparam int MAX_TREES = 8;
int tree_wait;
int counter;
logic start_level;

assign tree_wait = 8; //should be calculated using tree speed and number of trees


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		current_shot <= 0;
		current_tree <= 0;
		cooldown <= 0;
		counter <= 0;
	end 
	else begin 
		if (startOfFrame) begin
			deploy_tree <= 1'h0;
			cooldown <= (cooldown == 0) ? 0 : cooldown - 1;
			start_level <= 1'b0;
			counter <= (counter == tree_wait) ? 0 : counter + 1;
			deploy_bird <= 2'b00;
			
			if (shoot && !cooldown) begin
				deploy_shot[current_shot] <= 1'b1;
				current_shot <= (current_shot == MAX_SHOTS - 1) ? 0 : current_shot + 1;
				cooldown <= cooldown_time;
			end
			if (counter == (tree_wait - 1)) begin // when to deploy tree
				deploy_tree[current_tree] <= 1'b1;
				current_tree <= current_tree == MAX_trees - 1 ? 0 : current_tree + 1;
			end
			
			if (start_level == 1'b1) begin // at beginning of level
				for (int i = 0; i < number_of_birds; i ++) begin
					deploy_bird[i] <= 1'b1;
				end
			end
		
		end
	end 
end


endmodule
