 

module timer_4_digits_counter
	(
	input  logic clk, 
	input  logic resetN,
	input  logic ena, 
	input  logic ena_cnt, 
	input  logic loadN, 
	input  logic [1:0] [3:0] add_time,
	output logic [1:0] [3:0] Count_out,
	output logic tc
   );
	
	logic carry_ones;
	int ones;
	int tens;
	always_comb begin
		ones = add_time[0] + Count_out[0];
		carry_ones = ones < 10 ? 0 : 1;
		tens = add_time[1] + Count_out[1] + carry_ones;
		if (tens > 9) begin
			ones = 9;
			tens = 9;
		end
	end
		
	// units (Ones) 
	decimal_down_counter ones_counter(
		.clk(clk), 
		.resetN(resetN), 
		.ena(ena), 
		.ena_cnt(ena_cnt) ,  
		.loadN(loadN), 
		
		.datain(ones < 10 ? ones : ones - 10),
		
		.count(Count_out[0]),
		.tc(tc_ones)
	);

	
// Tens
	decimal_down_counter tens_counter( 
		.clk(clk), 
		.resetN(resetN), 
		.ena(ena), 
		.ena_cnt(tc_ones && ena_cnt) ,  
		.loadN(loadN), 
		
		.datain(tens),
		
		.count(Count_out[1]),
		.tc(tc_tens)
	);

	 	 
	assign tc = (Count_out == {4'h0,4'h0} && resetN) ? 1'b1 : 1'b0;  
	

 
endmodule
