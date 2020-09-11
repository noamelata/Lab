

module	trees_mux	(	
//		--------	Clock Input	 	
	input logic	clk,
	input	logic	resetN,	
	input	logic	[NUMBER_OF_TREES - 1:0] treesBusRequest,
	input	logic	[NUMBER_OF_TREES - 1:0] [7:0] treesBusRGB, 	
		
	output	logic treesDrawingRequest,
	output	logic	[7:0] treesRGB				
);

logic [7:0] tmpRGB;

parameter NUMBER_OF_TREES = 16;

assign treesRGB = tmpRGB; //--  extend LSB to create 10 bits per color  
assign treesDrawingRequest  = (treesBusRequest[0] || treesBusRequest [1] //should anyone be displayed
						|| treesBusRequest[2] || treesBusRequest[3]
						|| treesBusRequest[4] || treesBusRequest[5]
						|| treesBusRequest[6] || treesBusRequest[7]
						|| treesBusRequest[8] || treesBusRequest [9]
						|| treesBusRequest[10] || treesBusRequest[11]
						|| treesBusRequest[12] || treesBusRequest[13]
						|| treesBusRequest[14] || treesBusRequest[15]);


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			tmpRGB	<= 8'b0;
	end
	else begin
		if (treesBusRequest[15] == 1'b1 )   
			tmpRGB <= treesBusRGB[15];  //first priority 

		else if (treesBusRequest[14] == 1'b1 )   
			tmpRGB <= treesBusRGB[14];  //second priority 
			
		else if (treesBusRequest[13] == 1'b1 )   
			tmpRGB <= treesBusRGB[13];  //third priority 
		
		else if (treesBusRequest[12] == 1'b1 )   
			tmpRGB <= treesBusRGB[12];  //forth priority 
			
		else if (treesBusRequest[11] == 1'b1 )   
			tmpRGB <= treesBusRGB[11];  //fifth priority 
		
		else if (treesBusRequest[10] == 1'b1 )   
			tmpRGB <= treesBusRGB[10];  //sixth priority 
			
		else if (treesBusRequest[9] == 1'b1 )   
			tmpRGB <= treesBusRGB[9];  //seventh priority 
		
		else if (treesBusRequest[8] == 1'b1 )   
			tmpRGB <= treesBusRGB[8];  //eighth priority 
			
		else if (treesBusRequest[7] == 1'b1 )   
			tmpRGB <= treesBusRGB[7];  

		else if (treesBusRequest[6] == 1'b1 )   
			tmpRGB <= treesBusRGB[6];  
			
		else if (treesBusRequest[5] == 1'b1 )   
			tmpRGB <= treesBusRGB[5];  
		
		else if (treesBusRequest[4] == 1'b1 )   
			tmpRGB <= treesBusRGB[4]; 
			
		else if (treesBusRequest[3] == 1'b1 )   
			tmpRGB <= treesBusRGB[3]; 
		
		else if (treesBusRequest[2] == 1'b1 )   
			tmpRGB <= treesBusRGB[2]; 
			
		else if (treesBusRequest[1] == 1'b1 )   
			tmpRGB <= treesBusRGB[1];  
		
		else if (treesBusRequest[0] == 1'b1 )   
			tmpRGB <= treesBusRGB[0];  
		
			
		else
			tmpRGB <= 8'hFF ; // last priority 
		end ; 
	end

endmodule


