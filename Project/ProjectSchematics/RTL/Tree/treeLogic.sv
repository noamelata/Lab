

module	treeLogic	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic deploy, 
					input logic [7:0] random, //random number from random generator
					input logic [2:0] speed,
					
					output logic signed [1:0] [10:0]	coordinate,// output the top left corner 	
					output logic isActive, //should tree be on screen
					output logic jump
);


// a module used to generate the  ball trajectory.  

parameter int SCREEN_WIDTH = 640;
parameter int SCREEN_HEIGHT = 480;
parameter int INITIAL_Y = -64;

const int JUMP_Y = -64;
logic wait_for_jump;


const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to work with integers in high resolution 
// we do all calulations with topLeftX_FixedPoint  so we get a resulytion inthe calcuatuions of 1/64 pixel 
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n 
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;


int topLeftY_FixedPoint, topLeftX_FixedPoint; // local parameters 
int step; // moving speed of tree


//////////--------------------------------------------------------------------------------------------------------------=
// position calculate 

always_comb 
begin
	step = 64 + (32 * speed);
end


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_FixedPoint	<=  ((random * 2) + (random / 4) + (random / 8)) * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint	<=  INITIAL_Y * FIXED_POINT_MULTIPLIER;
		isActive <= 1'b0;
		jump <= 1'b0;
		wait_for_jump <= 1'b0;
	end
	else begin
		isActive <= isActive;
		jump <= 1'b0;
		if (deploy) 
			wait_for_jump <= 1'b1;
		if (wait_for_jump && jump)
			isActive <= 1'b1;
		if (startOfFrame == 1'b1) begin // perform  position integral only 30 times per second 
			if (topLeftY_FixedPoint > (y_FRAME_SIZE)) begin
				topLeftY_FixedPoint <= JUMP_Y * FIXED_POINT_MULTIPLIER;
				topLeftX_FixedPoint	<=  ((random * 2) + (random / 4) + (random / 8)) * FIXED_POINT_MULTIPLIER;
				jump <= 1'b1;
			end 
			else begin
				topLeftY_FixedPoint <= topLeftY_FixedPoint + step;
			end
		end
	end
end


//get a better (64 times) resolution using integer   
assign 	coordinate[0] = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   
assign 	coordinate[1] = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ; 

endmodule
