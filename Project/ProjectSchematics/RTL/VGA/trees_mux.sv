

module	trees_mux	(	
//		--------	Clock Input	 	
					input logic	clk,
					input	logic	resetN,
					
					input	logic	signed [NUMBER_OF_TREES - 1:0] [1:0] [10:0] treesCoordinates,
					
					input	logic	[NUMBER_OF_TREES - 1:0] treesBusRequest,
					input	logic	[NUMBER_OF_TREES - 1:0] [7:0] treesBusRGB, 
					input	logic	[NUMBER_OF_TREES - 1:0] jump,
					input logic [NUMBER_OF_TREES - 1:0] deploy_tree,
					input	logic	[NUMBER_OF_TREES - 1:0] isActive, 	
					
					
					output	logic treesDrawingRequest,
					output	logic	[7:0] treesRGB
					
);

logic [7:0] tmpRGB;
parameter NUMBER_OF_TREES = 16;

assign treesRGB	  = tmpRGB; //--  extend LSB to create 10 bits per color  
assign treesDrawingRequest  = (treesBusRequest[0] || treesBusRequest [1]
						|| treesBusRequest[2] || treesBusRequest[3]
						|| treesBusRequest[4] || treesBusRequest[5]
						|| treesBusRequest[6] || treesBusRequest[7]
						|| treesBusRequest[8] || treesBusRequest [9]
						|| treesBusRequest[10] || treesBusRequest[11]
						|| treesBusRequest[12] || treesBusRequest[13]
						|| treesBusRequest[14] || treesBusRequest[15]);

logic [NUMBER_OF_TREES - 1:0] [3:0] order_to_tree_num ;



always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
								
		order_to_tree_num = {4'h0, 4'h1, 4'h2, 4'h3,
									4'h4, 4'h5, 4'h6, 4'h7,
									4'h8, 4'h9, 4'hA, 4'hB,
									4'hC, 4'hD, 4'hE, 4'hF};
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
			tmpRGB <= 8'hFF ; // last priority 
		end ; 
	end

endmodule


