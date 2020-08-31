

module	dynamic_groundLogic	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic [2:0] speed,
					
					output logic signed [1:0] [10:0]	coordinate// output the top left corner 	
);


// a module used to generate the  ball trajectory.  

parameter int SCREEN_WIDTH = 640;
parameter int SCREEN_HEIGHT = 480;
parameter int INITIAL_Y = 0; // if tree is 32 bit
const int INITIAL_X = 0;



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
		topLeftX_FixedPoint	<=  SCREEN_WIDTH * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint	<=  SCREEN_HEIGHT * FIXED_POINT_MULTIPLIER;
	end
	else begin	
		if (startOfFrame == 1'b1) begin // perform  position integral only 30 times per second 
			if (topLeftY_FixedPoint >= (63 * FIXED_POINT_MULTIPLIER)) begin
				topLeftY_FixedPoint <= INITIAL_Y + step;
				topLeftX_FixedPoint	<= INITIAL_X;
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
