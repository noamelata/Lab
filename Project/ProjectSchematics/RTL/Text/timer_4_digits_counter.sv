 

module timer_4_digits_counter
	(
	input  logic clk, 
	input  logic resetN,
	input  logic ena, 
	input  logic ena_cnt, 
	input  logic loadN, 
	input  logic [3:0] [3:0] add_time,
	output logic [3:0] [3:0] Count_out,
	output logic tc
   );
	
	logic [4:0] tc_bus ;	
	assign tc_bus[0] = 1'b1;
	logic [3:0] [3:0] datain;
	int sum;
	logic [4:0] carry;
	assign carry[0] = 1'b0;
	
	always_comb
	begin
		for (int j=0; j < 4; j++) begin
			sum = carry[j];
			sum = sum + add_time[j];
			sum = sum + Count_out[j];
			if (sum <= 9) begin
				datain[j] = sum;
				carry[j+1] = 1'b0;
			end else begin
				datain[j] = sum - 10;
				carry[j+1] = 1'b1;
			end
		end
	end
	
	genvar i;
	generate
		for (i=0; i < 4; i++) begin : generate_digits_id
			decimal_down_counter counter(
				.clk(clk), 
				.resetN(resetN), 
				.ena(ena), 
				.ena_cnt(tc_bus[i] && ena_cnt) ,  
				.loadN(loadN), 
				
				.datain(datain[i][3:0]),
				
				.count(Count_out[i][3:0]),
				.tc(tc_bus[i+1])
			);
	
		end
	endgenerate

	

	 
	assign tc = (Count_out == {4'h0,4'h0,4'h0,4'h0,} && resetN) ? 1'b1 : 1'b0;  

 
endmodule
