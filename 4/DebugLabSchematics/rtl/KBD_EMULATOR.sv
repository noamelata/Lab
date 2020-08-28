//-- Avraham Kaplan March 2020


module KBD_EMULATOR 	(	

	input	logic	clk,
	input	logic	resetN,
	input	logic	SW[1:0],
	input	logic	push,
//	input	logic	extention,
	
	
//	output logic	triggerN,
//	output logic [1:0] data_type 
//	output	logic [8:0]	Data,
	output	logic	KBD_CLK,// ----_-_-_-_-_-_-_-_-_-_-_------ 
	output logic KBD_DAT								 
);


// a module used to generate KBD_CLK cycle 


enum  logic [2:0] {IDLE_ST, // initial state
				  keycode_make_Trns_ST, // after triggerN 
				  wait_between_chars_ST,
				  E0make_Trns_ST, // after wait20u or high40u  
				  keycode_break_Trns_ST, // after triggerN 
				  E0break_Trns_ST, // after wait20u or high40u  
				  F0break_Trns_ST // after low20u 
				  }  nxt_st, cur_st;
//localparam int  SimFactor = 2 ;// simulation 
localparam int  SimFactor = 20 ;//real life 

localparam int delayFirstCHAR = 150* SimFactor ;
localparam int delayOtherCHAR = 250 * SimFactor; //was 1500000
localparam int Trans_time = 480* SimFactor;

localparam int delay20usec = 10* SimFactor;
localparam int delay40usec = 20* SimFactor;
localparam int delay80usec = 40* SimFactor;


localparam int keycode_type = 2'b00;
localparam int E0_type = 2'b01;
localparam int F0_type = 2'b10;
localparam int extention_code = 1'b1;

const logic	low	=	1'b0;
const logic	high	=	1'b1;
const logic	extended_key	=	1'b1;
 
logic [15:0] Trans_time_cntr, Trans_time_cntr_ns;
logic [24:0] between_chars_cntr, between_chars_cntr_ns;
logic [24:0] between_chars_delay, between_chars_delay_ns;
logic [1:0] data_type, next_data_type;
logic first_char, first_char_ns;
logic triggerN, next_triggerN;
logic extention,  extention_ns;
//======--------------------------------------------------------------------------------------------------------------=
always_ff @(posedge clk or negedge resetN)
begin
	if(!resetN) 
	begin
		cur_st <= IDLE_ST; 
		triggerN <= high;
		first_char <= 1'b1;
		Trans_time_cntr <= 16'b0;
		between_chars_cntr <= 25'b0;
		data_type <= 2'b01;
		between_chars_delay <= 25'b0;
	end
	else 
	begin 
		cur_st <= nxt_st;
		triggerN <= next_triggerN;
		data_type <= next_data_type;
		Trans_time_cntr <= Trans_time_cntr_ns;
		between_chars_cntr <= between_chars_cntr_ns;
		first_char <= first_char_ns;
		between_chars_delay <= between_chars_delay_ns;
	end ; 
end

always_comb 
begin
	// default values 
	nxt_st = cur_st ;
	next_triggerN = triggerN;
	next_data_type = data_type;
	Trans_time_cntr_ns = Trans_time_cntr;
	between_chars_cntr_ns = between_chars_cntr;
	between_chars_delay_ns = delayFirstCHAR;
	first_char_ns = first_char;
	
	case(cur_st)
		IDLE_ST: 
		begin
//--------------
			next_triggerN = high;
			next_data_type = keycode_type;
			Trans_time_cntr_ns = 16'b0;
			between_chars_cntr_ns = 25'b0;
			first_char_ns =  1'b1; //first_char;
			
			if (push == low) 
			begin
				Trans_time_cntr_ns = 16'b0;			
				next_triggerN = low;
				first_char_ns = 1'b1;

				if( extention == extention_code)
				begin
					Trans_time_cntr_ns = 16'b0;
					next_data_type = E0_type;
					nxt_st = E0make_Trns_ST; 
				end
				else
				begin
					Trans_time_cntr_ns = 16'b0;
					next_data_type = keycode_type;
					nxt_st = keycode_make_Trns_ST; 
				end
			end
		end  
			
		E0make_Trns_ST: 
		begin
