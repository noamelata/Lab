

module	trees_mux	(	
//		--------	Clock Input	 	
					input logic	clk,
					input	logic	resetN,
					
					input	logic	[7:0] [1:0] [10:0] treesCoordinates,
					
					input	logic	[7:0] treesBusRequest,
					input	logic	[7:0] [7:0] treesBusRGB, 
					
					output	logic treesDrawingRequest,
					output	logic	[7:0] treesRGB
					
);

logic [7:0] tmpRGB;


assign treesRGB	  = tmpRGB; //--  extend LSB to create 10 bits per color  
assign treesDrawingRequest  = (treesBusRequest[0] || treesBusRequest [1]
						|| treesBusRequest[2] || treesBusRequest[3]
						|| treesBusRequest[4] || treesBusRequest[5]
						|| treesBusRequest[6] || treesBusRequest[7]);

logic [3:0] [3:0] order_to_tree_num ;
logic [3:0] temp;

always_comb
begin

	for (int i=0; i<8; i++) begin
		order_to_tree_num[i] = i;
	end
	
	for (i=0; i<8; i++) begin
		for (int j=i+1; j<8; j++) begin
			if (treesCoordinates[i][1] < treesCoordinates[j][1]) begin
				temp = order_to_tree_num[i];
				order_to_tree_num[i] = order_to_tree_num[j];
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
			
		else
			tmpRGB <= 8'hff ; // last priority 
		end ; 
	end

endmodule


