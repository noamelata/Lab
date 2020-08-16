// (c) Technion IIT, Department of Electrical Engineering 2018 
// Implements a simple up-counter that uses
// the parameter N to define its size
// Alex Grinshpun

module up_counter 
	(
   // Input, Output Ports
   input logic clk, 
   input logic resetN,
   input logic loadN,
   input logic enable_cnt,
   input logic enable,
   input logic [3:0] init,
   output logic [3:0] count 
   );

 	 
 
   always_ff @( posedge clk , negedge resetN )
   begin
      
      if ( !resetN ) begin 
			count <= 0;
		end else if ( !enable ) begin
			count <= count;
		end else if ( !loadN ) begin
			count <= init;
		end else if ( enable_cnt ) begin
			count <= count + 1;
		end else begin
			count <= count;
		end

   end 
	 
endmodule