//--------------
			next_triggerN = high;
			if (Trans_time_cntr_ns < Trans_time) 
			begin
				Trans_time_cntr_ns = Trans_time_cntr + 16'b1;
			end
			else
			begin 
				Trans_time_cntr_ns =	16'b0;			
				next_triggerN = low;
				next_data_type = keycode_type;
				nxt_st = keycode_make_Trns_ST; 
			end
		end	///
						
		keycode_make_Trns_ST:
		begin
//--------------
			next_triggerN = high;
			if (Trans_time_cntr_ns < Trans_time) 
			begin
				Trans_time_cntr_ns = Trans_time_cntr + 16'b1;
			end
			else
			begin 
				Trans_time_cntr_ns =	16'b0;
				between_chars_cntr_ns = 25'b0;				
				nxt_st = wait_between_chars_ST; 
			end
		end	
		
		wait_between_chars_ST: 
		begin
//--------------
			if (first_char_ns == 1'b0)
				between_chars_delay_ns  = delayOtherCHAR;
			else
			begin
				between_chars_delay_ns  = delayFirstCHAR;
			end
			if (between_chars_cntr_ns < between_chars_delay_ns)
				between_chars_cntr_ns  = between_chars_cntr + 1'b1;
			else
			begin
				if (first_char_ns == 1'b1)
					first_char_ns = 1'b0;
				Trans_time_cntr_ns  =	16'b0;			
				next_triggerN  = low;
				if (push == low)
				begin // make procedure
					if (extention == extention_code)
					begin
						next_data_type  = E0_type;
						nxt_st = E0make_Trns_ST; 
					end
					else
					begin //keycode cycle
						next_data_type  = keycode_type;
						nxt_st = keycode_make_Trns_ST; 
					end
				end
				else
				begin //break procedure
					if (extention == extention_code)
					begin //E0 cycle
						next_data_type = E0_type;
						nxt_st = E0break_Trns_ST; 
					end
					else
					begin //keycode cycle
						next_data_type =F0_type;
						nxt_st = F0break_Trns_ST; 
					end
				end	
			end	
		end  


			
		E0break_Trns_ST: 
		begin
//--------------
			next_triggerN = high;
			if (Trans_time_cntr_ns < Trans_time) 
			begin
				Trans_time_cntr_ns = Trans_time_cntr + 16'b1;
			end
			else
			begin 
				Trans_time_cntr_ns =	16'b0;			
				next_triggerN = low;
				next_data_type = F0_type;
				nxt_st = F0break_Trns_ST; 
			end
		end	

		F0break_Trns_ST: 
		begin
//--------------
			next_triggerN = high;
			if (Trans_time_cntr_ns < Trans_time) 
			begin
				Trans_time_cntr_ns = Trans_time_cntr + 16'b1;
			end
			else
			begin 
				Trans_time_cntr_ns =	16'b0;			
				next_triggerN = low;
				next_data_type = keycode_type;
				nxt_st = keycode_break_Trns_ST; 
			end
		end	

		keycode_break_Trns_ST: 
		begin
//--------------
			next_triggerN = high;
			if (Trans_time_cntr_ns < Trans_time) 
			begin
				Trans_time_cntr_ns = Trans_time_cntr + 16'b1;
			end
			else
			begin 
				Trans_time_cntr_ns =	16'b0;
				between_chars_cntr_ns = 25'b0;				
				nxt_st = IDLE_ST; 
			end
		end
	
		default:
		begin
		
		end
		
 	
	endcase
end

always_comb 
begin
 
//	Data_ns = 9'h029; //SPACE;
	extention = 1'b0;
	Data_ns = Data;

 
	if (SW[1] == extended_key)
		extention = 1'b1;
	else
		extention = 1'b0;
		
		
//	case(next_data_type)
	case(data_type)
	
		2'b00://KeyCode: 
		begin
			if (SW[0] == 1'b1)
				Data_ns = 9'h174; //RIGHT_ARROW
			else
//				Data_ns = 9'h029; //SPACE;
				Data_ns = 9'h029; //SPACE;
		end
		
		2'b01://extentionCode:
		begin
			Data_ns = 9'h0E0;
		end
		
		2'b10://releasecode:
		begin
			Data_ns = 9'h1F0;
		end
		
		default:
		begin
		end
		
	endcase
end


//endmodule	
			
			
//-- Avraham Kaplan March 2020


//module Clk_Trnsmtr	(	

//	input	logic	triggerN,  // initialize KBD_CLK cycle (11  basic cycles of 80usec each)
	
//	output	logic	KBD_CLK// ----_-_-_-_-_-_-_-_-_-_-_------ 
									 
//);


// a module used to generate KBD_CLK cycle 

enum  logic [1:0] {IDLE1_ST, // initial state
				  wait20u_ST, // after triggerN 
				  low40u_ST, // after wait20u or high40u  
				  high40u_ST // after low20u 
				  }  nxt1_st, cur1_st;

  


localparam int KBD_clk_cycles = 11;


logic [3:0] basic_cycles_cntr, basic_cycles_cntr_ns; 
logic [11:0] time_cntr, time_cntr_ns; 
logic next_KBD_CLK;

//======--------------------------------------------------------------------------------------------------------------=
always_ff @(posedge clk or negedge resetN)
begin: fsm_sync_proc
	if(!resetN) 
	begin
		cur1_st <= IDLE1_ST; 
		KBD_CLK <= high;
		basic_cycles_cntr <= 4'b0;
		time_cntr <= 12'b0;
	end
	else 
	begin 
		cur1_st <= nxt1_st;
		basic_cycles_cntr <= basic_cycles_cntr_ns ; 
		time_cntr <= time_cntr_ns;
		KBD_CLK <= next_KBD_CLK  ; 
	end ; 
end

always_comb 
begin
	// default values 
	nxt1_st = cur1_st ;
	basic_cycles_cntr_ns = basic_cycles_cntr;  
	time_cntr_ns = time_cntr;
	next_KBD_CLK = KBD_CLK ; 

	case(cur1_st)
		IDLE1_ST: 
		begin
//--------------
			next_KBD_CLK = high;
			basic_cycles_cntr_ns = 4'b0;
			time_cntr_ns = 12'b0;
			if( triggerN == 1'b0)
			begin			
				next_KBD_CLK = high;
				time_cntr_ns = 12'b0;
				nxt1_st = wait20u_ST;
			end
//			else
//				nxt_st = IDLE_ST ;
		end  
			
		wait20u_ST: 
		begin
//--------------
			if (time_cntr_ns < delay20usec) 
			begin
				time_cntr_ns = time_cntr + 12'b1;
			end
			else
			begin 
				next_KBD_CLK = low;
				time_cntr_ns = 12'b0;
				nxt1_st = low40u_ST;
			end
		end	

		low40u_ST: 
		begin
//--------------
			if (time_cntr_ns < delay40usec) 
			begin
				time_cntr_ns = time_cntr + 12'b1;
			end
			else
			begin 
				next_KBD_CLK = high;
				time_cntr_ns = 12'b0;
				nxt1_st = high40u_ST;
			end
		end
		
		high40u_ST: 
		begin
//--------------
			if (time_cntr_ns < delay40usec) 
			begin
				time_cntr_ns = time_cntr + 12'b1;
			end
			else
			begin 
				if (basic_cycles_cntr_ns < KBD_clk_cycles - 1) 
				begin
					basic_cycles_cntr_ns = basic_cycles_cntr + 4'b1;
					time_cntr_ns = 12'b0;
					next_KBD_CLK = low;
					nxt1_st = low40u_ST;
				end
				else
				begin
			nxt1_st = IDLE1_ST;
					next_KBD_CLK = high;
//					basic_cycles_cntr_ns = 4'b0;
//					time_cntr_ns = 12'b0;
				end
			end
		end  
			
	endcase
end

//endmodule	
				

//-- Avraham Kaplan March 2020


//module Data_Trnsmtr_1	(	

//	input	logic	clk,
//	input	logic	resetN,
//	input	logic	triggerN,  // initialize KBD_CLK cycle (11  basic cycles of 80usec each)
//	input	logic	[8:0] Data_in,
	
//	output logic KBD_DAT// ----|_|X|X|X|X|X|X|X|X|X|-|------ 
									 
//);

enum  logic [1:0] {IDLE2_ST, // initial state
				  Data_Trnsmt_ST, // after triggerN 
				  wait80u_ST // after wait20u or high40u  
				  }  nxt2_st, cur2_st;


//parameter int delay80usec = 8;
localparam int Data_bits = 11;

//const logic	low	= 1'b0;
//const logic	high =1'b1; 
logic [8:0] Data, Data_ns; 
logic [12:0] time1_cntr, time1_cntr_ns; 
logic [3:0] Data_bit_index, Data_bit_index_ns; 
logic next_KBD_DAT;

//======--------------------------------------------------------------------------------------------------------------=
always_ff @(posedge clk or negedge resetN)
begin 
	if(!resetN) 
	begin
		cur2_st <= IDLE2_ST; 
		KBD_DAT <= high;
		Data_bit_index <= 4'b0;
		time1_cntr <= 13'b0;
	end
	else 
	begin 
		cur2_st <= nxt2_st;
		Data_bit_index <= Data_bit_index_ns ; 
		time1_cntr <= time1_cntr_ns;
		KBD_DAT <= next_KBD_DAT  ; 
		Data <= Data_ns;
	end ; 
end

always_comb 
begin
	// default values 
	nxt2_st = cur2_st ;
	Data_bit_index_ns = Data_bit_index;   
	time1_cntr_ns = time1_cntr;
	next_KBD_DAT = KBD_DAT ; 
//	Data_ns = Data;

	case(cur2_st)
		IDLE2_ST: 
		begin
//--------------
			next_KBD_DAT = high;
			Data_bit_index_ns = 4'b0;
			time1_cntr_ns = 13'b0;
			if( triggerN == 1'b0)
			begin			
				next_KBD_DAT = low;
				time1_cntr_ns = 13'b0;
				nxt2_st = Data_Trnsmt_ST;
			end
		end  
			
		Data_Trnsmt_ST: 
		begin
//--------------
//			case(Data_bit_index_ns)
			case(Data_bit_index)
				0:
				begin
					next_KBD_DAT = low;
					nxt2_st = wait80u_ST;
				end
				1,2,3,4,5,6,7,8,9:
				begin
//					next_KBD_DAT = Data_ns[Data_bit_index_ns - 1];
					next_KBD_DAT = Data[Data_bit_index - 1];
					nxt2_st = wait80u_ST;
				end 
				10:
				begin
					next_KBD_DAT = high;
					nxt2_st = wait80u_ST;
				end
				default:
				begin
					nxt2_st = IDLE2_ST;
				end
			endcase	
		end	

		wait80u_ST: 
		begin
//--------------
			if (time1_cntr_ns < delay80usec) 
			begin
				time1_cntr_ns = time1_cntr + 13'b1;
			end
			else
			begin 
				time1_cntr_ns = 13'b0;
				Data_bit_index_ns = Data_bit_index + 4'b1;				
				nxt2_st = Data_Trnsmt_ST;
			end
		end
		
	endcase
end

endmodule	
				

				



