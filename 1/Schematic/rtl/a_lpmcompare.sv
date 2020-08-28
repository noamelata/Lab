//Alex Grinshpun Dec 2018

module a_lpmcompare (
 input logic [3:0] dataa,
 input logic [3:0] datab,
 output logic aeb
);

assign aeb = ( dataa == datab ) ? 1'b1 : 1'b0;

endmodule