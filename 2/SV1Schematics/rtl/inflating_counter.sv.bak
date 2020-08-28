// (c) Technion IIT, Department of Electrical Engineering 2018 
// Implements the inflating counter by instantiating
// two counters and a comparator
// Alex Grinshpun

module inflating_counter 
	(
   // Input, Output Ports
	input logic clk, 
	input logic resetN, 
	input logic enable,
   
	output logic [3:0] FastCount,
	output logic [3:0] SlowCount
   );


	logic enable_cnt;
	
	// Fast counter instantiation
	up_counter fastC(
// Fill with your code
				.count(FastCount) 
				);

	// Slow counter instantiation
	up_counter slowC( //fill your code here
// Fill with your code
				.count(SlowCount) 
				);						
	
	// Comparator instantiation

 
  comparator cmp 
	(
   // Input, Output Ports
// Fill with your code
   ); 
endmodule
