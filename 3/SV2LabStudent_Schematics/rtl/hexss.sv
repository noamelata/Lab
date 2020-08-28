// (c) Technion IIT, Department of Electrical Engineering 2018 

// Implements the hexadecimal to 7Segment conversion unit
// Alex Grinshpun

module hexss 
	(
	input logic [3:0] hexin, 		// Data input: hex numbers 0 to f
	input logic darkN, 
	input logic LampTest, 	// Aditional inputs
	output logic [6:0] ss 	// Output for 7Seg display
	);


always_comb
begin
		if (LampTest) 
			ss = 7'b0000000;
		else if (!darkN)
			ss = 7'b1111111;
		else
		case(hexin)
		4'h1: ss = 7'b1111001;	// ---t----
		4'h2: ss = 7'b0100100; 	// |	  |
		4'h3: ss = 7'b0110000; 	// lt	 rt
		4'h4: ss = 7'b0011001; 	// |	  |
		4'h5: ss = 7'b0010010; 	// ---m----
		4'h6: ss = 7'b0000010; 	// |	  |
		4'h7: ss = 7'b1111000; 	// lb	 rb
		4'h8: ss = 7'b0000000; 	// |	  |
		4'h9: ss = 7'b0011000; 	// ---b----
		4'ha: ss = 7'b0001000;
		4'hb: ss = 7'b0000011;
		4'hc: ss = 7'b1000110;
		4'hd: ss = 7'b0100001;
		4'he: ss = 7'b0000110;
		4'hf: ss = 7'b0001110;
		4'h0: ss = 7'b1000000;
		endcase
end

endmodule


