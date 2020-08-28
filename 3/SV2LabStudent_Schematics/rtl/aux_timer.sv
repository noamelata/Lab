// (c) Technion IIT, Department of Electrical Engineering 2018 
// Implements a down counter 9 to 0 with enable and loadN data
// and count and tc outputs
// Alex Grinshpun

module aux_timer
	(
	input logic clk,
	input logic resetN,
	input logic ena_cnt,
	input logic loadN, 
	input logic [7:0] datain,
	output logic tc
   );

	logic [7:0] count;
		
// Down counter
always_ff @(posedge clk or negedge resetN)
  begin
		if ( !resetN )	begin // Asynchronic reset
				count <= 8'b0;
		end
		else 	begin		// Synchronic logic	
			if (!loadN) begin
				count <= datain;
			end else if (!ena_cnt) begin
				count <= count;
			end else if (count == 8'b0) begin
				count <= 8'hff;
			end else begin
				count <= count - 1'b1;
			end	
		end //Synch
	end //always	
	
	
	// Asynchronic tc
	assign tc = (count == 8'b0 ) ? 1'b1 : 1'b0; 

					
			
					
endmodule
