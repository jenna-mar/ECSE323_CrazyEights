-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 64-Bit"
-- VERSION		"Version 13.0.0 Build 156 04/24/2013 SJ Web Edition"
-- CREATED		"Mon Apr 10 17:24:11 2017"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY g52_lab5 IS 
	PORT
	(
		PLAY :  IN  STD_LOGIC;
		scroll_up :  IN  STD_LOGIC;
		scroll_down :  IN  STD_LOGIC;
		CLK :  IN  STD_LOGIC;
		RESET :  IN  STD_LOGIC;
		display_select :  IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
		disp_0 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		disp_1 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		disp_2 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		disp_3 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END g52_lab5;

ARCHITECTURE bdf_type OF g52_lab5 IS 

COMPONENT g52_crazyeightsgamesystem
	PORT(play : IN STD_LOGIC;
		 scroll_up : IN STD_LOGIC;
		 scroll_down : IN STD_LOGIC;
		 CLK : IN STD_LOGIC;
		 RESET : IN STD_LOGIC;
		 display_select : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 display_0_code : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		 display_1_code : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		 display_2_code : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		 display_3_code : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;



BEGIN 



b2v_inst1 : g52_crazyeightsgamesystem
PORT MAP(play => PLAY,
		 scroll_up => scroll_up,
		 scroll_down => scroll_down,
		 CLK => CLK,
		 RESET => RESET,
		 display_select => display_select,
		 display_0_code => disp_0,
		 display_1_code => disp_1,
		 display_2_code => disp_2,
		 display_3_code => disp_3);


END bdf_type;