

module	shit_mux	(	
					input logic	clk,
					input	logic	resetN,
					
					input	logic signed [7:0] [1:0] [10:0] shitCoordinates,
					
					input	logic	[7:0] shitsBusRequest,
					input	logic	[7:0] [7:0] shitsBusRGB, 
					
					output	logic shitsDrawingRequest,
					output	logic	[7:0] shitsRGB
					
);

logic [7:0] tmpRGB;


assign shitsRGB	  = tmpRGB; //--  extend LSB to create 10 bits per color  
assign shitsDrawingRequest  = (shitsBusRequest[0] || shitsBusRequest [1]
						|| shitsBusRequest[2] || shitsBusRequest[3]
						|| shitsBusRequest[4] || shitsBusRequest[5]
						|| shitsBusRequest[6] || shitsBusRequest[7]);

logic [7:0] [3:0] order_to_shit_num ;
logic [3:0] temp;

always_comb
begin
	
	temp = 4'h00;
	for (int i=0; i<8; i++) begin
		order_to_shit_num[i] = i;
	end
	
	for (int i = 8; i > 0; i--) begin
		for (int j = 1; j < i; j++) begin
			if (shitCoordinates[j-1][1] < shitCoordinates[j][1]) begin
				temp = order_to_shit_num[j-1];
				order_to_shit_num[j-1] = order_to_shit_num[j];
				order_to_shit_num[j] = temp;
			end
		end
	end
end


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			tmpRGB	<= 8'b0;
	end
	else begin
		if (shitsBusRequest[order_to_shit_num[0]] == 1'b1 )   
			tmpRGB <= shitsBusRGB[order_to_shit_num[0]];  //first priority 

		else if (shitsBusRequest[order_to_shit_num[1]] == 1'b1 )   
			tmpRGB <= shitsBusRGB[order_to_shit_num[1]];  //second priority 
			
		else if (shitsBusRequest[order_to_shit_num[2]] == 1'b1 )   
			tmpRGB <= shitsBusRGB[order_to_shit_num[2]];  //third priority 
		
		else if (shitsBusRequest[order_to_shit_num[3]] == 1'b1 )   
			tmpRGB <= shitsBusRGB[order_to_shit_num[3]];  //forth priority 
			
		else if (shitsBusRequest[order_to_shit_num[4]] == 1'b1 )   
			tmpRGB <= shitsBusRGB[order_to_shit_num[4]];  //fifth priority 
		
		else if (shitsBusRequest[order_to_shit_num[5]] == 1'b1 )   
			tmpRGB <= shitsBusRGB[order_to_shit_num[5]];  //sixth priority 
			
		else if (shitsBusRequest[order_to_shit_num[6]] == 1'b1 )   
			tmpRGB <= shitsBusRGB[order_to_shit_num[6]];  //seventh priority 
		
		else if (shitsBusRequest[order_to_shit_num[7]] == 1'b1 )   
			tmpRGB <= shitsBusRGB[order_to_shit_num[7]];  //eighth priority  
		
			
		else
			tmpRGB <= 8'hff ; // last priority 
		end ; 
	end

endmodule


