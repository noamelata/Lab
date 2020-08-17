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
	output logic lampEnable       // Turn the bomb display to ON - Show the number 00   
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
		/*   $$$$$$$   remove to fill 
		countEnable = //fill your code here
		countLoadN = //fill your code here
		lampEnable = //fill your code here
		*/
		
		case (prState)
				
			Sidle: begin
			/*   $$$$$$$   remove to fill 
				//lampEnable = //fill your code here
				if (startN == 1'b0) 
					// nxtState = //fill your code here
				*/
				end // idle
						
			Sarm: begin
			/*   $$$$$$$   remove to fill 
				// countLoadN = //fill your code here  // Load the bomb timer 
				if (startN == 1'b1)  //Initiat the bomb when the start key is pressed   
					//fill your code here 
				*/	
				end // arm
						
			Srun: begin
				/*   $$$$$$$   remove to fill 
				countEnable = //fill your code here  // allow the timer to run 
				countLoadN = //fill your code here 
				
				if (tcSec == 1'b1)  // Check if time is over  
					//fill your code here  // Jump to blink the display 
				else if (waitN == 1'b0) 
					//fill your code here 
				*/
				end // run
				
			Spause: begin
			/*   $$$$$$$   remove to fill 
				countEnable = //fill your code here 
				if (waitN == 1'b1)   // As long as the wait key is pressed it pauses the timer 
//					nxtState = SlampOn; // For immediate explosion 
					//fill your code here 	 // For regular operation
				*/
				end // pause
			
// The next two states blink the display.  			
			SlampOn: begin
			/*   $$$$$$$   remove to fill 
			 lampEnable = //fill your code here 
					if (slowClken == 1'b0) 
					//fill your code here
			*/
					end // lampOn
						
			SlampOff: begin
			/*   $$$$$$$   remove to fill 
				lampEnable = //fill your code here
				if (slowClken == 1'b1) 
					//fill your code here
					*/
				end // lampOff
						
			endcase
	end // always comb
	
endmodule
