
module collision_bird_shot (	
					input	logic	clk,
					input	logic	resetN,
					input logic startOfFrame,
					input	logic	[3:0] birdsDrawingRequest,
					input	logic	[7:0] shotsDrawingRequest,									
					output logic [3:0] SingleHitPulse_birds,
					output logic [7:0] SingleHitPulse_shots				
					);

logic [11:0] flag ; // a semaphore to set the output only once per frame / regardless of the number of collisions 

parameter int NUM_OF_SHOTS = 8;
parameter int NUM_OF_BIRDS = 4;
 
logic shot;
assign shot = (shotsDrawingRequest[0] || shotsDrawingRequest[1] 
						|| shotsDrawingRequest[2] || shotsDrawingRequest[3]
						|| shotsDrawingRequest[4] || shotsDrawingRequest[5]
						|| shotsDrawingRequest[6] || shotsDrawingRequest[7]);
						
logic bird;
assign bird = (birdsDrawingRequest[0] || birdsDrawingRequest[1]
					|| birdsDrawingRequest[2] || birdsDrawingRequest[3]);
logic [NUM_OF_BIRDS - 1:0] collision_birds;
logic [NUM_OF_SHOTS - 1:0] collision_shots;

always_comb begin
	for (int i = 0 ; i < NUM_OF_BIRDS ; i++) begin
		collision_birds[i] = (shot && birdsDrawingRequest[i]);
	end
end


always_comb begin
	for (int i = 0 ; i < NUM_OF_SHOTS ; i++) begin
		collision_shots[i] = (bird && shotsDrawingRequest[i]);
	end
end

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag <= 12'h000;
		SingleHitPulse_birds <= 4'h0;
		SingleHitPulse_shots <= 8'h00; 
	end 
	else begin 
		flag <= flag;
		SingleHitPulse_birds <= SingleHitPulse_birds;
		SingleHitPulse_shots <= SingleHitPulse_shots;  // default 
		if (startOfFrame) begin
			flag <= 12'h000; // reset for next time 
			SingleHitPulse_birds <= 4'h0;
			SingleHitPulse_shots <= 8'h00;
		end
		for (int i = 0 ; i < NUM_OF_SHOTS ; i++) begin
			if (collision_shots[i]  && (flag[i] == 1'b0)) begin
				flag[i] <= 1'b1;
				SingleHitPulse_shots[i] <= 1'b1;
			end
		end
		for (int i = 0 ; i < NUM_OF_BIRDS ; i++) begin
			if (collision_birds[i]  && (flag[i + NUM_OF_SHOTS] == 1'b0)) begin
				flag[i + NUM_OF_SHOTS] <= 1'b1;
				SingleHitPulse_birds[i] <= 1'b1;
			end
		end
	end 
end

			
endmodule
