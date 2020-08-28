// (c) Technion IIT, Department of Electrical Engineering 2018 
// Implements mux 4=>1 with if statement
// combinatorial
// Alex Grinshpun
module mux_4to1_if 	
 ( 
   input logic [3:0] datain,
	input logic [1:0] sel,
	output logic outd
	);

	always_comb 
		begin
		
		if (sel == 0) begin
			outd = datain[0];
		end
		else if (sel == 1) begin
			outd = datain[1];
		end
		else if (sel == 2) begin
			outd = datain[2];
		end 
		else begin
			outd = datain[3];
		end


		end

endmodule

