
module levelFSM (
                input logic level_up,
                
                output logic [1:0] trees_to_add,
                output logic [1:0] tree_speed,
                output logic [1:0] bird_speed,
                output logic number_of_birds,
                );
                
enum logic [3:0] {level_1, level_2, level_3, level_4, level_5, level_6, level_7, level_8} level, next_level;
 
always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN )  // Asynchronic reset
		level <= level_1;
   else 		// Synchronic logic FSM
		level <= next_level;

end // always

always_comb
begin
	next_level = level;
	if (level_up == 1'b1)
    next_level = level + 1;	
  
  trees_to_add = 2'b0;
  tree_speed = 2'b0;
  bird_speed = 2'b0;
  number_of_birds = 1'b0;
  
  case(level)
  level_1:
    trees_to_add = 2'b10;
  
  level_2:
    trees_to_add = 2'b10;
    bird_speed = 2'b01;
    
  level_3:
    number_of_birds = 1'b1;
    tree_speed = 2'b01;
    bird_speed = 2'b01;
    
  level_4:
    number_of_birds = 1'b1;
    tree_speed = 2'b01;
    bird_speed = 2'b10;
    trees_to_add = 2'b10;
  
  level_5:
    number_of_birds = 1'b1;
    tree_speed = 2'b10;
    bird_speed = 2'b10;
  
  level_5:
    number_of_birds = 1'b1;
    tree_speed = 2'b10;
    bird_speed = 2'b10;
    trees_to_add = 2'b10;
    
  level_6:
    number_of_birds = 1'b1;
    tree_speed = 2'b11;
    bird_speed = 2'b10;
    
  level_7:
    number_of_birds = 1'b1;
    tree_speed = 2'b11;
    bird_speed = 2'b11;
   
  endcase;
end

endmodule
