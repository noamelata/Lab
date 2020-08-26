
module	collision_player_tree	(	
					input	logic	clk,
					input	logic	resetN,
					input logic startOfFrame,
					input	logic	playerDrawingRequest,	
					input	logic	[7:0] treesDrawingRequest,			
					output logic SingleHitPulse			
);

logic flag; // a semaphore to set the output only once per frame / regardless of the number of collisions 
logic collision;
			
assign collision = (playerDrawingRequest && 
						(treesDrawingRequest[0] || treesDrawingRequest[1] 
						|| treesDrawingRequest[2] || treesDrawingRequest[3]
						|| treesDrawingRequest[4] || treesDrawingRequest[5]
						|| treesDrawingRequest[6] || treesDrawingRequest[7]));

						
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag	<= 1'b0;
		SingleHitPulse <= 1'b0 ; 
	end 
	else begin 
			SingleHitPulse <= SingleHitPulse ; // default 
			if(startOfFrame) 
				flag = 1'b0 ; // reset for next time 
				SingleHitPulse <= 1'b0 ; 
			if ( collision  && (flag == 1'b0)) begin 
				flag	<= 1'b1; // to enter only once 
				SingleHitPulse <= 1'b1 ; 
			end
	end 
end
			
endmodule
