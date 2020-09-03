

module	shitLogic	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					//input logic collision,  //collision if shit hits
					input logic deploy, 
					//input logic remove,
					input logic signed [10:0] initial_x,
					input logic signed [10:0] initial_y,
					input logic [2:0] speed,
					
					output logic signed [1:0] [10:0]	coordinate,// output the top left corner 	
					output logic isActive, //should shit be on screen
					output logic splash
);


// a module used to generate the  ball trajectory.  

parameter int SCREEN_WIDTH = 640;
parameter int SCREEN_HEIGHT = 480;
//parameter int IMAGE_HEIGHT = 64;
const int INITIAL_Y = 0; // if shit is 32 bit



const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to work with integers in high resolution 
// we do all calulations with topLeftX_FixedPoint  so we get a resulytion inthe calcuatuions of 1/64 pixel 
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n 
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;


int topLeftY_FixedPoint, topLeftX_FixedPoint; // local parameters 
int step; // moving speed of shit
int counter;


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
		isActive <= 1'b0;
	end
	else begin
		isActive <= isActive;
		if (deploy) begin
				//generate random
				topLeftX_FixedPoint	<=  initial_x * FIXED_POINT_MULTIPLIER;
				topLeftY_FixedPoint	<=  initial_y * FIXED_POINT_MULTIPLIER;
				isActive <= 1'b1;
				counter <= 64;
			end
		
		if ((startOfFrame == 1'b1) && isActive) begin // perform  position integral only 30 times per second 
			counter <= (counter > 0) ? counter - 1 : 0;
			if (topLeftY_FixedPoint > (y_FRAME_SIZE)) begin
				topLeftX_FixedPoint	<=  SCREEN_WIDTH * FIXED_POINT_MULTIPLIER;
				topLeftY_FixedPoint	<=  SCREEN_HEIGHT * FIXED_POINT_MULTIPLIER;
				isActive <= 1'b0;
			end 
			else begin
				if (counter > 0) begin 
					topLeftY_FixedPoint <= topLeftY_FixedPoint + 64;
				end else begin
					topLeftY_FixedPoint <= topLeftY_FixedPoint + step;
				end
			end
		end
		/*
		if (remove) begin
			topLeftX_FixedPoint	<=  SCREEN_WIDTH * FIXED_POINT_MULTIPLIER;
			topLeftY_FixedPoint	<=  SCREEN_HEIGHT * FIXED_POINT_MULTIPLIER;
			isActive <= 1'b0;
		end
		*/
	end
end


//get a better (64 times) resolution using integer   
assign 	coordinate[0] = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   
assign 	coordinate[1] = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ; 
assign 	splash = (counter == 0);

endmodule
