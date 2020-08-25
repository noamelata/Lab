
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2020 


module	game_controller	(	
			input		logic	clk,
			input		logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input	logic	drawing_request_Ball,
			input	logic	drawing_request_1,
			input logic shoot,
			input logic [10:0] playerCoordinates,
		
			
			output logic [1:0] tree_speed;
			output logic [1:0] bird_speed;
			output logic [7:0] deploy_shot;
			output logic [7:0] deploy_tree;
			output logic [1:0] deploy_bird;

			output logic collision, // active in case of collision between two objects
			output logic SingleHitPulse // critical code, generating A single pulse in a frame 
);

localparam int number_of_trees = 0;
localparam int number_of_birds = 1;
localparam logic [1:0] tree_speed = 0;
localparam logic [1:0] bird_speed = 0;

localparam int cooldown = 0;
localparam int current_shot = 0;
localparam int current_tree = 0;

localparam int MAX_SHOTS = 8;
localparam int MAX_TREES = 8;



assign collision = (drawing_request_Ball &&  drawing_request_1  == 1'b1 ) ; 

logic flag ; // a semaphore to set the output only once per frame / regardless of the number of collisions 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		current_shot <= 0;
		current_tree <= 0;
		cooldown <= 0;
	end 
	else begin 
		if (shoot && !cooldown) begin
			deploy_shot[current_shot] <= 1'b1;
			current_shot <= (current_shot == MAX_SHOTS - 1) ? 0 : current_shot + 1;
		end
		if (/*when to deploy tree*/) begin
			deploy_tree[current_tree] <= 1'b1;
			current_tree <= current_tree == MAX_trees - 1 ? 0 : current_tree + 1;
		end
		if (/*starting level*/) begin
			for (int i = 0; i < number_of_birds; i ++) begin
				deploy_bird[i] <= 1'b1;
			end
			// more beginning of level logic
		end
		
	end 
end

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag	<= 1'b0;
		SingleHitPulse <= 1'b0 ; 
	end 
	else begin 

			SingleHitPulse <= 1'b0 ; // default 
			if(startOfFrame) 
				flag = 1'b0 ; // reset for next time 
			if ( collision  && (flag == 1'b0)) begin 
				flag	<= 1'b1; // to enter only once 
				SingleHitPulse <= 1'b1 ; 
			end ; 
	end 
end

endmodule
