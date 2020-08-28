// (c) Technion IIT, Department of Electrical Engineering 2018 

// Implements the hexadecimal to 7Segment conversion unit
// by using a two-dimensional array
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
	logic [0:15] [6:0] SevenSeg =	
				{	7'h40, //0
					7'h79, //1
					7'h24, //2
					7'h30, //3
					7'h19, //4
					7'h12, //5
					7'h02, //6
					7'h78, //7
					7'h00, //8
					7'h10, //9
					7'h08, //10
					7'h03, //11
					7'h46, //12
					7'h21, //13
					7'h06, //14
					7'h0e, //15
				};
	
	if (!darkN) begin
		ss = 7'h7f;
	end else if (LampTest) begin 
		ss = 7'h00;
	end else begin
		ss = SevenSeg[hexin];
	end

end

endmodule


