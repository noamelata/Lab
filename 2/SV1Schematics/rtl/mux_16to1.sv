// (c) Technion IIT, Department of Electrical Engineering 2018 
// Written By Liat Schwartz August 2018 


// Implements mux 16=>1 by using 5 modules 
// mux_4to1 of case statement

module mux_16to1	
 ( 
   input logic [15:0] datain,
	input logic [3:0] select,
	output logic outd
	);

	logic [3:0] muxi; 
	
	mux_4to1_case mux0 ( .datain(datain[3:0]), .select(select[1:0]), .outd(muxi[0])); 
	mux_4to1_case mux1 ( .datain(datain[7:4]), .select(select[1:0]), .outd(muxi[1])); 
	mux_4to1_case mux2 ( .datain(datain[11:8]), .select(select[1:0]), .outd(muxi[2])); 
	mux_4to1_case mux3 ( .datain(datain[15:12]), .select(select[1:0]), .outd(muxi[3])); 
	mux_4to1_case mux4 ( .datain(muxi[3:0]), .select(select[3:2]), .outd(outd)); 
	
endmodule
