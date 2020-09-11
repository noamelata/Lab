

module	bar_mux	(	
	input logic	clk,
	input	logic	resetN,
	input logic timerDrawingRequest, //game timer
	input logic [7:0] timerRGB, 	
	input logic heartsDrawingRequest, //hearts icons
	input logic [7:0] heartsRGB,
	input logic levelsDrawingRequest, //level counter
	input logic [7:0] levelsRGB,
	input logic gameoverRequest, //game over screen
	input logic [7:0] gameoverRGB,
	
	output	logic barDrawingRequest,
	output	logic	[7:0] barRGB
					
);

logic [7:0] tmpRGB;


assign barRGB = tmpRGB; //--  extend LSB to create 10 bits per color  
assign barDrawingRequest = (timerDrawingRequest //should anyone be displayed
									|| heartsDrawingRequest || levelsDrawingRequest
									|| gameoverRequest);


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			tmpRGB	<= 8'b0;
	end
	else begin
		if (timerDrawingRequest == 1'b1 )   
			tmpRGB <= timerRGB;  //first priority 
	
		else if (heartsDrawingRequest == 1'b1 )   
			tmpRGB <= heartsRGB;  //second priority 
			
		else if (levelsDrawingRequest == 1'b1 )   
			tmpRGB <= levelsRGB;  //third priority

		else if (gameoverRequest == 1'b1 )   
			tmpRGB <= gameoverRGB;  //forth priority
			
		else
			tmpRGB <= 8'hFF ; // last priority 
		end  
	end

endmodule


