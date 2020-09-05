-- Copyright (C) 2017  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel MegaCore Function License Agreement, or other 
-- applicable license agreement, including, without limitation, 
-- that your use is for the sole purpose of programming logic 
-- devices manufactured by Intel and sold by Intel or its 
-- authorized distributors.  Please refer to the applicable 
-- agreement for further details.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "09/03/2020 16:43:56"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          BIRD_TOP
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

PACKAGE BIRD_TOP_data_type IS 
TYPE drawCoordinates_10_0_type IS ARRAY (10 DOWNTO 0) OF STD_LOGIC;
TYPE drawCoordinates_10_0_1_0_type IS ARRAY (1 DOWNTO 0) OF drawCoordinates_10_0_type;
SUBTYPE drawCoordinates_type IS drawCoordinates_10_0_1_0_type;
END BIRD_TOP_data_type;

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

library work;
use work.BIRD_TOP_data_type.all;

ENTITY BIRD_TOP_vhd_vec_tst IS
END BIRD_TOP_vhd_vec_tst;
ARCHITECTURE BIRD_TOP_arch OF BIRD_TOP_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL SingleHitPulse_birds : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL bird_alive : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL bird_life : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL bird_speed : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL birdsBusRequest : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL birdsCoordinates[0][0][0] : STD_LOGIC;
SIGNAL birdsCoordinates[0][0][1] : STD_LOGIC;
SIGNAL birdsCoordinates[0][0][2] : STD_LOGIC;
SIGNAL birdsCoordinates[0][0][3] : STD_LOGIC;
SIGNAL birdsCoordinates[0][0][4] : STD_LOGIC;
SIGNAL birdsCoordinates[0][0][5] : STD_LOGIC;
SIGNAL birdsCoordinates[0][0][6] : STD_LOGIC;
SIGNAL birdsCoordinates[0][0][7] : STD_LOGIC;
SIGNAL birdsCoordinates[0][0][8] : STD_LOGIC;
SIGNAL birdsCoordinates[0][0][9] : STD_LOGIC;
SIGNAL birdsCoordinates[0][0][10] : STD_LOGIC;
SIGNAL birdsCoordinates[0][1][0] : STD_LOGIC;
SIGNAL birdsCoordinates[0][1][1] : STD_LOGIC;
SIGNAL birdsCoordinates[0][1][2] : STD_LOGIC;
SIGNAL birdsCoordinates[0][1][3] : STD_LOGIC;
SIGNAL birdsCoordinates[0][1][4] : STD_LOGIC;
SIGNAL birdsCoordinates[0][1][5] : STD_LOGIC;
SIGNAL birdsCoordinates[0][1][6] : STD_LOGIC;
SIGNAL birdsCoordinates[0][1][7] : STD_LOGIC;
SIGNAL birdsCoordinates[0][1][8] : STD_LOGIC;
SIGNAL birdsCoordinates[0][1][9] : STD_LOGIC;
SIGNAL birdsCoordinates[0][1][10] : STD_LOGIC;
SIGNAL birdsCoordinates[1][0][0] : STD_LOGIC;
SIGNAL birdsCoordinates[1][0][1] : STD_LOGIC;
SIGNAL birdsCoordinates[1][0][2] : STD_LOGIC;
SIGNAL birdsCoordinates[1][0][3] : STD_LOGIC;
SIGNAL birdsCoordinates[1][0][4] : STD_LOGIC;
SIGNAL birdsCoordinates[1][0][5] : STD_LOGIC;
SIGNAL birdsCoordinates[1][0][6] : STD_LOGIC;
SIGNAL birdsCoordinates[1][0][7] : STD_LOGIC;
SIGNAL birdsCoordinates[1][0][8] : STD_LOGIC;
SIGNAL birdsCoordinates[1][0][9] : STD_LOGIC;
SIGNAL birdsCoordinates[1][0][10] : STD_LOGIC;
SIGNAL birdsCoordinates[1][1][0] : STD_LOGIC;
SIGNAL birdsCoordinates[1][1][1] : STD_LOGIC;
SIGNAL birdsCoordinates[1][1][2] : STD_LOGIC;
SIGNAL birdsCoordinates[1][1][3] : STD_LOGIC;
SIGNAL birdsCoordinates[1][1][4] : STD_LOGIC;
SIGNAL birdsCoordinates[1][1][5] : STD_LOGIC;
SIGNAL birdsCoordinates[1][1][6] : STD_LOGIC;
SIGNAL birdsCoordinates[1][1][7] : STD_LOGIC;
SIGNAL birdsCoordinates[1][1][8] : STD_LOGIC;
SIGNAL birdsCoordinates[1][1][9] : STD_LOGIC;
SIGNAL birdsCoordinates[1][1][10] : STD_LOGIC;
SIGNAL birdsCoordinates[2][0][0] : STD_LOGIC;
SIGNAL birdsCoordinates[2][0][1] : STD_LOGIC;
SIGNAL birdsCoordinates[2][0][2] : STD_LOGIC;
SIGNAL birdsCoordinates[2][0][3] : STD_LOGIC;
SIGNAL birdsCoordinates[2][0][4] : STD_LOGIC;
SIGNAL birdsCoordinates[2][0][5] : STD_LOGIC;
SIGNAL birdsCoordinates[2][0][6] : STD_LOGIC;
SIGNAL birdsCoordinates[2][0][7] : STD_LOGIC;
SIGNAL birdsCoordinates[2][0][8] : STD_LOGIC;
SIGNAL birdsCoordinates[2][0][9] : STD_LOGIC;
SIGNAL birdsCoordinates[2][0][10] : STD_LOGIC;
SIGNAL birdsCoordinates[2][1][0] : STD_LOGIC;
SIGNAL birdsCoordinates[2][1][1] : STD_LOGIC;
SIGNAL birdsCoordinates[2][1][2] : STD_LOGIC;
SIGNAL birdsCoordinates[2][1][3] : STD_LOGIC;
SIGNAL birdsCoordinates[2][1][4] : STD_LOGIC;
SIGNAL birdsCoordinates[2][1][5] : STD_LOGIC;
SIGNAL birdsCoordinates[2][1][6] : STD_LOGIC;
SIGNAL birdsCoordinates[2][1][7] : STD_LOGIC;
SIGNAL birdsCoordinates[2][1][8] : STD_LOGIC;
SIGNAL birdsCoordinates[2][1][9] : STD_LOGIC;
SIGNAL birdsCoordinates[2][1][10] : STD_LOGIC;
SIGNAL birdsCoordinates[3][0][0] : STD_LOGIC;
SIGNAL birdsCoordinates[3][0][1] : STD_LOGIC;
SIGNAL birdsCoordinates[3][0][2] : STD_LOGIC;
SIGNAL birdsCoordinates[3][0][3] : STD_LOGIC;
SIGNAL birdsCoordinates[3][0][4] : STD_LOGIC;
SIGNAL birdsCoordinates[3][0][5] : STD_LOGIC;
SIGNAL birdsCoordinates[3][0][6] : STD_LOGIC;
SIGNAL birdsCoordinates[3][0][7] : STD_LOGIC;
SIGNAL birdsCoordinates[3][0][8] : STD_LOGIC;
SIGNAL birdsCoordinates[3][0][9] : STD_LOGIC;
SIGNAL birdsCoordinates[3][0][10] : STD_LOGIC;
SIGNAL birdsCoordinates[3][1][0] : STD_LOGIC;
SIGNAL birdsCoordinates[3][1][1] : STD_LOGIC;
SIGNAL birdsCoordinates[3][1][2] : STD_LOGIC;
SIGNAL birdsCoordinates[3][1][3] : STD_LOGIC;
SIGNAL birdsCoordinates[3][1][4] : STD_LOGIC;
SIGNAL birdsCoordinates[3][1][5] : STD_LOGIC;
SIGNAL birdsCoordinates[3][1][6] : STD_LOGIC;
SIGNAL birdsCoordinates[3][1][7] : STD_LOGIC;
SIGNAL birdsCoordinates[3][1][8] : STD_LOGIC;
SIGNAL birdsCoordinates[3][1][9] : STD_LOGIC;
SIGNAL birdsCoordinates[3][1][10] : STD_LOGIC;
SIGNAL birdsDrawingRequest : STD_LOGIC;
SIGNAL birdsRGB : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL clk : STD_LOGIC;
SIGNAL damage : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL deploy_bird : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL deploy_shit : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL drawCoordinates : drawCoordinates_type;
SIGNAL duty50 : STD_LOGIC;
SIGNAL random_number : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL resetN : STD_LOGIC;
SIGNAL startOfFrame : STD_LOGIC;
COMPONENT BIRD_TOP
	PORT (
	SingleHitPulse_birds : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	bird_alive : BUFFER STD_LOGIC_VECTOR(3 DOWNTO 0);
	bird_life : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	bird_speed : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	birdsBusRequest : BUFFER STD_LOGIC_VECTOR(3 DOWNTO 0);
	\birdsCoordinates[0][0][0]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[0][0][1]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[0][0][2]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[0][0][3]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[0][0][4]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[0][0][5]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[0][0][6]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[0][0][7]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[0][0][8]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[0][0][9]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[0][0][10]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[0][1][0]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[0][1][1]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[0][1][2]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[0][1][3]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[0][1][4]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[0][1][5]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[0][1][6]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[0][1][7]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[0][1][8]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[0][1][9]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[0][1][10]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[1][0][0]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[1][0][1]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[1][0][2]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[1][0][3]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[1][0][4]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[1][0][5]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[1][0][6]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[1][0][7]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[1][0][8]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[1][0][9]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[1][0][10]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[1][1][0]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[1][1][1]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[1][1][2]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[1][1][3]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[1][1][4]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[1][1][5]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[1][1][6]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[1][1][7]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[1][1][8]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[1][1][9]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[1][1][10]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[2][0][0]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[2][0][1]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[2][0][2]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[2][0][3]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[2][0][4]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[2][0][5]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[2][0][6]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[2][0][7]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[2][0][8]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[2][0][9]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[2][0][10]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[2][1][0]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[2][1][1]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[2][1][2]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[2][1][3]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[2][1][4]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[2][1][5]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[2][1][6]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[2][1][7]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[2][1][8]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[2][1][9]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[2][1][10]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[3][0][0]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[3][0][1]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[3][0][2]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[3][0][3]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[3][0][4]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[3][0][5]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[3][0][6]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[3][0][7]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[3][0][8]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[3][0][9]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[3][0][10]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[3][1][0]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[3][1][1]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[3][1][2]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[3][1][3]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[3][1][4]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[3][1][5]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[3][1][6]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[3][1][7]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[3][1][8]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[3][1][9]\ : BUFFER STD_LOGIC;
	\birdsCoordinates[3][1][10]\ : BUFFER STD_LOGIC;
	birdsDrawingRequest : BUFFER STD_LOGIC;
	birdsRGB : BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0);
	clk : IN STD_LOGIC;
	damage : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	deploy_bird : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	deploy_shit : BUFFER STD_LOGIC_VECTOR(3 DOWNTO 0);
	drawCoordinates : IN drawCoordinates_type;
	duty50 : IN STD_LOGIC;
	random_number : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	resetN : IN STD_LOGIC;
	startOfFrame : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : BIRD_TOP
	PORT MAP (
-- list connections between master ports and signals
	SingleHitPulse_birds => SingleHitPulse_birds,
	bird_alive => bird_alive,
	bird_life => bird_life,
	bird_speed => bird_speed,
	birdsBusRequest => birdsBusRequest,
	\birdsCoordinates[0][0][0]\ => birdsCoordinates[0][0][0],
	\birdsCoordinates[0][0][1]\ => birdsCoordinates[0][0][1],
	\birdsCoordinates[0][0][2]\ => birdsCoordinates[0][0][2],
	\birdsCoordinates[0][0][3]\ => birdsCoordinates[0][0][3],
	\birdsCoordinates[0][0][4]\ => birdsCoordinates[0][0][4],
	\birdsCoordinates[0][0][5]\ => birdsCoordinates[0][0][5],
	\birdsCoordinates[0][0][6]\ => birdsCoordinates[0][0][6],
	\birdsCoordinates[0][0][7]\ => birdsCoordinates[0][0][7],
	\birdsCoordinates[0][0][8]\ => birdsCoordinates[0][0][8],
	\birdsCoordinates[0][0][9]\ => birdsCoordinates[0][0][9],
	\birdsCoordinates[0][0][10]\ => birdsCoordinates[0][0][10],
	\birdsCoordinates[0][1][0]\ => birdsCoordinates[0][1][0],
	\birdsCoordinates[0][1][1]\ => birdsCoordinates[0][1][1],
	\birdsCoordinates[0][1][2]\ => birdsCoordinates[0][1][2],
	\birdsCoordinates[0][1][3]\ => birdsCoordinates[0][1][3],
	\birdsCoordinates[0][1][4]\ => birdsCoordinates[0][1][4],
	\birdsCoordinates[0][1][5]\ => birdsCoordinates[0][1][5],
	\birdsCoordinates[0][1][6]\ => birdsCoordinates[0][1][6],
	\birdsCoordinates[0][1][7]\ => birdsCoordinates[0][1][7],
	\birdsCoordinates[0][1][8]\ => birdsCoordinates[0][1][8],
	\birdsCoordinates[0][1][9]\ => birdsCoordinates[0][1][9],
	\birdsCoordinates[0][1][10]\ => birdsCoordinates[0][1][10],
	\birdsCoordinates[1][0][0]\ => birdsCoordinates[1][0][0],
	\birdsCoordinates[1][0][1]\ => birdsCoordinates[1][0][1],
	\birdsCoordinates[1][0][2]\ => birdsCoordinates[1][0][2],
	\birdsCoordinates[1][0][3]\ => birdsCoordinates[1][0][3],
	\birdsCoordinates[1][0][4]\ => birdsCoordinates[1][0][4],
	\birdsCoordinates[1][0][5]\ => birdsCoordinates[1][0][5],
	\birdsCoordinates[1][0][6]\ => birdsCoordinates[1][0][6],
	\birdsCoordinates[1][0][7]\ => birdsCoordinates[1][0][7],
	\birdsCoordinates[1][0][8]\ => birdsCoordinates[1][0][8],
	\birdsCoordinates[1][0][9]\ => birdsCoordinates[1][0][9],
	\birdsCoordinates[1][0][10]\ => birdsCoordinates[1][0][10],
	\birdsCoordinates[1][1][0]\ => birdsCoordinates[1][1][0],
	\birdsCoordinates[1][1][1]\ => birdsCoordinates[1][1][1],
	\birdsCoordinates[1][1][2]\ => birdsCoordinates[1][1][2],
	\birdsCoordinates[1][1][3]\ => birdsCoordinates[1][1][3],
	\birdsCoordinates[1][1][4]\ => birdsCoordinates[1][1][4],
	\birdsCoordinates[1][1][5]\ => birdsCoordinates[1][1][5],
	\birdsCoordinates[1][1][6]\ => birdsCoordinates[1][1][6],
	\birdsCoordinates[1][1][7]\ => birdsCoordinates[1][1][7],
	\birdsCoordinates[1][1][8]\ => birdsCoordinates[1][1][8],
	\birdsCoordinates[1][1][9]\ => birdsCoordinates[1][1][9],
	\birdsCoordinates[1][1][10]\ => birdsCoordinates[1][1][10],
	\birdsCoordinates[2][0][0]\ => birdsCoordinates[2][0][0],
	\birdsCoordinates[2][0][1]\ => birdsCoordinates[2][0][1],
	\birdsCoordinates[2][0][2]\ => birdsCoordinates[2][0][2],
	\birdsCoordinates[2][0][3]\ => birdsCoordinates[2][0][3],
	\birdsCoordinates[2][0][4]\ => birdsCoordinates[2][0][4],
	\birdsCoordinates[2][0][5]\ => birdsCoordinates[2][0][5],
	\birdsCoordinates[2][0][6]\ => birdsCoordinates[2][0][6],
	\birdsCoordinates[2][0][7]\ => birdsCoordinates[2][0][7],
	\birdsCoordinates[2][0][8]\ => birdsCoordinates[2][0][8],
	\birdsCoordinates[2][0][9]\ => birdsCoordinates[2][0][9],
	\birdsCoordinates[2][0][10]\ => birdsCoordinates[2][0][10],
	\birdsCoordinates[2][1][0]\ => birdsCoordinates[2][1][0],
	\birdsCoordinates[2][1][1]\ => birdsCoordinates[2][1][1],
	\birdsCoordinates[2][1][2]\ => birdsCoordinates[2][1][2],
	\birdsCoordinates[2][1][3]\ => birdsCoordinates[2][1][3],
	\birdsCoordinates[2][1][4]\ => birdsCoordinates[2][1][4],
	\birdsCoordinates[2][1][5]\ => birdsCoordinates[2][1][5],
	\birdsCoordinates[2][1][6]\ => birdsCoordinates[2][1][6],
	\birdsCoordinates[2][1][7]\ => birdsCoordinates[2][1][7],
	\birdsCoordinates[2][1][8]\ => birdsCoordinates[2][1][8],
	\birdsCoordinates[2][1][9]\ => birdsCoordinates[2][1][9],
	\birdsCoordinates[2][1][10]\ => birdsCoordinates[2][1][10],
	\birdsCoordinates[3][0][0]\ => birdsCoordinates[3][0][0],
	\birdsCoordinates[3][0][1]\ => birdsCoordinates[3][0][1],
	\birdsCoordinates[3][0][2]\ => birdsCoordinates[3][0][2],
	\birdsCoordinates[3][0][3]\ => birdsCoordinates[3][0][3],
	\birdsCoordinates[3][0][4]\ => birdsCoordinates[3][0][4],
	\birdsCoordinates[3][0][5]\ => birdsCoordinates[3][0][5],
	\birdsCoordinates[3][0][6]\ => birdsCoordinates[3][0][6],
	\birdsCoordinates[3][0][7]\ => birdsCoordinates[3][0][7],
	\birdsCoordinates[3][0][8]\ => birdsCoordinates[3][0][8],
	\birdsCoordinates[3][0][9]\ => birdsCoordinates[3][0][9],
	\birdsCoordinates[3][0][10]\ => birdsCoordinates[3][0][10],
	\birdsCoordinates[3][1][0]\ => birdsCoordinates[3][1][0],
	\birdsCoordinates[3][1][1]\ => birdsCoordinates[3][1][1],
	\birdsCoordinates[3][1][2]\ => birdsCoordinates[3][1][2],
	\birdsCoordinates[3][1][3]\ => birdsCoordinates[3][1][3],
	\birdsCoordinates[3][1][4]\ => birdsCoordinates[3][1][4],
	\birdsCoordinates[3][1][5]\ => birdsCoordinates[3][1][5],
	\birdsCoordinates[3][1][6]\ => birdsCoordinates[3][1][6],
	\birdsCoordinates[3][1][7]\ => birdsCoordinates[3][1][7],
	\birdsCoordinates[3][1][8]\ => birdsCoordinates[3][1][8],
	\birdsCoordinates[3][1][9]\ => birdsCoordinates[3][1][9],
	\birdsCoordinates[3][1][10]\ => birdsCoordinates[3][1][10],
	birdsDrawingRequest => birdsDrawingRequest,
	birdsRGB => birdsRGB,
	clk => clk,
	damage => damage,
	deploy_bird => deploy_bird,
	deploy_shit => deploy_shit,
	drawCoordinates => drawCoordinates,
	duty50 => duty50,
	random_number => random_number,
	resetN => resetN,
	startOfFrame => startOfFrame
	);

