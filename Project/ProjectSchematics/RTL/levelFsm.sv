
module levelFSM (
					 input logic clk,             
					 input logic resetN,
                input logic level_up,
					 input logic startOfFrame,

					 output logic [3:0] bird_life,
                output logic [15:0] trees_to_add,
                output logic [2:0] tree_speed,
                output logic [1:0] bird_speed,
                output logic [1:0] number_of_birds,
					 output logic [1:0] [3:0] level_num
                );
                
enum logic [3:0] {level_1, level_2, level_3, level_4, level_5, level_6, level_7, level_8} level, next_level;
 
always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN ) begin // Asynchronic reset
		level <= level_1;
		level_num[0] <= 4'h1;
		level_num[1] <= 4'h0;
	end
   else begin 	// Synchronic logic FSM
		if (level == level_8)
			level <= level;
		else
			level <= next_level;
		if (level_up == 1'b1) begin
			if (level_num[0] == 4'h9) begin
				level_num[0] <= 4'h0;
				level_num[1] <= level_num[1] + 4'h1;
			end
			else
				level_num[0] <= level_num[0] + 4'h1;
		end
	end
			

end // always

always_comb
begin
	next_level = level;
	if (level_up == 1'b1)
		next_level = level.next;	

	tree_speed = 3'b0;
	bird_speed = 2'b0;
	number_of_birds = 2'b00;
	bird_life = 4'h3;
	  
	case(level)
	level_1:
	begin
		trees_to_add = 16'h101; //trees # 0,8
	end
	
	level_2:
	begin
		trees_to_add = 16'h1111; //trees # 0,4,8,12
		bird_speed = 2'b01;
		tree_speed = 3'b001;
	end
		 
	level_3:
	begin
		 trees_to_add = 16'h1515; //trees # 0,2,4,6,8,12
		 number_of_birds = 2'b01;
		 tree_speed = 3'b010;
		 bird_speed = 2'b01;
		 bird_life = 4'h4;
	end
		 
	level_4:
	begin
		 number_of_birds = 2'b01;
		 tree_speed = 3'b011;
		 bird_speed = 2'b10;
		 trees_to_add = 16'h5555; //trees # 0,2,4,6,8,10,12,14
		 bird_life = 4'h4;
	end
	  
	level_5:
	begin
		 number_of_birds = 2'b10;
		 trees_to_add = 16'hD5D5; //trees # 0,2,4,6,7,8,10,12,14,15
		 tree_speed = 3'b100;
		 bird_speed = 2'b10;
		 bird_life = 4'h5;
	end
	  
	level_6:
	begin
		 number_of_birds = 2'b10;
		 tree_speed = 3'b101;
		 bird_speed = 2'b10;
		 trees_to_add = 16'hDDDD; //trees # 0,2,3,4,6,7,8,10,11,12,14,15
		 bird_life = 4'h5;
	end
		 
	level_7:
	begin
		 trees_to_add = 16'hDFDF; //trees # 0,1,2,3,4,6,7,8,9,10,11,12,14,15
		 number_of_birds = 2'b11;
		 tree_speed = 3'b110;
		 bird_speed = 2'b11;
		 bird_life = 4'h6;
	end
		 
	level_8:
	begin
		 trees_to_add = 16'hFFFF; //trees # 0 - 15
		 number_of_birds = 2'b11;
		 tree_speed = 3'b111;
		 bird_speed = 2'b11;
		 bird_life = 4'h7;
	end
	
	  endcase;
end

endmodule
