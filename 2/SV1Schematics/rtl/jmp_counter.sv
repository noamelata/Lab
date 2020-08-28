// (c) Technion IIT, Department of Electrical Engineering 2018 
// Implements a simple up-counter that uses
// the parameter N to define its size

module jmp_counter 
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
		end else if (count == 6) begin
			count <= 11;
		end else begin
			count <= count + 1;
		end
 
	end 
	 
endmodule