-- clk
t_prcs_clk: PROCESS
BEGIN
	clk <= '0';
WAIT;
END PROCESS t_prcs_clk;

-- resetN
t_prcs_resetN: PROCESS
BEGIN
	resetN <= '0';
WAIT;
END PROCESS t_prcs_resetN;

-- duty50
t_prcs_duty50: PROCESS
BEGIN
	duty50 <= '0';
WAIT;
END PROCESS t_prcs_duty50;

-- startOfFrame
t_prcs_startOfFrame: PROCESS
BEGIN
	startOfFrame <= '0';
WAIT;
END PROCESS t_prcs_startOfFrame;

-- drawCoordinates[1]
t_prcs_drawCoordinates_1: PROCESS
BEGIN
	drawCoordinates(1) <= '0';
WAIT;
END PROCESS t_prcs_drawCoordinates_1;

-- drawCoordinates[0]
t_prcs_drawCoordinates_0: PROCESS
BEGIN
	drawCoordinates(0) <= '0';
WAIT;
END PROCESS t_prcs_drawCoordinates_0;
-- random_number[7]
t_prcs_random_number_7: PROCESS
BEGIN
	random_number(7) <= '0';
WAIT;
END PROCESS t_prcs_random_number_7;
-- random_number[6]
t_prcs_random_number_6: PROCESS
BEGIN
	random_number(6) <= '0';
