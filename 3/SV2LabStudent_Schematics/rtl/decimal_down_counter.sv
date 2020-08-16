// (c) Technion IIT, Department of Electrical Engineering 2018 
// Implements a down counter 9 to 0 with enable and loadN data
// and count and tc outputs
// Alex Grinshpun

module decimal_down_counter
	(
	input logic clk,
	input logic resetN,
	input logic ena,
	input logic ena_cnt,
	input logic loadN, 
	input logic [3:0] datain,
	output logic [3:0] count,
	output logic tc
   );

// Down counter
always_ff @(posedge clk or negedge resetN)
  begin
		if ( !resetN )	begin // Asynchronic reset
				count <= 4'b0;
		end
		else 	begin		// Synchronic logic	
			if (!loadN) begin
				count <= datain;
			end else if (!ena) begin
				count <= count;
			end else if (!ena_cnt) begin
				count <= count;
			end else if (count == 4'b0) begin
				count <= 4'h9;
			end else begin
				count <= count - 1'b1;
			end	
		end //Synch
	end //always	
	
	
	// Asynchronic tc
	assign tc = (count == 4'b0 ) ? 1'b1 : 1'b0; 

					
			
					
endmodule
