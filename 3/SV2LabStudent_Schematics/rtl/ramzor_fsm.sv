 // Alex Grinshpun Sept 2019
module ramzor_fsm # (	int red_timer = 48, 
						int red_yellow_timer = 18,
						int green_timer = 36,
						int yellow_timer = 18
						
						)
	(
	input logic clk,
	input logic resetN, 
	input logic switchN, 
	input logic endOftime,  // Time is over . Signal received from the timer 
	output logic loadN,     // Signal to load the timer  
	output [7:0] timer_val, //load the timer value in tens of sec acording to time needed to stay for each state 
	output logic redLight,
	output logic yellowLight, 
	output logic greenLight
   );

	enum logic [2:0] {red_st, red_yellow_st, green_st, yellow_st} present_state, next_state;

// state register
always_ff @(posedge clk, negedge resetN)
		if (!resetN) 
			present_state <= red_st;
		else 
			present_state <= next_state;
			

// next state logic
always_comb 
begin

		case (present_state)
		
		red_st: 
			if ( endOftime || !switchN) begin
				next_state	= red_yellow_st;
			end else begin
				next_state	= red_st;
			end		
		red_yellow_st: 
			if (endOftime ) begin 
				next_state	= green_st;
			end else begin
				next_state	= red_yellow_st;
			end
		green_st: 
			if (endOftime) begin 
				next_state	= yellow_st;
			end else begin
				next_state	= green_st;
			end
		yellow_st: 
			if (endOftime ) begin 
				next_state	= red_st;
			end else begin
				next_state	= yellow_st;
			end
		default: begin 
				next_state	= red_st;
		end

		endcase
end


// Logic for loading the requested time into an auxiliary timer for each one of light state.   		
always_comb begin

		case (present_state)
		red_st: 
			if ( endOftime || !switchN) begin
				timer_val = red_yellow_timer;
			end else begin
				timer_val = red_timer;
			end	
		red_yellow_st: 
			if ( endOftime ) begin
				timer_val = green_timer;
			end else begin
				timer_val = red_yellow_timer;
			end
		green_st: 
			if ( endOftime ) begin
				timer_val = yellow_timer;
			end else begin
				timer_val = green_timer;
			end
		yellow_st: 
			if ( endOftime ) begin
				timer_val = red_timer;
			end else begin
				timer_val = yellow_timer;
			end
		default: begin 
			timer_val = red_timer;
		end

		endcase
		end
	assign loadN = !(endOftime || (present_state == red_st && !switchN));
	assign redLight		=  (present_state == red_st || present_state == red_yellow_st) ? 1'b1 : 1'b0;
	assign yellowLight	=  (present_state == yellow_st || present_state == red_yellow_st) ? 1'b1 : 1'b0;
	assign greenLight	= (present_state == green_st) ? 1'b1 : 1'b0;
  

endmodule


