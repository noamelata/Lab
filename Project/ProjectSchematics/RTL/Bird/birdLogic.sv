

module	birdLogic #(parameter RANDOM_OFFSET = 0) /* sample random with parameter */	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic collision,  //collision if shot hits
					input logic [7:0] random, //random number from random generator
					input logic [3:0] starting_life,
					input logic deploy,
					input logic [1:0] speed,
					
					output logic alive,
					output logic red,
					output logic signed [1:0] [10:0]	coordinate// output the top left corner 					
);


// a module used to generate the  ball trajectory.  

localparam int SCREEN_WIDTH = 640;
localparam int SCREEN_HEIGHT = 480;
localparam int INITIAL_X = 280; //todo
localparam int INITIAL_Y = 185; 
localparam int IMAGE_WIDTH = 32;
localparam int IMAGE_HeiGHT = 32;

localparam int MAX_RANDOM = 255; // max value of random

enum logic [1:0] {idle_state, right_state, left_state} state, next_state;


const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to work with integers in high resolution 
// we do all calulations with topLeftX_FixedPoint  so we get a resulytion inthe calcuatuions of 1/64 pixel 
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n 
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;


int topLeftY_FixedPoint, topLeftX_FixedPoint; // local parameters 
int step;
int life;
int counter;
int random_num;
int chance_to_change = 8;


//////////--------------------------------------------------------------------------------------------------------------=
// position calculate 
always_comb
begin
	step = 50 + (20 * speed);
	random_num = random + RANDOM_OFFSET;
	if (random_num > MAX_RANDOM) begin
		random_num = random_num - MAX_RANDOM;
	end
	
	next_state = state;
	if ((startOfFrame == 1'b1) && (random_num < chance_to_change)) begin
		if (state == idle_state)
			next_state = (random_num < (chance_to_change/2)) ? right_state : left_state;
		else
			next_state = idle_state;
				
	end
	
end


always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN )  // Asynchronic reset
		state <= idle_state;
   else 		// Synchronic logic FSM
		state <= next_state;

	end // always

	
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_FixedPoint	<=  INITIAL_X * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint	<=  INITIAL_Y * FIXED_POINT_MULTIPLIER;
	end
	else begin
		if (startOfFrame == 1'b1) begin // perform  position integral only 30 times per second 
			counter <= (counter > 0) ? counter - 1 : 0;
			
			if (deploy) begin
				life <= starting_life;
			end
			if (collision) begin
				life <= life - 1;
				counter <= 32; // frames to stay red, should be calculated
			end
			
			case (state)
			right_state: 
				if (topLeftX_FixedPoint < (x_FRAME_SIZE - (32*FIXED_POINT_MULTIPLIER))) begin
					topLeftX_FixedPoint <= topLeftX_FixedPoint + step;
				end
			left_state: 
				if (topLeftX_FixedPoint > 0) begin
					topLeftX_FixedPoint <= topLeftX_FixedPoint - step;
				end
			default:
				topLeftX_FixedPoint <= topLeftX_FixedPoint;
					
			endcase
			
		end		
	end
end

//get a better (64 times) resolution using integer   
assign 	coordinate[0] = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   
assign 	coordinate[1] = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    

assign 	red = counter > 0;
assign 	alive = (life > 0) || red; // dont disappear until finished flashing red

endmodule
