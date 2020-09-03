

module	bar_mux	(	
					input logic	clk,
					input	logic	resetN,
					input logic timerDrawingRequest,
					input logic [7:0] timerRGB,	
					input logic backgroundRequest,
					input logic [7:0] backgroundRGB,
					input logic heartsDrawingRequest,
					input logic [7:0] heartsRGB,
					
					output	logic barDrawingRequest,
					output	logic	[7:0] barRGB
					
);

logic [7:0] tmpRGB;


assign barRGB = tmpRGB; //--  extend LSB to create 10 bits per color  
assign barDrawingRequest = (timerDrawingRequest || backgroundRequest || heartsDrawingRequest);


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

		else if (backgroundRequest == 1'b1 )   
			tmpRGB <= backgroundRGB;  //third priority
			
		else
			tmpRGB <= 8'hFF ; // last priority 
		end  
	end

endmodule


