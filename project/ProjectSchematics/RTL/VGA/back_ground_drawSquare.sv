//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2019 


module	back_ground_drawSquare	(	

					input	logic	clk,
					input	logic	resetN,
					input 	logic	[10:0]	pixelX,
					input 	logic	[10:0]	pixelY,

					output	logic	[7:0]	BG_RGB,
					output	logic		boardersDrawReq 
);

const int	xFrameSize	=	639;
const int	yFrameSize	=	479;
const int	bracketOffset =	30;

localparam logic [7:0] COLOR = 8'h111 ;// bitmap of a dark color

assign BG_RGB =  COLOR ; //collect color nibbles to an 8 bit word 

endmodule

