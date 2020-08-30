

module	shotLogic	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic deploy,
					input logic collision,  //collision if shot hits
					input logic [1:0] direction,
					input logic signed [10:0] initial_x,
					
					output logic isActive,
					output logic signed [1:0] [10:0] coordinate// output the top left corner 					
);


// a module used to generate the  ball trajectory.  

parameter int SCREEN_WIDTH = 640;
parameter int SCREEN_HEIGHT = 480;
parameter int INITIAL_Y = 383; // default value
parameter int IMAGE_WIDTH = 16;
parameter int IMAGE_HEIGHT = 16;




const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to work with integers in high resolution 
// we do all calulations with topLeftX_FixedPoint  so we get a resulytion inthe calcuatuions of 1/64 pixel 
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n 
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;


int topLeftY_FixedPoint, topLeftX_FixedPoint; // local parameters 
int speedX = 0; //speed of bullet in X axis
const int speedY = 150; //speed of bullet in Y axis

//////////--------------------------------------------------------------------------------------------------------------=
// position calculate 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_FixedPoint	<=  SCREEN_WIDTH * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint	<=  SCREEN_HEIGHT * FIXED_POINT_MULTIPLIER;
		isActive <= 1'b0;
	end
	else begin
		if (startOfFrame == 1'b1) begin // perform  position integral only 30 times per second
			if (deploy) begin
				topLeftX_FixedPoint	<=  initial_x * FIXED_POINT_MULTIPLIER;
				topLeftY_FixedPoint	<=  INITIAL_Y * FIXED_POINT_MULTIPLIER;
				isActive <= 1'b1;
				speedX <= 0;
				case (direction)
					0: speedX <= 0;
					1: speedX <= 25;
					2: speedX <= -25;
				endcase
			end
			if (isActive) begin // move
				topLeftX_FixedPoint <= topLeftX_FixedPoint + speedX;
				topLeftY_FixedPoint <= topLeftY_FixedPoint - speedY; 
			end
			if ((collision) || (topLeftY_FixedPoint <= (-IMAGE_HEIGHT * FIXED_POINT_MULTIPLIER))) begin
				topLeftX_FixedPoint	<=  SCREEN_WIDTH * FIXED_POINT_MULTIPLIER;
				topLeftY_FixedPoint	<=  SCREEN_HEIGHT * FIXED_POINT_MULTIPLIER;
				isActive <= 1'b0;
			end
		end
	end
end

//get a better (64 times) resolution using integer   
assign 	coordinate[0] = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   
assign 	coordinate[1] = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ; 

endmodule
