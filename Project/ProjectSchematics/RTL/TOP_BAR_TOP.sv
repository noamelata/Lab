
module TOP_BAR_TOP	(	
					input logic	clk,
					input logic	resetN,
					input logic startOfFrame,
					input logic timer_load,
					input logic [1:0] [3:0] time_to_add,
					input logic [1:0] [10:0] drawCoordinates,
					input logic [1:0] num_of_hearts,
					input logic [1:0] [3:0] level_num,
					input logic gameOver,
					
					output logic [1:0] [3:0] timer,
					output logic one_sec_out,
					output logic duty50_out,
					output logic out_of_time,
					output logic barDrawingRequest,
					output logic [7:0] barRGB
					
);
 

logic [1:0] timerBusRequest;

logic [1:0] [7:0] timerBusRGB;	

logic [4:0] digitInsideSquare;
logic [4:0] [1:0] [10:0] digit_number_offset;
logic timerDrawingRequest;
logic [7:0] timerRGB;


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

localparam bit_32 = 32;
localparam bit_64 = 64;


timer_2_digits_counter timer_inst (
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
			.topLeftX(320 - (i*24)), 
			.topLeftY(10'h8),

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
   else if (tc || gameOver)	// Synchronic logic FSM
		timer_on <= 1'b0;
end


/******************************************/
logic [2:0] levelBusRequest;

logic [2:0] [7:0] levelBusRGB;

logic levelsDrawingRequest;
logic [7:0] levelsRGB;	


generate
	for (i=0; i < 3; i++) begin : generate_levels_id
		square_object #(.OBJECT_WIDTH_X(16)) levelssquare(	
			.clk(clk),
			.resetN(resetN),
			.pixelX(drawCoordinates[0]),
			.pixelY(drawCoordinates[1]),
			.topLeftX(608 - (i*24)), 
			.topLeftY(10'h8),

			.offsetX(digit_number_offset[i + 2][0]), 
			.offsetY(digit_number_offset[i + 2][1]),
			.drawingRequest(digitInsideSquare[i + 2]),
			.RGBout(levelBusRGB[i]) 
		);

			
		NumbersBitMap	(	
					.clk(clk),
					.resetN(resetN),
					.offsetX(digit_number_offset[i + 2][0]), 
					.offsetY(digit_number_offset[i + 2][1]),
					.InsideRectangle(digitInsideSquare[i + 2]), //input that the pixel is within a bracket 
					.digit((i == 2) ? 4'hF : level_num[i]), // digit to display
					
					.drawingRequest(levelBusRequest[i]), //output that the pixel should be dispalyed 
					.RGBout()
		);

  end
endgenerate


levels_mux levels_mux(
					.clk(clk),
					.resetN(resetN),
					.levelsBusRequest(levelBusRequest),
					.levelsBusRGB(levelBusRGB), 
					.levelsDrawingRequest(levelsDrawingRequest),
					.levelsRGB(levelsRGB)
					
);

/******************************************/

logic signed [1:0] [10:0] backgroudOffset;
logic backgroundInsideSquare;
logic backgroundRequest;
logic [7:0] backgroundRGB;

		
	
square_object #(.OBJECT_WIDTH_X(640), .OBJECT_HEIGHT_Y(48)) background_square(	
			.clk(clk),
			.resetN(resetN),
			.pixelX(drawCoordinates[0]),
			.pixelY(drawCoordinates[1]),
			.topLeftX(10'b0), 
			.topLeftY(10'b0),

			.offsetX(backgroudOffset[0]), 
			.offsetY(backgroudOffset[1]),
			.drawingRequest(backgroundInsideSquare),
			.RGBout() 
		);
	

			
		barDraw barDraw(
			.clk(clk),
			.resetN(resetN),
			.coordinate(backgroudOffset),
			.InsideRectangle(backgroundInsideSquare),
			
			.drawingRequest(backgroundRequest), 
			.RGBout(backgroundRGB)
		) ;
		


/******************************************/

logic signed [2:0] [1:0] [10:0] heartoffset;
logic [2:0] heartInsideSquare;
logic [2:0] heartsBusRequest;
logic [2:0] [7:0] heartBusRGB;
logic heartsDrawingRequest;
logic [7:0] heartsRGB;

logic [0:bit_32 - 1] [0:bit_32 - 1] [7:0] heart_bitmap;
heartBMP heartBMP(.object_color(heart_bitmap));
logic [2:0] hearts_active;
		
generate
	for (i=0; i < 3; i++) begin : generate_hearts_id
		square_object heartSquare(	
			.clk(clk),
			.resetN(resetN),
			.pixelX(drawCoordinates[0]),
			.pixelY(drawCoordinates[1]),
			.topLeftX(16 + (i*48)), 
			.topLeftY(10'h8),

			.offsetX(heartoffset[i][0]), 
			.offsetY(heartoffset[i][1]),
			.drawingRequest(heartInsideSquare[i]),
			.RGBout() 
		);

			
		heartDraw heartdraw(
			.clk(clk),
			.resetN(resetN),
			.coordinate(heartoffset[i]),
			.InsideRectangle(heartInsideSquare[i]),
			.isActive(hearts_active[i]), 
			.object_color(heart_bitmap),

			.drawingRequest(heartsBusRequest[i]), 
			.RGBout(heartBusRGB[i])
		);

  end
endgenerate

heart_mux heart_mux(	
					.clk(clk),
					.resetN(resetN),
					.heartsBusRequest(heartsBusRequest),
					.heartsBusRGB(heartBusRGB),
					
					.heartsDrawingRequest(heartsDrawingRequest),
					.heartsRGB(heartsRGB)
					
);

assign hearts_active[0] = (num_of_hearts >= 1) ? 1'b1 : 1'b0; 
assign hearts_active[1] = (num_of_hearts >= 2) ? 1'b1 : 1'b0;
assign hearts_active[2] = (num_of_hearts >= 3) ? 1'b1 : 1'b0;

logic [0:bit_64 - 1] [0:bit_64 - 1] [7:0] gameover_bitmap;
gameoverBMP gameoverBMP(.object_colors(gameover_bitmap));

logic signed [1:0] [10:0] gameoverOffset;
logic gameoverInsideSquare;
logic gameoverRequest;
logic [7:0] gameoverRGB;

square_object #(.OBJECT_WIDTH_X(bit_64), .OBJECT_HEIGHT_Y(bit_64)) gameoverSquare(	
			.clk(clk),
			.resetN(resetN),
			.pixelX(drawCoordinates[0]),
			.pixelY(drawCoordinates[1]),
			.topLeftX(288 - 1), 
			.topLeftY(208 - 1),

			.offsetX(gameoverOffset[0]), 
			.offsetY(gameoverOffset[1]),
			.drawingRequest(gameoverInsideSquare),
			.RGBout() 
		);

			
		gameoverDraw gameoverdraw(
			.clk(clk),
			.resetN(resetN),
			.coordinate(gameoverOffset),
			.InsideRectangle(gameoverInsideSquare),
			.duty50(duty50), 
			.gameOver(gameOver),
			.object_colors(gameover_bitmap),

			.drawingRequest(gameoverRequest), 
			.RGBout(gameoverRGB)
);

bar_mux	bar_mux	(	
			.clk(clk),
			.resetN(resetN),
			.timerDrawingRequest(timerDrawingRequest),
			.timerRGB(timerRGB),	
			.backgroundRequest(backgroundRequest),
			.backgroundRGB(backgroundRGB),
			.heartsDrawingRequest(heartsDrawingRequest),
			.heartsRGB(heartsRGB),
			.levelsDrawingRequest(levelsDrawingRequest),
			.levelsRGB(levelsRGB),
			.gameoverRequest(gameoverRequest),
			.gameoverRGB(gameoverRGB),
					
			.barDrawingRequest(barDrawingRequest),
			.barRGB(barRGB)
					
);
						

endmodule

