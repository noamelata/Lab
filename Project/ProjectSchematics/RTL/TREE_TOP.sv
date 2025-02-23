
module TREE_TOP	(	
	input logic	clk,
	input logic	resetN,
	input logic startOfFrame,
	input logic [7:0] random_number,
	input logic [2:0] tree_speed,
	input logic [NUM_OF_TREES - 1:0] deploy_tree,
	input logic [1:0] [10:0] drawCoordinates,
	
	output logic [NUM_OF_TREES - 1:0] treesBusRequest,
	output logic [NUM_OF_TREES - 1:0] [1:0] [10:0] treesCoordinates,
	output logic treesDrawingRequest,
	output logic [7:0] treesRGB
				
);
 
parameter NUM_OF_TREES = 16;

localparam int bit_32 = 32;
localparam int bit_64 = 64;
localparam TREES_GAP = 30; //gap between generated trees (Y axis)

logic signed [NUM_OF_TREES - 1:0] [1:0] [10:0] Coordinates;
logic signed [NUM_OF_TREES - 1:0] [1:0] [10:0] treesOffset;
logic [NUM_OF_TREES - 1:0] BusRequest;
logic [NUM_OF_TREES - 1:0] treesInsideSquare;
logic [NUM_OF_TREES - 1:0] [7:0] treesBusRGB;
logic [NUM_OF_TREES - 1:0] trees_active; //tree should be displayed
logic [NUM_OF_TREES - 1:0] trees_jump; //tree reached bottom of screen and jumped to top			
logic [0:bit_64 - 1] [0:bit_32 - 1] [7:0] tree_bitmap;

treeBMP treeBMP(.object_colors(tree_bitmap));

genvar i;
generate
	for (i=0; i < NUM_OF_TREES; i++) begin : generate_trees_id //generate 16 trees 
		treeLogic #(.INITIAL_Y(i * TREES_GAP)) treelogic(	
			.clk(clk),
			.resetN(resetN),
			.startOfFrame(startOfFrame),
			.deploy(deploy_tree[i]),
			.random(random_number),
			.speed(tree_speed),
			.coordinate(Coordinates[i]),		
			.isActive(trees_active[i]),
			.jump(trees_jump[i])
		);

		square_object #(.OBJECT_WIDTH_X(bit_32), .OBJECT_HEIGHT_Y(bit_64)) treessquare(	//are trees withing bounds
			.clk(clk),
			.resetN(resetN),
			.pixelX(drawCoordinates[0]),
			.pixelY(drawCoordinates[1]),
			.topLeftX(Coordinates[i][0]), 
			.topLeftY(Coordinates[i][1]),

			.offsetX(treesOffset[i][0]), 
			.offsetY(treesOffset[i][1]),
			.drawingRequest(treesInsideSquare[i]),
			.RGBout() 
		);

			
		treeDraw treedraw( //which pixel from bitmap to send out
			.clk(clk),
			.resetN(resetN),
			.coordinate(treesOffset[i]),
			.InsideRectangle(treesInsideSquare[i]),
			.isActive(trees_active[i]), 
			.object_colors(tree_bitmap),

			.drawingRequest(BusRequest[i]), 
			.RGBout(treesBusRGB[i])
		) ;

  end
endgenerate


trees_mux trees_mux(	
	.clk(clk),
	.resetN(resetN),
	.treesBusRequest(BusRequest),
	.treesBusRGB(treesBusRGB), 

	.treesDrawingRequest(treesDrawingRequest),
	.treesRGB(treesRGB)					
);


assign treesCoordinates = Coordinates;
assign treesBusRequest = BusRequest;

endmodule

