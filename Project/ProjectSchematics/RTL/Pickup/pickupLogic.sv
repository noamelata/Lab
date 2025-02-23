

module	pickupLogic	(	
 
	input	logic	clk,
	input	logic	resetN,
	input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
	input logic deploy, 
	input logic remove,
	input logic [7:0] random, //random number from random generator
	input logic [2:0] speed, //moving speed of pickup (same as ground and trees)
	
	output logic signed [1:0] [10:0]	coordinate,// output the top left corner 	
	output logic isActive //should pickup be on screen
);


// a module used to generate the  ball trajectory.  

parameter int SCREEN_WIDTH = 640;
parameter int SCREEN_HEIGHT = 480;
const int INITIAL_Y = -32; // if pickup is 32 bit



const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to work with integers in high resolution 
// we do all calulations with topLeftX_FixedPoint  so we get a resulytion inthe calcuatuions of 1/64 pixel 
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;

localparam TWO = 2;
localparam INITIAL_STEP = 64;
localparam SPEED_MULTIPLIER = 32;

int topLeftY_FixedPoint, topLeftX_FixedPoint; // local parameters 
int step; // moving speed of pickup


//////////--------------------------------------------------------------------------------------------------------------=
// position calculate 

always_comb 
begin
	step = INITIAL_STEP + (SPEED_MULTIPLIER * speed); //movement speed
end


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin //initial paramaters
		topLeftX_FixedPoint	<=  SCREEN_WIDTH * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint	<=  SCREEN_HEIGHT * FIXED_POINT_MULTIPLIER;
		isActive <= 1'b0;
	end
	else begin
		isActive <= isActive;
		if (deploy) begin // deploy pickup
				//generate random
				topLeftX_FixedPoint	<=  random * TWO * FIXED_POINT_MULTIPLIER;
				topLeftY_FixedPoint	<=  INITIAL_Y * FIXED_POINT_MULTIPLIER;
				isActive <= 1'b1;
			end
		
		if ((startOfFrame == 1'b1) && isActive) begin // perform  position integral only 30 times per second 
			if (topLeftY_FixedPoint > (y_FRAME_SIZE)) begin //pickup left screen
				isActive <= 1'b0;
			end 
			else begin
				topLeftY_FixedPoint <= topLeftY_FixedPoint + step; //movement down
			end
		end
		
		if (remove) begin //remove pickup (taken)
			topLeftX_FixedPoint	<=  SCREEN_WIDTH * FIXED_POINT_MULTIPLIER;
			topLeftY_FixedPoint	<=  SCREEN_HEIGHT * FIXED_POINT_MULTIPLIER;
			isActive <= 1'b0;
		end
	end
end


//get a better (64 times) resolution using integer   
assign 	coordinate[0] = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   
assign 	coordinate[1] = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ; 

endmodule
