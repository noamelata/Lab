
module sound_machine	(	
					input logic	clk,
					input logic	resetN,
					input logic startOfFrame,
					input logic shot_deploy,
					input logic player_hit,
					input logic bird_hit,
					input logic level_up,
					input logic pickup,
					
					output logic [9:0] freq,
					output logic sound_en				
);

int count;
int duration = 4;

enum logic [4:0] {idle, hit_st_1, hit_st_2, hit_st_3, 
						bird_hit_st_1, bird_hit_st_2, bird_hit_st_3, 
						shot_st_1, shot_st_2, shot_st_3, 
						lvl_st_1, lvl_st_2, lvl_st_3,
						pickup_st_1, pickup_st_2, pickup_st_3} state, next_state;

 
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		state <= idle;
		count <= 0;
	end
	else begin
		if (startOfFrame) begin
			count <= (count > 0) ? count - 1 : 0;
		end
		if (count == 0) begin
			state <= next_state;
			count <= (state == idle) ? 0 : duration;
		end
		else
			state <= state;
	end
end

always_comb 
begin
	sound_en = 1'b1;

	case(state)
	idle: begin
		sound_en = 1'b0;
		freq = 10'h0;
	end
	
	hit_st_1:
		freq = 10'h250;
		
	hit_st_2:
		freq = 10'h2EA;
		
	hit_st_3:
		freq = 10'h0;
	
	pickup_st_1:
		freq = 10'h1F2;
		
	pickup_st_2:
		freq = 10'h250;
		
	pickup_st_3:
		freq = 10'h1BB;
		
	bird_hit_st_1:
		freq = 10'h20F;
		
	bird_hit_st_2:
		freq = 10'h1D6;
		
	bird_hit_st_3:
		freq = 10'h18b;
		
	lvl_st_1:
		freq = 10'h0;
		
	lvl_st_2:
		freq = 10'h0;
		
	lvl_st_3:
		freq = 10'h0;
		
	shot_st_1:
		freq = 10'h2EA;
		
	shot_st_2:
		freq = 10'h1F2;
		
	shot_st_3:
		freq = 10'h0;
	
	
	endcase

end

always_comb 
begin
	next_state = idle;
	
	if (player_hit)
		next_state = hit_st_1;
	else if (pickup)
		next_state = pickup_st_1;
	else if (bird_hit)
		next_state = bird_hit_st_1;
	else if (level_up)
		next_state = lvl_st_1;
	else if (shot_deploy)
		next_state = shot_st_1;
	else begin
		case(state)
		
		hit_st_1:
			next_state = hit_st_2;
			
		hit_st_2:
			next_state = hit_st_3;
			
		pickup_st_1:
			next_state = pickup_st_2;
			
		pickup_st_2:
			next_state = pickup_st_3;
			
		bird_hit_st_1:
			next_state = bird_hit_st_2;
			
		bird_hit_st_2:
			next_state = bird_hit_st_3;
			
		lvl_st_1:
			next_state = lvl_st_2;
			
		lvl_st_2:
			next_state = lvl_st_3;
			
		shot_st_1:
			next_state = shot_st_2;
			
		shot_st_2:
			next_state = shot_st_3;
		
		endcase
	end

end

endmodule
