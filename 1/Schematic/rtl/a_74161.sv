// A.Grinshpun Dec 2018

module a_74161(
	input logic LDN,
	input logic A,
	input logic B,
	input logic C,
	input logic D,


	input logic ENT,
	input logic ENP,
	input logic CLRN,
	input logic CLK,
	output logic QA,
	output logic QB,
	output logic QC,
	output logic QD

);


logic [3:0] count;

always_ff @(posedge CLK, negedge CLRN)
begin
	if (!CLRN) begin
		count <= 4'b0;
	end
	else if (ENP  && ENT  ) begin
	  if ( !LDN  ) begin
		count <= {D,C,B,A};
	  end
	else 
		count <= count + 1'b1;

	end
end

assign QA = count[0];
assign QB = count[1];
assign QC = count[2];
assign QD = count[3];

endmodule