WAIT;
END PROCESS t_prcs_random_number_6;
-- random_number[5]
t_prcs_random_number_5: PROCESS
BEGIN
	random_number(5) <= '0';
WAIT;
END PROCESS t_prcs_random_number_5;
-- random_number[4]
t_prcs_random_number_4: PROCESS
BEGIN
	random_number(4) <= '0';
WAIT;
END PROCESS t_prcs_random_number_4;
-- random_number[3]
t_prcs_random_number_3: PROCESS
BEGIN
	random_number(3) <= '0';
WAIT;
END PROCESS t_prcs_random_number_3;
-- random_number[2]
t_prcs_random_number_2: PROCESS
BEGIN
	random_number(2) <= '0';
WAIT;
END PROCESS t_prcs_random_number_2;
-- random_number[1]
t_prcs_random_number_1: PROCESS
BEGIN
	random_number(1) <= '0';
WAIT;
END PROCESS t_prcs_random_number_1;
-- random_number[0]
t_prcs_random_number_0: PROCESS
BEGIN
	random_number(0) <= '0';
WAIT;
END PROCESS t_prcs_random_number_0;
-- SingleHitPulse_birds[3]
t_prcs_SingleHitPulse_birds_3: PROCESS
BEGIN
	SingleHitPulse_birds(3) <= '0';
