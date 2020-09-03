

module	heart_mux	(	
					input logic	clk,
					input	logic	resetN,
					input	logic	[2:0] heartsBusRequest,
					input	logic	[2:0] [7:0] heartsBusRGB, 
					
					output logic heartsDrawingRequest,
					output logic [7:0] heartsRGB
					
);

logic [7:0] tmpRGB;


assign heartsRGB = tmpRGB; //--  extend LSB to create 10 bits per color  
assign heartsDrawingRequest  = (heartsBusRequest[0] || heartsBusRequest[1]
						|| heartsBusRequest[2]);


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			tmpRGB	<= 8'b0;
	end
	else begin
		if (heartsBusRequest[0] == 1'b1 )   
			tmpRGB <= heartsBusRGB[0];  //first priority 

		else if (heartsBusRequest[1] == 1'b1 )   
			tmpRGB <= heartsBusRGB[1];  //second priority 
			
		else if (heartsBusRequest[2] == 1'b1 )  
			tmpRGB <= heartsBusRGB[2];  //third priority 
				
		else
			tmpRGB <= 8'hFF ; // last priority 
		end ; 
	end

endmodule


