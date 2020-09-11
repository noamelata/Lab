
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

//module of all HUD objects
 
//local parameters
localparam bit_16 = 16;
localparam bit_32 = 32;
localparam bit_64 = 64;
localparam ONE = 1;
localparam TWO = 2;
localparam THREE = 3;
 
//timer parameters
localparam DIGIT_X = 320; //X coordinate of timer digits
localparam DIGIT_Y = 8; //Y coordinate of timer digits
localparam DIGIT_GAP = 24; //gap between timer digits
localparam NUM_OF_TIMER_DIGITS = 2; // how many digits for timer

logic [4:0] [1:0] [10:0] digit_number_offset;
logic [1:0] timerBusRequest;
logic [1:0] [7:0] timerBusRGB;	
logic [4:0] digitInsideSquare;
logic timerDrawingRequest;
logic [7:0] timerRGB;
logic total_time;
logic [1:0] [3:0] timer_digit;
logic tc;
logic timer_on; //when low -> counter freezes
logic turbo; //not used (needed for one_sec)
logic one_sec;
logic duty50;


//level counter parameters
localparam LEVEL_X = 608; //X coordinate of level digits
localparam LEVEL_Y = 8; //Y coordinate of level digits
localparam LEVEL_GAP = 24; //gap between level digits
localparam NUM_OF_LEVEL_DIGITS = 2; // how many digits for levels
localparam logic [3:0] LETTER_L = 4'hF; //index for letter L in numbersBitMap (changed F to L)

logic signed [2:0] [1:0] [10:0] heartoffset;
logic [2:0] levelBusRequest;
logic [2:0] [7:0] levelBusRGB;
logic levelsDrawingRequest;
logic [7:0] levelsRGB;

//hearts parameters
localparam HEART_X = 16; //X coordinate of heart icons
localparam HEART_Y = 8; //Y coordinate of heart icons
localparam HEART_GAP = 48; //gap between heart icons
localparam NUM_OF_HEARTS = 3; //max number of hearts

logic [2:0] heartInsideSquare;
logic [2:0] heartsBusRequest;
logic [2:0] [7:0] heartBusRGB;
logic heartsDrawingRequest;
logic [7:0] heartsRGB;
logic [0:bit_32 - 1] [0:bit_32 - 1] [7:0] heart_bitmap;
logic [2:0] hearts_active;


//game over parameters
localparam GAMEOVER_X = 288;
localparam GAMEOVER_Y = 208;

logic signed [1:0] [10:0] gameoverOffset;
logic [0:bit_64 - 1] [0:bit_64 - 1] [7:0] gameover_bitmap;
logic gameoverInsideSquare;
logic gameoverRequest;
logic [7:0] gameoverRGB;


// TIMER
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
	for (i = 0; i < NUM_OF_TIMER_DIGITS; i++) begin : generate_timers_id //instantiate two digits for timer
		square_object #(.OBJECT_WIDTH_X(bit_16)) digitssquare(	
			.clk(clk),
			.resetN(resetN),
			.pixelX(drawCoordinates[0]),
			.pixelY(drawCoordinates[1]),
			.topLeftX(DIGIT_X - (i * DIGIT_GAP)), 
			.topLeftY(DIGIT_Y),

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


digits_mux digits_mux( //which digit should be printed
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
						
						
	
always_ff@(posedge clk or negedge resetN)
begin
	if ( !resetN )  // Asynchronic reset
		timer_on <= 1'b1;
	else begin 
		if (timer_load)
			timer_on <= 1'b1;
		else if (tc || gameOver)	// Synchronic logic FSM
			timer_on <= 1'b0;
		else
			timer_on <= timer_on;
	end
end


	

//LEVEL COUNTER
generate
	for (i= 0 ; i < NUM_OF_LEVEL_DIGITS + 1; i++) begin : generate_levels_id
		square_object #(.OBJECT_WIDTH_X(bit_16)) levelssquare(	
			.clk(clk),
			.resetN(resetN),
			.pixelX(drawCoordinates[0]),
			.pixelY(drawCoordinates[1]),
			.topLeftX(LEVEL_X - (i * LEVEL_GAP)), 
			.topLeftY(LEVEL_Y),

			.offsetX(digit_number_offset[i + NUM_OF_LEVEL_DIGITS][0]), 
			.offsetY(digit_number_offset[i + NUM_OF_LEVEL_DIGITS][1]),
			.drawingRequest(digitInsideSquare[i + NUM_OF_LEVEL_DIGITS]),
			.RGBout(levelBusRGB[i]) 
		);

			
		NumbersBitMap	(	
			.clk(clk),
			.resetN(resetN),
			.offsetX(digit_number_offset[i + NUM_OF_LEVEL_DIGITS][0]), 
			.offsetY(digit_number_offset[i + NUM_OF_LEVEL_DIGITS][1]),
			.InsideRectangle(digitInsideSquare[i + NUM_OF_LEVEL_DIGITS]), //input that the pixel is within a bracket 
			.digit((i == NUM_OF_LEVEL_DIGITS) ? LETTER_L : level_num[i]), // digit to display
			
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




//HEART ICONS	
heartBMP heartBMP(.object_color(heart_bitmap));

generate
	for (i = 0; i < NUM_OF_HEARTS; i++) begin : generate_hearts_id
		square_object heartSquare(	
			.clk(clk),
			.resetN(resetN),
			.pixelX(drawCoordinates[0]),
			.pixelY(drawCoordinates[1]),
			.topLeftX(HEART_X + (i * HEART_GAP)), 
			.topLeftY(HEART_Y),

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



//GAME OVER SCREEN
gameoverBMP gameoverBMP(.object_colors(gameover_bitmap));

square_object #(.OBJECT_WIDTH_X(bit_64), .OBJECT_HEIGHT_Y(bit_64)) gameoverSquare(	
			.clk(clk),
			.resetN(resetN),
			.pixelX(drawCoordinates[0]),
			.pixelY(drawCoordinates[1]),
			.topLeftX(GAMEOVER_X - 1), 
			.topLeftY(GAMEOVER_Y - 1),

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

//ALL HUD OBJECTS MUX
bar_mux	bar_mux	(	
	.clk(clk),
	.resetN(resetN),
	.timerDrawingRequest(timerDrawingRequest),
	.timerRGB(timerRGB),	
	.heartsDrawingRequest(heartsDrawingRequest),
	.heartsRGB(heartsRGB),
	.levelsDrawingRequest(levelsDrawingRequest),
	.levelsRGB(levelsRGB),
	.gameoverRequest(gameoverRequest),
	.gameoverRGB(gameoverRGB),
			
	.barDrawingRequest(barDrawingRequest),
	.barRGB(barRGB)
					
);

assign hearts_active[0] = (num_of_hearts >= ONE) ? 1'b1 : 1'b0; //how many heart icons to display
assign hearts_active[1] = (num_of_hearts >= TWO) ? 1'b1 : 1'b0;
assign hearts_active[2] = (num_of_hearts >= THREE) ? 1'b1 : 1'b0;
assign timer = timer_digit;
assign out_of_time = tc;
assign one_sec_out = one_sec;
assign duty50_out = duty50;

endmodule

