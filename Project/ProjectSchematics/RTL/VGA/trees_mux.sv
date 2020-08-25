

module	trees_mux	(	
//		--------	Clock Input	 	
					input logic	clk,
					input	logic	resetN,

					input logic	tree1DrawingRequest,
					input logic	[7:0] tree1RGB, 
					
					input logic	tree2DrawingRequest,
					input logic	[7:0] tree2RGB, 
					
					input logic	tree3DrawingRequest,
					input logic	[7:0] tree3RGB, 
					
					input logic	tree4DrawingRequest,
					input logic	[7:0] tree4RGB, 
					
					input logic	tree5DrawingRequest,
					input logic	[7:0] tree5RGB, 
					
					input		logic	tree6DrawingRequest,
					input		logic	[7:0] tree6RGB, 
					
					input		logic	tree7DrawingRequest,
					input		logic	[7:0] tree7RGB, 
					
					input		logic	tree8DrawingRequest,
					input		logic	[7:0] tree8RGB, 
					
					output	logic treesDrawingRequest,
					output	logic	[7:0] treesRGB, 
					
);

logic [7:0] tmpRGB;



assign treesRGB	  = tmpRGB; //--  extend LSB to create 10 bits per color  
assign treesDrawingRequest  = (trees1DrawingRequest || trees2DrawingRequest 
						|| trees3DrawingRequest || trees4DrawingRequest
						|| trees5DrawingRequest || trees6DrawingRequest
						|| trees7DrawingRequest || trees8DrawingRequest);


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			tmpRGB	<= 8'b0;
	end
	else begin
		if (tree1DrawingRequest == 1'b1 )   
			tmpRGB <= tree1RGB;  //first priority 

		else if (tree2DrawingRequest == 1'b1 )   
			tmpRGB <= tree2RGB;  //second priority 
			
		else if (tree3DrawingRequest == 1'b1 )   
			tmpRGB <= tree3RGB;  //third priority 
		
		else if (tree4DrawingRequest == 1'b1 )   
			tmpRGB <= tree4RGB;  //forth priority 
			
		else if (tree5DrawingRequest == 1'b1 )   
			tmpRGB <= tree5RGB;  //fifth priority 
		
		else if (tree6DrawingRequest == 1'b1 )   
			tmpRGB <= tree6RGB;  //sixth priority 
			
		else if (tree7DrawingRequest == 1'b1 )   
			tmpRGB <= tree7RGB;  //seventh priority 
		
		else if (tree8DrawingRequest == 1'b1 )   
			tmpRGB <= tree8RGB;  //eighth priority 
		
		else
			tmpRGB <= 8'hff ; // last priority 
		end ; 
	end

endmodule


