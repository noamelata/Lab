

module	digits_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,

					input		logic	[3:0] digitsBusRequest,
					input		logic	[3:0] [7:0] digitsBusRGB, 
					
					output	logic digitsDrawingRequest,
					output	logic	[7:0] digitsRGB 
					
);

logic [7:0] tmpRGB;



assign digitsRGB	  = tmpRGB; //--  extend LSB to create 10 bits per color  
assign digitsDrawingRequest  = (digitsBusRequest[0] || digitsBusRequest [1]
						|| digitsBusRequest[2] || digitsBusRequest[3]
						|| digitsBusRequest[4] || digitsBusRequest[5]
						|| digitsBusRequest[6] || digitsBusRequest[7]);



always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			tmpRGB	<= 8'b0;
	end
	else begin
		if (digitsBusRequest[0] == 1'b1 )   
			tmpRGB <= digitsBusRGB[0];  //first priority 

		else if (digitsBusRequest[1] == 1'b1 )   
			tmpRGB <= digitsBusRGB[1];  //second priority 
			
		else if (digitsBusRequest[2] == 1'b1 )   
			tmpRGB <= digitsBusRGB[2];  //third priority 
		
		else if (digitsBusRequest[3] == 1'b1 )   
			tmpRGB <= digitsBusRGB[3];  //forth priority 
		
		else
			tmpRGB <= 8'hff ; // last priority 
		end ; 
	end

endmodule
