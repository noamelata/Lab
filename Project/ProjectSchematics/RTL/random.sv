module random 	
 ( 
	input	logic  clk,
	input	logic  resetN, 
	input	logic	rise,
	output logic [SIZE_BITS-1:0]	dout	
  ) ;

  //generating a random number by latching a fast counter with the rising edge of an input ( e.g. key pressed )
  
parameter SIZE_BITS = 8;
parameter COUNTER_SIZE = 25;

localparam logic [SIZE_BITS - 1:0] ZERO_OUT = 8'b0;
localparam logic [COUNTER_SIZE - 1:0] FULL_COUNTER = 25'h1FFFFFF;
//parameter MIN_VAL = 0;  //set the min and max values 
//parameter MAX_VAL = 255;

	logic [COUNTER_SIZE - 1:0] counter;
	logic rise_d;
	
	
//always_ff @(posedge clk or negedge resetN) begin
//		if(!resetN) begin
//			dout <= 0;
//			counter <= MIN_VAL;
//			rise_d <= 1'b0;
//		end
//		
//		else begin
//			counter <= counter + 1;
//			if ( counter >= MAX_VAL ) 
//					counter <=  MIN_VAL ; // set min and max mvalues 
//			rise_d <= rise;
//			if (rise && !rise_d) // rizing edge 
//				dout <= counter[SIZE_BITS-1:0];
//		end
//			
//	
//	end


always_ff @(posedge clk or negedge resetN) begin
	if(!resetN) begin
		dout <= ZERO_OUT;
		rise_d <= 1'b0;
		counter <= FULL_COUNTER;
	end
	
	else begin
		counter <= {counter[COUNTER_SIZE-2:0], counter[COUNTER_SIZE-1] ^ counter[1]} ;
		rise_d <= rise;
		if (rise && !rise_d) // rizing edge 
			dout <= counter[9:2];
	end
		

end
	
 

 
endmodule

