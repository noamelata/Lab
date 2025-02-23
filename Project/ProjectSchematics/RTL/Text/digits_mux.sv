

module	digits_mux	(	 	
	input		logic	clk,
	input		logic	resetN,
	input		logic	[1:0] digitsBusRequest,
	input		logic	[1:0] [7:0] digitsBusRGB, 
	
	output	logic digitsDrawingRequest,
	output	logic	[7:0] digitsRGB 
					
);

logic [7:0] tmpRGB;



assign digitsRGB	  = tmpRGB; //--  extend LSB to create 10 bits per color  
assign digitsDrawingRequest  = (digitsBusRequest[0] || digitsBusRequest [1]); //should anyone be displayed



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
		
		else
			tmpRGB <= 8'hff ; // last priority 
		end ; 
	end

endmodule
