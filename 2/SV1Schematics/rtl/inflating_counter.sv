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
	up_counter fastC(.clk(clk), .resetN(resetN),
				.loadN(!enable_cnt), .enable_cnt(1'b1), .enable(enable),
				.init(4'h00), .count(FastCount) 
				);

	// Slow counter instantiation
	up_counter slowC( .clk(clk), .resetN(resetN),
				.loadN(1'b1), .enable_cnt(enable_cnt), .enable(enable),
				.init(4'h00),
				.count(SlowCount) 
				);						
	
	// Comparator instantiation 
  comparator cmp 
	(.vect1(FastCount), .vect2(SlowCount),
	.cmp(enable_cnt)
   ); 
endmodule
