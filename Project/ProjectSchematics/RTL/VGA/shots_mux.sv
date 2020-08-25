

module	shots_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN

					input		logic	shot1DrawingRequest,
					input		logic	[7:0] shot1RGB, 
					
					input		logic	shot2DrawingRequest,
					input		logic	[7:0] shot2RGB, 
					
					input		logic	shot3DrawingRequest,
					input		logic	[7:0] shot3RGB, 
					
					input		logic	shot4DrawingRequest,
					input		logic	[7:0] shot4RGB, 
					
					input		logic	shot5DrawingRequest,
					input		logic	[7:0] shot5RGB, 
					
					input		logic	shot6DrawingRequest,
					input		logic	[7:0] shot6RGB, 
					
					input		logic	shot7DrawingRequest,
					input		logic	[7:0] shot7RGB, 
					
					input		logic	shot8DrawingRequest,
					input		logic	[7:0] shot8RGB, 
					
					output	logic shotsDrawingRequest
					output	logic	[7:0] shotsRGB, 
					
);

logic [7:0] tmpRGB;



assign shotsRGB	  = tmpRGB; //--  extend LSB to create 10 bits per color  
assign shotsDrawingRequest  = (shots1DrawingRequest || shots2DrawingRequest 
						|| shots3DrawingRequest || shots4DrawingRequest
						|| shots5DrawingRequest || shots6DrawingRequest
						|| shots7DrawingRequest || shots8DrawingRequest)


//
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			tmpRGB	<= 8'b0;
	end
	else begin
		if (shot1DrawingRequest == 1'b1 )   
			tmpRGB <= shot1RGB;  //first priority 

		else if (shot2DrawingRequest == 1'b1 )   
			tmpRGB <= shot2RGB;  //second priority 
			
		else if (shot3DrawingRequest == 1'b1 )   
			tmpRGB <= shot3RGB;  //third priority 
		
		else if (shot4DrawingRequest == 1'b1 )   
			tmpRGB <= shot4RGB;  //forth priority 
			
		else if (shot5DrawingRequest == 1'b1 )   
			tmpRGB <= shot5RGB;  //fifth priority 
		
		else if (shot6DrawingRequest == 1'b1 )   
			tmpRGB <= shot6RGB;  //sixth priority 
			
		else if (shot7DrawingRequest == 1'b1 )   
			tmpRGB <= shot7RGB;  //seventh priority 
		
		else if (shot8DrawingRequest == 1'b1 )   
			tmpRGB <= shot8RGB;  //eighth priority 
		
		else
			tmpRGB <= 8'hff ; // last priority 
		end ; 
	end

endmodule


