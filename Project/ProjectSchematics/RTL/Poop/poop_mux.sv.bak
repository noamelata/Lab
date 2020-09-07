

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

logic [7:0] [3:0] order_to_poop_num ;
logic [3:0] temp;

always_comb
begin
	
	temp = 4'h00;
	for (int i=0; i<8; i++) begin
		order_to_poop_num[i] = i;
	end
	
	for (int i = 8; i > 0; i--) begin
		for (int j = 1; j < i; j++) begin
			if (poopCoordinates[j-1][1] < poopCoordinates[j][1]) begin
				temp = order_to_poop_num[j-1];
				order_to_poop_num[j-1] = order_to_poop_num[j];
				order_to_poop_num[j] = temp;
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
		if (poopsBusRequest[order_to_poop_num[0]] == 1'b1 )   
			tmpRGB <= poopsBusRGB[order_to_poop_num[0]];  //first priority 

		else if (poopsBusRequest[order_to_poop_num[1]] == 1'b1 )   
			tmpRGB <= poopsBusRGB[order_to_poop_num[1]];  //second priority 
			
		else if (poopsBusRequest[order_to_poop_num[2]] == 1'b1 )   
			tmpRGB <= poopsBusRGB[order_to_poop_num[2]];  //third priority 
		
		else if (poopsBusRequest[order_to_poop_num[3]] == 1'b1 )   
			tmpRGB <= poopsBusRGB[order_to_poop_num[3]];  //forth priority 
			
		else if (poopsBusRequest[order_to_poop_num[4]] == 1'b1 )   
			tmpRGB <= poopsBusRGB[order_to_poop_num[4]];  //fifth priority 
		
		else if (poopsBusRequest[order_to_poop_num[5]] == 1'b1 )   
			tmpRGB <= poopsBusRGB[order_to_poop_num[5]];  //sixth priority 
			
		else if (poopsBusRequest[order_to_poop_num[6]] == 1'b1 )   
			tmpRGB <= poopsBusRGB[order_to_poop_num[6]];  //seventh priority 
		
		else if (poopsBusRequest[order_to_poop_num[7]] == 1'b1 )   
			tmpRGB <= poopsBusRGB[order_to_poop_num[7]];  //eighth priority  
		
			
		else
			tmpRGB <= 8'hff ; // last priority 
		end ; 
	end

endmodule


