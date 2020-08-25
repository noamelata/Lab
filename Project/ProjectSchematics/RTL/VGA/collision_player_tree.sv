
module	collision_player_tree	(	
					input		logic	clk,
					input		logic	resetN,
					
					input		logic	playerDrawingRequest,	
					input		logic	tree1DrawingRequest,					
					input		logic	tree2DrawingRequest,					
					input		logic	tree3DrawingRequest,					
					input		logic	tree4DrawingRequest,					
					input		logic	tree5DrawingRequest,					
					input		logic	tree6DrawingRequest,					
					input		logic	tree7DrawingRequest,					
					input		logic	tree8DrawingRequest,					
					output	logic collision,
					
);
			
assign collision = (playerDrawingRequest && 
						(trees1DrawingRequest || trees2DrawingRequest 
						|| trees3DrawingRequest || trees4DrawingRequest
						|| trees5DrawingRequest || trees6DrawingRequest
						|| trees7DrawingRequest || trees8DrawingRequest));
			
endmodule