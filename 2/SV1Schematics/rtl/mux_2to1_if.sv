// (c) Technion IIT, Department of Electrical Engineering 2018 
// Implements mux 2=>1 with if statement
// combinatorial
// Alex Grinshpun
module mux_2to1_if 	
 ( 
   input logic [1:0] datain,
	input logic select,
	output logic outd
	);

	always_comb 
	begin
		if (select == 0) begin
			outd = datain[0];
		end
		else begin
			outd = datain[1];
		end
	end

endmodule

