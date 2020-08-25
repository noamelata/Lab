
module	collision_bird_shot	(	
					input		logic	clk,
					input		logic	resetN,
					
					input		logic	[1:0] birdsDrawingRequest,
					input		logic	[7:0] shotsDrawingRequest,									
					output	logic [1:0] SingleHitPulse_birds,
					output	logic [7:0] SingleHitPulse_shots,					
);

logic [9:0] flag ; // a semaphore to set the output only once per frame / regardless of the number of collisions 

logic shot = (shotsDrawingRequest[0] || shotsDrawingRequest[1] 
						|| shotsDrawingRequest[2] || shotsDrawingRequest[3]
						|| shotsDrawingRequest[4] || shotsDrawingRequest[5]
						|| shotsDrawingRequest[6] || shotsDrawingRequest[7]);
						
logic bird = (birdsDrawingRequest[0] || birdsDrawingRequest[1]);
			
assign collision_birds[0] = (birdsDrawingRequest[0] && shot);
						
assign collision_birds[1] = (birdsDrawingRequest[1] && shot);

always_comb begin
	for (int i = 0 ; i < 8 ; i++) begin
		collision_shots[i] = (bird && shotsDrawingRequest[i]);
	end
end

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag <= 10'h0;
		SingleHitPulse_birds <= 2'b00;
		SingleHitPulse_shots <= 8'h00; 
	end 
	else begin 
		SingleHitPulse_birds <= 2'b00;
		SingleHitPulse_shots <= 8'h00;  // default 
		if (startOfFrame) 
			flag <= 10'h0;; // reset for next time 
		for (int i = 0 ; i < 8 ; i++) begin
			if (collision_shots[i]  && (flag[i] == 1'b0)) begin
				flag[i] <= 1'b1;
				SingleHitPulse_shots[i] <= 1'b1;
			end
		end
		for (int i = 0 ; i < 2 ; i++) begin
			if (collision_birds[i]  && (flag[i+8] == 1'b0)) begin
				flag[i+8] <= 1'b1;
				SingleHitPulse_birds[i] <= 1'b1;
			end
		end
	end 
end

			
endmodule
