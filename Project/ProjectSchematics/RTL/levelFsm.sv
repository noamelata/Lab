
module levelFsm (
 input logic clk,             
 input logic resetN,
 input logic level_up,
 input logic startOfFrame,

 output logic [BIRD_LIFE_LEVELS - 1:0] bird_life,
 output logic [NUM_OF_TREES - 1:0] trees_to_add,
 output logic [TREE_SPEED_LEVELS - 1:0] tree_speed,
 output logic [BIRD_SPEED_LEVELS - 1:0] bird_speed,
 output logic [NUM_OF_BIRDS_BINARY - 1:0] number_of_birds,
 output logic [1:0] [3:0] level_num
);
		 

localparam int NUM_OF_TREES = 16; //max number of levels
localparam int NUM_OF_BIRDS = 4; //max number of birds
localparam int TREE_SPEED_LEVELS = 3; //how many levels of speed for trees
localparam int BIRD_SPEED_LEVELS = 2; //how many levels of speed for birds
localparam int BIRD_LIFE_LEVELS = 4; 
localparam int NUM_OF_BIRDS_BINARY = 2;

localparam logic [3:0] MAX_DIGIT = 4'h9;
localparam logic [3:0] ONE_DIGIT = 4'h1;
localparam logic [3:0] ZERO_DIGIT = 4'h0;

//birds active per level
localparam logic [1:0] ONE_BIRD = 2'h0;
localparam logic [1:0] TWO_BIRDS = 2'h1;
localparam logic [1:0] THREE_BIRDS = 2'h2;
localparam logic [1:0] FOUR_BIRDS = 2'h3;

//bird speed per level
localparam logic [1:0] BIRD_SPEED_1 = 2'h0;
localparam logic [1:0] BIRD_SPEED_2 = 2'h1;
localparam logic [1:0] BIRD_SPEED_3 = 2'h2;
localparam logic [1:0] BIRD_SPEED_4 = 2'h3;

//tree speed per level
localparam logic [2:0] TREE_SPEED_1 = 3'h0;
localparam logic [2:0] TREE_SPEED_2 = 3'h1;
localparam logic [2:0] TREE_SPEED_3 = 3'h2;
localparam logic [2:0] TREE_SPEED_4 = 3'h3;
localparam logic [2:0] TREE_SPEED_5 = 3'h4;
localparam logic [2:0] TREE_SPEED_6 = 3'h5;
localparam logic [2:0] TREE_SPEED_7 = 3'h6;
localparam logic [2:0] TREE_SPEED_8 = 3'h7;

//bird lives per level
localparam logic [3:0] THREE_BIRD_LIVES = 4'h3;
localparam logic [3:0] FOUR_BIRD_LIVES = 4'h4;
localparam logic [3:0] FIVE_BIRD_LIVES = 4'h5;
localparam logic [3:0] SIX_BIRD_LIVES = 4'h6;
localparam logic [3:0] SEVEN_BIRD_LIVES = 4'h7;

//trees active per level
localparam logic [15:0] TWO_TREES = 16'h101; //trees # 0,8
localparam logic [15:0] FOUR_TREES = 16'h1111; //trees # 0,4,8,12
localparam logic [15:0] SIX_TREES = 16'h1515; //trees # 0,2,4,6,8,12
localparam logic [15:0] EIGHT_TREES = 16'h5555; //trees # 0,2,4,6,8,10,12,14
localparam logic [15:0] TEN_TREES = 16'hD5D5; //trees # 0,2,4,6,7,8,10,12,14,15
localparam logic [15:0] TWELVE_TREES = 16'hDDDD; //trees # 0,2,3,4,6,7,8,10,11,12,14,15
localparam logic [15:0] FOURTEEN_TREES = 16'hDFDF; //trees # 0,1,2,3,4,6,7,8,9,10,11,12,14,15
localparam logic [15:0] SIXTEEN_TREES = 16'hFFFF; //trees # 0 - 15
	 
enum logic [3:0] {level_1, level_2, level_3, level_4, level_5, level_6, level_7, level_8} level, next_level;
 
always @(posedge clk or negedge resetN)
   begin   
   if ( !resetN ) begin // Asynchronic reset
		level <= level_1;
		level_num[0] <= ONE_DIGIT;
		level_num[1] <= ZERO_DIGIT;
	end
   else begin 	// Synchronic logic FSM
		if (level == level_8)
			level <= level;
		else
			level <= next_level;
		if (level_up == 1'b1) begin
			if (level_num[0] == MAX_DIGIT) begin
				level_num[0] <= ZERO_DIGIT;
				level_num[1] <= level_num[1] + ONE_DIGIT;
			end
			else
				level_num[0] <= level_num[0] + ONE_DIGIT;
		end
	end
end // always

always_comb
begin
	next_level = level;
	if (level_up == 1'b1)
		next_level = level.next;	

	tree_speed = TREE_SPEED_1;
	bird_speed = BIRD_SPEED_1;
	number_of_birds = ONE_BIRD;
	bird_life = THREE_BIRD_LIVES;
	  
	case(level)
	level_1:
	begin
		trees_to_add = TWO_TREES;
	end
	
	level_2:
	begin
		trees_to_add = FOUR_TREES;
		bird_speed = BIRD_SPEED_2;
		tree_speed = TREE_SPEED_2;
	end
		 
	level_3:
	begin
		 trees_to_add = SIX_TREES;
		 number_of_birds = TWO_BIRDS;
		 tree_speed = TREE_SPEED_3;
		 bird_speed = BIRD_SPEED_2;
		 bird_life = FOUR_BIRD_LIVES;
	end
		 
	level_4:
	begin
		 number_of_birds = TWO_BIRDS;
		 tree_speed = TREE_SPEED_4;
		 bird_speed = BIRD_SPEED_3;
		 trees_to_add = EIGHT_TREES;
		 bird_life = FOUR_BIRD_LIVES;
	end
	  
	level_5:
	begin
		 number_of_birds = THREE_BIRDS;
		 trees_to_add = TEN_TREES;
		 tree_speed = TREE_SPEED_5;
		 bird_speed = BIRD_SPEED_3;
		 bird_life = FIVE_BIRD_LIVES;
	end
	  
	level_6:
	begin
		 number_of_birds = THREE_BIRDS;
		 tree_speed = TREE_SPEED_6;
		 bird_speed = BIRD_SPEED_3;
		 trees_to_add = TWELVE_TREES;
		 bird_life = FIVE_BIRD_LIVES;
	end
		 
	level_7:
	begin
		 trees_to_add = FOURTEEN_TREES;
		 number_of_birds = FOUR_BIRDS;
		 tree_speed = TREE_SPEED_7;
		 bird_speed = BIRD_SPEED_4;
		 bird_life = SIX_BIRD_LIVES;
	end
		 
	level_8:
	begin
		 trees_to_add = SIXTEEN_TREES;
		 number_of_birds = FOUR_BIRDS;
		 tree_speed = TREE_SPEED_8;
		 bird_speed = BIRD_SPEED_4;
		 bird_life = SEVEN_BIRD_LIVES;
	end
	
	  endcase;
end

endmodule
