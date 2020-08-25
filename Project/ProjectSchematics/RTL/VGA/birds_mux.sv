

module	birds_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,

					input		logic	bird1DrawingRequest,
					input		logic	[7:0] bird1RGB, 
					
					input		logic	bird2DrawingRequest,
					input		logic	[7:0] bird2RGB, 
					

					output	logic birdsDrawingRequest,
					output	logic	[7:0] birdsRGB, 
					
);

logic [7:0] tmpRGB;



assign birdsRGB	  = tmpRGB; //--  extend LSB to create 10 bits per color  
assign birdsDrawingRequest  = (bird1DrawingRequest || bird2DrawingRequest);

//
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			tmpRGB	<= 8'b0;
	end
	else begin
		if (bird1DrawingRequest == 1'b1 )   
			tmpRGB <= bird1RGB;  //first priority 

		else if (bird2DrawingRequest == 1'b1 )   
			tmpRGB <= bird2RGB;  //second priority 
		
		else
			tmpRGB <= 8'hff ; // last priority 
		end ; 
	end

endmodule


