
module TOP_BAR_TOP	(	
					input logic	clk,
					input logic	resetN,
					input logic startOfFrame,
					input logic timer_load,
					input logic [1:0] [3:0] time_to_add,
					input logic [1:0] [10:0] drawCoordinates,
					
					output logic [1:0] [3:0] timer,
					output logic one_sec_out,
					output logic duty50_out,
					output logic out_of_time,
					output logic timerDrawingRequest,
					output logic [7:0] timerRGB
					
);
 
 

logic [1:0] timerBusRequest;

logic [1:0] [7:0] timerBusRGB;	

logic [1:0] digitInsideSquare;
logic [1:0] [1:0] [10:0] digit_number_offset;


logic total_time;

logic [1:0] [3:0] timer_digit;
assign timer = timer_digit;

logic tc;
assign out_of_time = tc;

logic timer_on;


logic turbo;
logic one_sec;
assign one_sec_out = one_sec;
logic duty50;
assign duty50_out = duty50;


timer_4_digits_counter timer_inst (
			.clk(clk),
			.resetN(resetN),
			.ena(timer_on), 
			.ena_cnt(one_sec), 
			.loadN(!timer_load), 
			.add_time(time_to_add),
			.Count_out(timer_digit),
			.tc(tc)
			);

	
genvar i;	
generate
	for (i=0; i < 2; i++) begin : generate_timers_id
		square_object #(.OBJECT_WIDTH_X(16)) digitssquare(	
			.clk(clk),
			.resetN(resetN),
			.pixelX(drawCoordinates[0]),
			.pixelY(drawCoordinates[1]),
			.topLeftX(48 - (i*32)), 
			.topLeftY(10'h10),

			.offsetX(digit_number_offset[i][0]), 
			.offsetY(digit_number_offset[i][1]),
			.drawingRequest(digitInsideSquare[i]),
			.RGBout(timerBusRGB[i]) 
		);

			
		NumbersBitMap	(	
					.clk(clk),
					.resetN(resetN),
					.offsetX(digit_number_offset[i][0]), 
					.offsetY(digit_number_offset[i][1]),
					.InsideRectangle(digitInsideSquare[i]), //input that the pixel is within a bracket 
					.digit(timer_digit[i]), // digit to display
					
					.drawingRequest(timerBusRequest[i]), //output that the pixel should be dispalyed 
					.RGBout()
		);

  end
endgenerate



digits_mux digits_mux(
					.clk(clk),
					.resetN(resetN),
					.digitsBusRequest(timerBusRequest),
					.digitsBusRGB(timerBusRGB), 
					.digitsDrawingRequest(timerDrawingRequest),
					.digitsRGB(timerRGB)
					
);


						
one_sec_counter one_sec_counter  (

						.clk(clk), 
						.resetN(resetN), 
						.turbo(turbo),
						.one_sec(one_sec), 
						.duty50(duty50)
						);
	
always_ff @(posedge clk or negedge resetN)
   begin
	timer_on <= timer_on;
   if ( !resetN )  // Asynchronic reset
		timer_on <= 1'b1;
	else if (timer_load)
		timer_on <= 1'b1;
   else if (tc)	// Synchronic logic FSM
		timer_on <= 1'b0;
end
						

endmodule

