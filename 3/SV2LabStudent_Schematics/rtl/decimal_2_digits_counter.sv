// (c) Technion IIT, Department of Electrical Engineering 2018 
// Alex Grinshpun Sept 2019

// Kobi Dekel Jul 2020
// This module shows an example for how to build hierarchy-integrated module from generic module  
// Here we take two 4bit in/out decimal_down_counter and use them to build 8bit in/out 
// decimal_2_digits_counter ( 4bit x 2 binary ) each 4 bit output can be connected to BCD27Seg 
// module and feed 7Seg. The lower 4 bit relate to the units(ones),and the higher 4 bit relate 
// to the Tens.      


module decimal_2_digits_counter
	(
	input  logic clk, 
	input  logic resetN,
	input  logic ena, 
	input  logic ena_cnt, 
	input  logic loadN, 
	input  logic [7:0] Data_init,
	output logic [7:0] Count_out,
	output logic tc
   );
	
	logic tc_ones ;
	logic tc_tens ;
	
	
// units (Ones) 
	decimal_down_counter ones_counter(
		.clk(clk), 
		.resetN(resetN), 
		.ena(ena), 
		.ena_cnt(ena_cnt) ,  
		.loadN(loadN), 
		
		.datain(Data_init[3:0]),
		
		.count(Count_out[3:0]),
		.tc(tc_ones)
	);

	
// Tens
	decimal_down_counter tens_counter( 
		.clk(clk), 
		.resetN(resetN), 
		.ena(ena), 
		.ena_cnt(tc_ones) ,  
		.loadN(loadN), 
		
		.datain(Data_init[7:4]),
		
		.count(Count_out[7:4]),
		.tc(tc_tens)
	);

	 
		assign tc = (Count_out == 8'b0 && resetN) ? 1'b1 : 1'b0;  

 
endmodule
