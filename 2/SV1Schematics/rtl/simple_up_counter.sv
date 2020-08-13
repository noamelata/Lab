// (c) Technion IIT, Department of Electrical Engineering 2018 
// Implements a simple up-counter that uses
// the parameter N to define its size
// Alex Grinshpun

module simple_up_counter 
	(
   // Input, Output Ports
   input logic clk, 
   input logic resetN,
   output logic [3:0] count 
   );
	 	 
 
   always_ff @( posedge clk or negedge resetN )
   begin
	
		if ( !resetN ) begin // Asynchronic reset
			count <= 0;
		end else begin
			count <= count + 1;
		end
 
	end 
endmodule

