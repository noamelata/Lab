

module	trees_mux	(	
//		--------	Clock Input	 	
					input logic	clk,
					input	logic	resetN,
					
					input	logic	signed [15:0] [1:0] [10:0] treesCoordinates,
					
					input	logic	[15:0] treesBusRequest,
					input	logic	[15:0] [7:0] treesBusRGB, 
					
					output	logic treesDrawingRequest,
					output	logic	[7:0] treesRGB
					
);

logic [7:0] tmpRGB;


assign treesRGB	  = tmpRGB; //--  extend LSB to create 10 bits per color  
assign treesDrawingRequest  = (treesBusRequest[0] || treesBusRequest [1]
						|| treesBusRequest[2] || treesBusRequest[3]
						|| treesBusRequest[4] || treesBusRequest[5]
						|| treesBusRequest[6] || treesBusRequest[7]
						|| treesBusRequest[8] || treesBusRequest [9]
						|| treesBusRequest[10] || treesBusRequest[11]
						|| treesBusRequest[12] || treesBusRequest[13]
						|| treesBusRequest[14] || treesBusRequest[15]);

logic [15:0] [4:0] order_to_tree_num ;
logic [4:0] temp;

always_comb
begin
	
	temp = 5'h00;
	for (int i=0; i<16; i++) begin
		order_to_tree_num[i] = i;
	end
	
	for (int i = 16; i > 0; i--) begin
		for (int j = 1; j < i; j++) begin
			if (treesCoordinates[j-1][1] < treesCoordinates[j][1]) begin
				temp = order_to_tree_num[j-1];
				order_to_tree_num[j-1] = order_to_tree_num[j];
				order_to_tree_num[j] = temp;
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
		if (treesBusRequest[order_to_tree_num[0]] == 1'b1 )   
			tmpRGB <= treesBusRGB[order_to_tree_num[0]];  //first priority 

		else if (treesBusRequest[order_to_tree_num[1]] == 1'b1 )   
			tmpRGB <= treesBusRGB[order_to_tree_num[1]];  //second priority 
			
		else if (treesBusRequest[order_to_tree_num[2]] == 1'b1 )   
			tmpRGB <= treesBusRGB[order_to_tree_num[2]];  //third priority 
		
		else if (treesBusRequest[order_to_tree_num[3]] == 1'b1 )   
			tmpRGB <= treesBusRGB[order_to_tree_num[3]];  //forth priority 
			
		else if (treesBusRequest[order_to_tree_num[4]] == 1'b1 )   
			tmpRGB <= treesBusRGB[order_to_tree_num[4]];  //fifth priority 
		
		else if (treesBusRequest[order_to_tree_num[5]] == 1'b1 )   
			tmpRGB <= treesBusRGB[order_to_tree_num[5]];  //sixth priority 
			
		else if (treesBusRequest[order_to_tree_num[6]] == 1'b1 )   
			tmpRGB <= treesBusRGB[order_to_tree_num[6]];  //seventh priority 
		
		else if (treesBusRequest[order_to_tree_num[7]] == 1'b1 )   
			tmpRGB <= treesBusRGB[order_to_tree_num[7]];  //eighth priority 
			
		else if (treesBusRequest[order_to_tree_num[8]] == 1'b1 )   
			tmpRGB <= treesBusRGB[order_to_tree_num[8]];  

		else if (treesBusRequest[order_to_tree_num[9]] == 1'b1 )   
			tmpRGB <= treesBusRGB[order_to_tree_num[9]];  
			
		else if (treesBusRequest[order_to_tree_num[10]] == 1'b1 )   
			tmpRGB <= treesBusRGB[order_to_tree_num[10]];  
		
		else if (treesBusRequest[order_to_tree_num[11]] == 1'b1 )   
			tmpRGB <= treesBusRGB[order_to_tree_num[11]]; 
			
		else if (treesBusRequest[order_to_tree_num[12]] == 1'b1 )   
			tmpRGB <= treesBusRGB[order_to_tree_num[12]]; 
		
		else if (treesBusRequest[order_to_tree_num[13]] == 1'b1 )   
			tmpRGB <= treesBusRGB[order_to_tree_num[13]]; 
			
		else if (treesBusRequest[order_to_tree_num[14]] == 1'b1 )   
			tmpRGB <= treesBusRGB[order_to_tree_num[14]];  
		
		else if (treesBusRequest[order_to_tree_num[15]] == 1'b1 )   
			tmpRGB <= treesBusRGB[order_to_tree_num[15]];  
		
			
		else
			tmpRGB <= 8'hff ; // last priority 
		end ; 
	end

endmodule


