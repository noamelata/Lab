

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
  

parameter int SCREEN_WIDTH = 640;
parameter int SCREEN_HEIGHT = 480;
parameter int INITIAL_Y = -64;

localparam INITIAL_STEP = 64;
localparam JUMP_Y = -64;
localparam SPEED_MULTIPLIER = 32;
localparam BIT_2 = 2;
localparam BIT_4 = 4;
localparam BIT_8 = 8;

logic wait_for_jump;


const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to work with integers in high resolution 
// we do all calulations with topLeftX_FixedPoint  so we get a resulytion inthe calcuatuions of 1/64 pixel 
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;

int topLeftY_FixedPoint, topLeftX_FixedPoint; // local parameters 
int step; // moving speed of tree


//////////--------------------------------------------------------------------------------------------------------------=
// position calculate 

always_comb 
begin
	step = INITIAL_STEP + (SPEED_MULTIPLIER * speed); //movement speed 
end


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
	//reset values
		topLeftX_FixedPoint	<=  ((random * BIT_2) + (random / BIT_4) + (random / BIT_8)) * FIXED_POINT_MULTIPLIER; //expansion of random (255 max) to 640 
		topLeftY_FixedPoint	<=  INITIAL_Y * FIXED_POINT_MULTIPLIER;
		isActive <= 1'b0; 
		jump <= 1'b0; 
		wait_for_jump <= 1'b0;
	end
	else begin
		//default values
		isActive <= isActive;
		jump <= 1'b0;
		if (deploy) //tree should be dispayed	
			wait_for_jump <= 1'b1; //wait for next time tree jumps
		if (wait_for_jump && jump) //tree should be displayed and jumped
			isActive <= 1'b1; //show tree
		if (startOfFrame == 1'b1) begin // perform  position integral only 30 times per second 
			if (topLeftY_FixedPoint > (y_FRAME_SIZE)) begin
				//tree reached end of screen and need to jump to start of screen
				topLeftY_FixedPoint <= JUMP_Y * FIXED_POINT_MULTIPLIER;
				topLeftX_FixedPoint	<=  ((random * BIT_2) + (random / BIT_4) + (random / BIT_8)) * FIXED_POINT_MULTIPLIER;
				jump <= 1'b1;
			end 
			else begin
				//continue moving down normaly
				topLeftY_FixedPoint <= topLeftY_FixedPoint + step;
			end
		end
	end
end


//get a better (64 times) resolution using integer   
assign 	coordinate[0] = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   
assign 	coordinate[1] = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ; 

endmodule
