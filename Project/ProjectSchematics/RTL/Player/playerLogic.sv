

module	playerLogic	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input	logic	left,  //turn left
					input	logic	right,  //turn right
					input logic collision,  //collision if player hits an object
					input logic invincible, //turn on invincible

					output logic signed [10:0] [1:0]	coordinate,// output the top left corner 					
);


// a module used to generate player movement.  

parameter int SCREEN_WIDTH = 640;
parameter int SCREEN_HEIGHT = 480;
parameter int INITIAL_X = 303;
parameter int INITIAL_Y = 447; 
parameter int IMAGE_WIDTH = 32;
parameter int IMAGE_HeiGHT = 32;


const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to work with integers in high resolution 
// we do all calulations with topLeftX_FixedPoint  so we get a resulytion inthe calcuatuions of 1/64 pixel 
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n 
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;


int topLeftX_FixedPoint; // local parameters 
int step = 10;


//////////--------------------------------------------------------------------------------------------------------------=
// position calculate 


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
	end
	else begin
		if (startOfFrame == 1'b1) begin // perform  position integral only 30 times per second 
			if (right && left) begin 
			end
			else if (right && (topLeftX_FixedPoint < (x_FRAME_SIZE - (32*FIXED_POINT_MULTIPLIER)))) begin
				topLeftX_FixedPoint <= topLeftX_FixedPoint + step;
			end 
			else if (left && (topLeftX_FixedPoint > 0)) begin
				topLeftX_FixedPoint <= topLeftX_FixedPoint - step;
			end
		end
	end
end


//get a better (64 times) resolution using integer   
assign 	coordinate[0] = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	coordinate[1] = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule
