// (c) Technion IIT, Department of Electrical Engineering 2018 
// Implements mux 4=>1 with case statement
// combinatorial
// Alex Grinshpun

module mux_4to1_case 	
 ( 
   input logic [3:0] datain,
	input logic [1:0] select,
	output logic outd
	);

always_comb
begin

	case (select)
	0: outd = datain[0];
	1: outd = datain[1];
	2: outd = datain[2];
	3: outd = datain[3];
	endcase

end

endmodule