WAIT;
END PROCESS t_prcs_SingleHitPulse_birds_3;
-- SingleHitPulse_birds[2]
t_prcs_SingleHitPulse_birds_2: PROCESS
BEGIN
	SingleHitPulse_birds(2) <= '0';
WAIT;
END PROCESS t_prcs_SingleHitPulse_birds_2;
-- SingleHitPulse_birds[1]
t_prcs_SingleHitPulse_birds_1: PROCESS
BEGIN
	SingleHitPulse_birds(1) <= '0';
WAIT;
END PROCESS t_prcs_SingleHitPulse_birds_1;
-- SingleHitPulse_birds[0]
t_prcs_SingleHitPulse_birds_0: PROCESS
BEGIN
	SingleHitPulse_birds(0) <= '0';
WAIT;
END PROCESS t_prcs_SingleHitPulse_birds_0;
-- bird_life[3]
t_prcs_bird_life_3: PROCESS
BEGIN
	bird_life(3) <= '0';
WAIT;
END PROCESS t_prcs_bird_life_3;
-- bird_life[2]
t_prcs_bird_life_2: PROCESS
BEGIN
	bird_life(2) <= '0';
WAIT;
END PROCESS t_prcs_bird_life_2;
-- bird_life[1]
t_prcs_bird_life_1: PROCESS
BEGIN
	bird_life(1) <= '0';
