

module	poop_mux	(	
					input logic	clk,
					input	logic	resetN,
					
					input	logic signed [7:0] [1:0] [10:0] poopCoordinates,
					
					input	logic	[7:0] poopsBusRequest,
					input	logic	[7:0] [7:0] poopsBusRGB, 
					
					output	logic poopsDrawingRequest,
					output	logic	[7:0] poopsRGB
					
);

logic [7:0] tmpRGB;


assign poopsRGB	  = tmpRGB; //--  extend LSB to create 10 bits per color  
assign poopsDrawingRequest  = (poopsBusRequest[0] || poopsBusRequest [1]
						|| poopsBusRequest[2] || poopsBusRequest[3]
						|| poopsBusRequest[4] || poopsBusRequest[5]
						|| poopsBusRequest[6] || poopsBusRequest[7]);



always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			tmpRGB	<= 8'b0;
	end
	else begin
		if (poopsBusRequest[0] == 1'b1 )   
			tmpRGB <= poopsBusRGB[0];  //first priority 

		else if (poopsBusRequest[1] == 1'b1 )   
			tmpRGB <= poopsBusRGB[1];  //second priority 
			
		else if (poopsBusRequest[2] == 1'b1 )   
			tmpRGB <= poopsBusRGB[2];  //third priority 
		
		else if (poopsBusRequest[3] == 1'b1 )   
			tmpRGB <= poopsBusRGB[3];  //forth priority 
			
		else if (poopsBusRequest[4] == 1'b1 )   
			tmpRGB <= poopsBusRGB[4];  //fifth priority 
		
		else if (poopsBusRequest[5] == 1'b1 )   
			tmpRGB <= poopsBusRGB[5];  //sixth priority 
			
		else if (poopsBusRequest[6] == 1'b1 )   
			tmpRGB <= poopsBusRGB[6];  //seventh priority 
		
		else if (poopsBusRequest[7] == 1'b1 )   
			tmpRGB <= poopsBusRGB[7];  //eighth priority  
		
			
		else
			tmpRGB <= 8'hff ; // last priority 
		end ; 
	end

endmodule


