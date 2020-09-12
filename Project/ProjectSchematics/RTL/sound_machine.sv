
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

//local parameters
int count;
int duration = NORMAL; 

//duration lengths
localparam LONG = 8;
localparam NORMAL = 4;
localparam SHORT = 2;
localparam TINY = 1;

//sound tones
localparam logic [9:0] DO = 10'h2EA;
localparam logic [9:0] MI = 10'h250;
localparam logic [9:0] FA_D = 10'h20F;
localparam logic [9:0] SOL = 10'h1F2;
localparam logic [9:0] SOL_D = 10'h1D6;
localparam logic [9:0] LA = 10'h1BB;
localparam logic [9:0] SI = 10'h18b;
localparam logic [9:0] SILENCE = 10'h0;

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
		freq = SILENCE;
	end
	
	hit_st_1:
		freq = MI;
		
	hit_st_2:
		freq = DO;
		
	hit_st_3:
		freq = SILENCE;
	
	pickup_st_1:
		freq = SOL;
		
	pickup_st_2:
		freq = MI;
		
	pickup_st_3:
		freq = LA;
		
	bird_hit_st_1:
		freq = FA_D;
		
	bird_hit_st_2:
		freq = SOL_D;
		
	bird_hit_st_3:
		freq = SI;
		
	lvl_st_1:
		freq = SILENCE;
		
	lvl_st_2:
		freq = SILENCE;
		
	lvl_st_3:
		freq = SILENCE;
		
	shot_st_1:
		freq = SOL;
		
	shot_st_2:
		freq = MI;
		
	shot_st_3:
		freq = DO;
	
	
	endcase

end

always_comb 
begin
	next_state = idle;
	duration = NORMAL;
	
	if (player_hit)
		next_state = hit_st_1;
	else if (pickup) begin
		next_state = pickup_st_1;
		duration = LONG;
	end
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
			
			
		pickup_st_1: begin
			next_state = pickup_st_2;
			duration = LONG;
		end
			
		pickup_st_2: begin
			next_state = pickup_st_3;
			duration = LONG;
		end	
			
		bird_hit_st_1:
			next_state = bird_hit_st_2;
			
		bird_hit_st_2:
			next_state = bird_hit_st_3;
			
		lvl_st_1:
			next_state = lvl_st_2;
			
		lvl_st_2:
			next_state = lvl_st_3;
			
		shot_st_1: begin
			next_state = shot_st_2;
			duration = SHORT;
		end
			
		shot_st_2: begin
			next_state = shot_st_3;
			duration = TINY;
		end
		
		default:
			next_state = next_state;
		
		endcase
	end

end

endmodule
