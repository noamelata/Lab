

module	trees_mux	(	
//		--------	Clock Input	 	
					input logic	clk,
					input	logic	resetN,

					
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

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			tmpRGB	<= 8'b0;
	end
	else begin
		if (treesBusRequest[0] == 1'b1 )   
			tmpRGB <= treesBusRGB[0];  //first priority 

		else if (treesBusRequest[1] == 1'b1 )   
			tmpRGB <= treesBusRGB[1];  //second priority 
			
		else if (treesBusRequest[2] == 1'b1 )   
			tmpRGB <= treesBusRGB[2];  //third priority 
		
		else if (treesBusRequest[3] == 1'b1 )   
			tmpRGB <= treesBusRGB[3];  //forth priority 
			
		else if (treesBusRequest[4] == 1'b1 )   
			tmpRGB <= treesBusRGB[4];  //fifth priority 
		
		else if (treesBusRequest[5] == 1'b1 )   
			tmpRGB <= treesBusRGB[5];  //sixth priority 
			
		else if (treesBusRequest[6] == 1'b1 )   
			tmpRGB <= treesBusRGB[6];  //seventh priority 
		
		else if (treesBusRequest[7] == 1'b1 )   
			tmpRGB <= treesBusRGB[7];  //eighth priority 
			
		else
			tmpRGB <= 8'hff ; // last priority 
		end ; 
	end

endmodule