WAIT;
END PROCESS t_prcs_bird_life_1;
-- bird_life[0]
t_prcs_bird_life_0: PROCESS
BEGIN
	bird_life(0) <= '0';
WAIT;
END PROCESS t_prcs_bird_life_0;
-- bird_speed[1]
t_prcs_bird_speed_1: PROCESS
BEGIN
	bird_speed(1) <= '0';
WAIT;
END PROCESS t_prcs_bird_speed_1;
-- bird_speed[0]
t_prcs_bird_speed_0: PROCESS
BEGIN
	bird_speed(0) <= '0';
WAIT;
END PROCESS t_prcs_bird_speed_0;
-- damage[1]
t_prcs_damage_1: PROCESS
BEGIN
	damage(1) <= '0';
WAIT;
END PROCESS t_prcs_damage_1;
-- damage[0]
t_prcs_damage_0: PROCESS
BEGIN
	damage(0) <= '0';
WAIT;
END PROCESS t_prcs_damage_0;
-- deploy_bird[3]
t_prcs_deploy_bird_3: PROCESS
BEGIN
	deploy_bird(3) <= '0';
WAIT;
END PROCESS t_prcs_deploy_bird_3;
-- deploy_bird[2]
t_prcs_deploy_bird_2: PROCESS
BEGIN
	deploy_bird(2) <= '0';
WAIT;
END PROCESS t_prcs_deploy_bird_2;
-- deploy_bird[1]
t_prcs_deploy_bird_1: PROCESS
BEGIN
	deploy_bird(1) <= '0';
WAIT;
END PROCESS t_prcs_deploy_bird_1;
-- deploy_bird[0]
t_prcs_deploy_bird_0: PROCESS
BEGIN
	deploy_bird(0) <= '0';
WAIT;
END PROCESS t_prcs_deploy_bird_0;
END BIRD_TOP_arch;
