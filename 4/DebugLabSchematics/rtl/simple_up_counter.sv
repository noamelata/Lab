// (c) Technion IIT, Department of Electrical Engineering 2018 
// Implements a simple up-counter that uses
// the parameter N to define its size
// Alex Grinshpun

module simple_up_counter 
	(
   // Input, Output Ports
   input logic clk, 
   input logic resetN,
   output logic [3:0] keyPad // counter output name to match pins
   );
	
	// Internal or local parameters declarations
	
	
 	 
 
   always_ff @( posedge clk or negedge resetN )
   begin
      
      if ( !resetN ) begin // Asynchronic reset
			keyPad	<= 4'h0;
			end
      else 	begin			// Synchronic logic	
				keyPad	<= keyPad +1'b1;
			end
    end // always
	 
endmodule

