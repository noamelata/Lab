

module	shots_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,

					input		logic	[7:0] shotsBusRequest,
					input		logic	[7:0] [7:0] shotsBusRGB, 
					
					output	logic shotsDrawingRequest,
					output	logic	[7:0] shotsRGB 
					
);

logic [7:0] tmpRGB;



assign shotsRGB	  = tmpRGB; //--  extend LSB to create 10 bits per color  
assign shotsDrawingRequest  = (shotsBusRequest[0] || shotsBusRequest [1]
						|| shotsBusRequest[2] || shotsBusRequest[3]
						|| shotsBusRequest[4] || shotsBusRequest[5]
						|| shotsBusRequest[6] || shotsBusRequest[7]);



always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			tmpRGB	<= 8'b0;
	end
	else begin
		if (shotsBusRequest[0] == 1'b1 )   
			tmpRGB <= shotsBusRGB[0];  //first priority 

		else if (shotsBusRequest[1] == 1'b1 )   
			tmpRGB <= shotsBusRGB[1];  //second priority 
			
		else if (shotsBusRequest[2] == 1'b1 )   
			tmpRGB <= shotsBusRGB[2];  //third priority 
		
		else if (shotsBusRequest[3] == 1'b1 )   
			tmpRGB <= shotsBusRGB[3];  //forth priority 
			
		else if (shotsBusRequest[4] == 1'b1 )   
			tmpRGB <= shotsBusRGB[4];  //fifth priority 
		
		else if (shotsBusRequest[5] == 1'b1 )   
			tmpRGB <= shotsBusRGB[5];  //sixth priority 
			
		else if (shotsBusRequest[6] == 1'b1 )   
			tmpRGB <= shotsBusRGB[6];  //seventh priority 
		
		else if (shotsBusRequest[7] == 1'b1 )   
			tmpRGB <= shotsBusRGB[7];  //eighth priority 
		
		else
			tmpRGB <= 8'hff ; // last priority 
		end ; 
	end

endmodule


