// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By Liat Schwartz August 2018 

// Implements the state machine of the bomb
// mini-project, with present and next states
// Kobi Dekel 2020 

module bomb_fsm
	(
	input logic clk, 
	input logic resetN, 
	input logic startN, 				// Start the bomb counter 
	input logic waitN, 				// Pause the bomb counter 
	input logic slowClken, 			// Flikering the bomb display Onesec ON Onesec OFF
	input logic tcSec,            // Trigger to explode the bomb   
	                              
	output logic countEnable,     // Enable the count down counter 
	output logic countLoadN,       // Load the bomb down count counter.  
	output logic lampEnable,       // Turn the bomb display to ON - Show the number 00  
	output logic lampTest         
   );                            

	enum logic [2:0] {Sidle, Sarm, Srun, Spause, SlampOn, SlampOff} prState, nxtState;
 	
always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN )  // Asynchronic reset
		prState <= Sidle;
   else 		// Synchronic logic FSM
		prState <= nxtState;
		
	end // always
	
always_comb // Update next state and outputs
	begin
		nxtState = prState; // default values 
		countEnable = 1'b0;
		countLoadN = 1'b1;
		lampEnable = 1'b1;
		lampTest = 1'b0;
		
		case (prState)
				
			Sidle: begin
				lampEnable = 1'b0;
				if (startN == 1'b0) 
					 nxtState = Sarm;
				end // idle
						
			Sarm: begin
				countLoadN = 1'b0;
				if (startN == 1'b1)  //Initiat the bomb when the start key is pressed   
					nxtState = Srun; 	
				end // arm
						
			Srun: begin
				countEnable = 1'b1; 
				
				if (tcSec == 1'b1)  // Check if time is over  
					nxtState = SlampOn; 
				else if (waitN == 1'b0) 
					nxtState = Spause; 
				end // run
				
			Spause: begin
				countEnable = 1'b0;
				if (waitN == 1'b1)   // As long as the wait key is pressed it pauses the timer 
					nxtState = Srun; 
				end // pause
			
// The next two states blink the display.  			
			SlampOn: begin
			lampEnable = 1'b1; 
			lampTest = 1'b1;
				if (slowClken == 1'b1) 
					nxtState = SlampOff;
				end // lampOn
						
			SlampOff: begin 
				lampEnable = 1'b0; 
					if (slowClken == 1'b1) 
						nxtState = SlampOn;
				end // lampOff
						
			endcase
	end // always comb
	
endmodule
