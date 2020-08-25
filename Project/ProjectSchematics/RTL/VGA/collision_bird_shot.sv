
module	collision_bird_shot	(	
					input		logic	clk,
					input		logic	resetN,
					
					input		logic	[1:0] birdsDrawingRequest,
					input		logic	[7:0] shotsDrawingRequest,									
					output	logic [1:0] collision_birds,
					output	logic [7:0] collision_shots,					
);

logic shot = (shotsDrawingRequest[0] || shotsDrawingRequest[1] 
						|| shotsDrawingRequest[2] || shotsDrawingRequest[3]
						|| shotsDrawingRequest[4] || shotsDrawingRequest[5]
						|| shotsDrawingRequest[6] || shotsDrawingRequest[7]);
						
logic bird = (birdsDrawingRequest[0] || birdsDrawingRequest[1])
			
assign collision_birds[0] = (birdsDrawingRequest[0] && shot);
						
assign collision_birds[0] = (birdsDrawingRequest[1] && shot);

for (int i = 0 ; i < 8 ; i++) begin
	assign collision_shots[i] = (bird && shotsDrawingRequest[i]);
end

			
endmodule