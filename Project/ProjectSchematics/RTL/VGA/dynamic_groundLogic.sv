

module	dynamic_groundLogic	(	
	input	logic	clk,
	input	logic	resetN,
	input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
	input logic [2:0] speed,
	
	output logic signed [1:0] [10:0]	coordinate// output the top left corner 	
);


// a module used to generate the  ball trajectory.  

localparam int SCREEN_WIDTH = 640;
localparam int SCREEN_HEIGHT = 480;
localparam int GROUND_HEIGHT = 64; // if grass is 64 bit
localparam int INITIAL_Y = - GROUND_HEIGHT; 
localparam int INITIAL_STEP = 64;
localparam int SPEED_MULTIPLIER = 32;
const int INITIAL_X = 0;



const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to work with integers in high resolution 
// we do all calulations with topLeftX_FixedPoint  so we get a resulytion inthe calcuatuions of 1/64 pixel 
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n 

int topLeftY_FixedPoint, topLeftX_FixedPoint; // local parameters 
int step; // moving speed of tree


//////////--------------------------------------------------------------------------------------------------------------=
// position calculate 

always_comb 
begin
	step = INITIAL_STEP + (SPEED_MULTIPLIER * speed);
end


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_FixedPoint	<=  SCREEN_WIDTH * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint	<=  SCREEN_HEIGHT * FIXED_POINT_MULTIPLIER;
	end
	else begin	
		if (startOfFrame == 1'b1) begin // perform  position integral only 30 times per second 
			if (topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER >= 0) begin //ground bitmap is wholy within screen
				topLeftY_FixedPoint <= (topLeftY_FixedPoint - GROUND_HEIGHT  *  FIXED_POINT_MULTIPLIER) + step; // jump back to start of screen
				topLeftX_FixedPoint	<= INITIAL_X;
			end 
			else begin
				topLeftY_FixedPoint <= topLeftY_FixedPoint + step; //move down
			end
		end
	end
end


//get a better (64 times) resolution using integer   
assign 	coordinate[0] = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   
assign 	coordinate[1] = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ; 

endmodule
