
module	collision_player_poop	(	
	input	logic	clk,
	input	logic	resetN,
	input logic startOfFrame,
	input	logic	playerDrawingRequest,	
	input	logic	[7:0] poopsDrawingRequest,
	
	output logic SingleHitPulse			
);

logic flag; // a semaphore to set the output only once per frame / regardless of the number of collisions 
logic collision;
			
assign collision = (playerDrawingRequest && //should anyone be displayed
						(poopsDrawingRequest[0] || poopsDrawingRequest[1] 
						|| poopsDrawingRequest[2] || poopsDrawingRequest[3]
						|| poopsDrawingRequest[4] || poopsDrawingRequest[5]
						|| poopsDrawingRequest[6] || poopsDrawingRequest[7]));

						
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag	<= 1'b0;
		SingleHitPulse <= 1'b0 ; 
	end 
	else begin 
		flag <= flag;
		SingleHitPulse <= SingleHitPulse ; // default 
		if(startOfFrame) begin
			flag <= 1'b0 ; // reset for next time 
			SingleHitPulse <= 1'b0 ; 
		end
		if ( collision  && (flag == 1'b0)) begin 
			flag	<= 1'b1; // to enter only once 
			SingleHitPulse <= 1'b1 ; 
		end
	end 
end
			
endmodule
