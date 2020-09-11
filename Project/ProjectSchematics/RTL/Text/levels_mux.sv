

module	levels_mux	(	
//		--------	Clock Input	 	
	input		logic	clk,
	input		logic	resetN,

	input		logic	[2:0] levelsBusRequest,
	input		logic	[2:0] [7:0] levelsBusRGB, 
	
	output	logic levelsDrawingRequest,
	output	logic	[7:0] levelsRGB 
					
);

logic [7:0] tmpRGB;

assign levelsRGB	  = tmpRGB; //--  extend LSB to create 10 bits per color  
assign levelsDrawingRequest  = (levelsBusRequest[0] || levelsBusRequest [1] //should anyone be displayed
											|| levelsBusRequest[2]);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			tmpRGB	<= 8'b0;
	end
	else begin
		if (levelsBusRequest[0] == 1'b1 )   
			tmpRGB <= levelsBusRGB[0];  //first priority 

		else if (levelsBusRequest[1] == 1'b1 )   
			tmpRGB <= levelsBusRGB[1];  //second priority 
			
		else if (levelsBusRequest[2] == 1'b1 )   
			tmpRGB <= levelsBusRGB[2];  
		
		else
			tmpRGB <= 8'hff ; // last priority 
		end ; 
	end

endmodule
