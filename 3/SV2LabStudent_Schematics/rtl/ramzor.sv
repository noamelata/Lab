 // Alex Grinshpun Sept 2019
 
 // Kobi Dekel Jul 2020 
 // This is an example which shows how to build and use general-purpose timer
 // The timer can be usded for example in a state machine to count different times 
 // needed during the FSM operation. The general-purpose timer ena_cnt is feeded through  
 // Tens of second counter. This allows the timer to count in resolution of Tens of a second 
 // For example load the timer with value 48 means 4.8sec .  
 
 
 module ramzor
	(
	input logic CLOCK_50,
	input logic resetN, 
	input logic switchN,
	input logic turbo, 	
	output logic redLight,
	output logic yellowLight, 
	output logic greenLight
   );

	// Global veriable 
   logic [7:0] timer_val;
	logic onetens_sec;
	logic loadN; 
	logic endoftime;
	
aux_timer aux_timer
(
		.clk(CLOCK_50),
		.resetN(resetN), 
		.ena_cnt(onetens_sec),
		.loadN(loadN),
		.datain(timer_val),
		.tc(endoftime)
);

onetens_sec_counter onetens_sec_counter      	
(
   // Input, Output Ports
		.clk(CLOCK_50), 
		.resetN(resetN), 
		.turbo(turbo),
		.onetens_sec(onetens_sec),
		.duty50()
);

ramzor_fsm 	#(	 .red_timer (48), 
						 .red_yellow_timer (18),
						 .green_timer (36),
						 .yellow_timer (18)
				  )
ramzor_fsm
(

		.clk(CLOCK_50),
		.resetN(resetN), 
		.switchN(switchN), 
		.endOftime(endoftime),
		.loadN(loadN),
		.timer_val(timer_val),
		.redLight(redLight),
		.yellowLight(yellowLight), 
		.greenLight(greenLight)
		
);


   

endmodule


