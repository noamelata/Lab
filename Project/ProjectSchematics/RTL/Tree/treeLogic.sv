

module	treeLogic	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input logic collision,  //collision if shot hits
					input logic deploy,
					input logic remove,
					input logic [7:0] random, //random number from random generator
					input logic [1:0] speed,
					output logic signed [10:0] [1:0]	coordinate,// output the top left corner 					
);


// a module used to generate the  ball trajectory.  

parameter int SCREEN_HEIGHT = 480;
parameter int INITIAL_Y = 185; //todo
parameter int IMAGE_WIDTH = 32;
parameter int IMAGE_HeiGHT = 32;



const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to work with integers in high resolution 
// we do all calulations with topLeftX_FixedPoint  so we get a resulytion inthe calcuatuions of 1/64 pixel 
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n 
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;


int topLeftY_FixedPoint, topLeftX_FixedPoint; // local parameters 
int step
int random;

logic [11:0] initial_x;


//////////--------------------------------------------------------------------------------------------------------------=
// position calculate 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_FixedPoint	<=  SCREEN_WIDTH * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint	<=  SCREEN_HEIGHT * FIXED_POINT_MULTIPLIER;
	end
	else begin
		if (deploy) begin
				//generate random
				topLeftX_FixedPoint	<=  initial_x * FIXED_POINT_MULTIPLIER;
				topLeftY_FixedPoint	<=  INITIAL_Y * FIXED_POINT_MULTIPLIER;
			end
		
		if (startOfFrame == 1'b1) begin // perform  position integral only 30 times per second 
			if (topLeftY_FixedPoint > (y_FRAME_SIZE - 32)) begin
				topLeftY_FixedPoint <= 0;
				//generate random
				topLeftX_FixedPoint	<=  initial_x * FIXED_POINT_MULTIPLIER;
			end 
			else begin
				topLeftX_FixedPoint <= topLeftX_FixedPoint - step;
			end
		end
		
		if (remove) begin
			topLeftX_FixedPoint	<=  SCREEN_WIDTH * FIXED_POINT_MULTIPLIER;
			topLeftY_FixedPoint	<=  SCREEN_HEIGHT * FIXED_POINT_MULTIPLIER;
		end
	end
end


//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule
