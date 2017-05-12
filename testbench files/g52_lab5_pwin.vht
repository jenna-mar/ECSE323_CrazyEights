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

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "04/10/2017 10:11:35"
                                                            
-- Vhdl Test Bench template for design  :  g52_lab5
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY g52_lab5_vhd_tst IS
END g52_lab5_vhd_tst;
ARCHITECTURE g52_lab5_arch OF g52_lab5_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL CLK : STD_LOGIC := '1';
SIGNAL disp_0 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL disp_1 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL disp_2 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL disp_3 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL display_select : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL PLAY : STD_LOGIC;
SIGNAL RESET : STD_LOGIC;
SIGNAL scroll_down : STD_LOGIC;
SIGNAL scroll_up : STD_LOGIC;
COMPONENT g52_lab5
	PORT (
	CLK : IN STD_LOGIC;
	disp_0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
	disp_1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
	disp_2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
	disp_3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
	display_select : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	PLAY : IN STD_LOGIC;
	RESET : IN STD_LOGIC;
	scroll_down : IN STD_LOGIC;
	scroll_up : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : g52_lab5
	PORT MAP (
-- list connections between master ports and signals
	CLK => CLK,
	disp_0 => disp_0,
	disp_1 => disp_1,
	disp_2 => disp_2,
	disp_3 => disp_3,
	display_select => display_select,
	PLAY => PLAY,
	RESET => RESET,
	scroll_down => scroll_down,
	scroll_up => scroll_up
	);
generate_test : PROCESS                                               
	
BEGIN                                                        
   display_select <= "00010";
	play <= '1';
	scroll_down <= '1';
	scroll_up <= '1';
	RESET <= '1';
	wait for 10 ns;
	RESET <= '0';
	wait for 10 ns;
	RESET <= '1';
	wait for 1150 ns; --finished init
	scroll_down <= '0'; --examples of scrolling
	wait for 40 ns;
	scroll_down <= '1';
	wait for 70 ns;
	scroll_down <= '0';
	wait for 30 ns;
	scroll_down <= '1';
	wait for 70 ns;
	scroll_down <= '0';
	wait for 30 ns;
	scroll_down <= '1';
	wait for 70 ns;
	--now play
	play <= '0';
	wait for 10 ns;
	play <= '1';
----------
	wait for 300 ns;
	play <= '0';
	wait for 20 ns;
	play <= '1';
	---------
	wait for 300 ns;
	play <= '0';
	wait for 20 ns;
	play <= '1';
	---------
	wait for 350 ns;
	play <= '0';
	wait for 20 ns;
	play <= '1'; 
	----------
	wait for 200 ns;
	play <= '0';
	wait for 20 ns;
	play <= '1';
	--------------
	wait for 200 ns;
	scroll_down <= '0';
	wait for 40 ns;
	scroll_down <= '1';
	wait for 70 ns;
	scroll_down <= '0';
	wait for 30 ns;
	scroll_down <= '1';
	wait for 70 ns;
	
	play <= '0';
	wait for 20 ns;
	play <= '1';
	------------
	wait for 200 ns;
	scroll_down <= '0';
	wait for 40 ns;
	scroll_down <= '1';
	wait for 70 ns;
	scroll_down <= '0';
	wait for 30 ns;
	scroll_down <= '1';
	wait for 70 ns;
	
	play <= '0';
	wait for 20 ns;
	play <= '1';
	------------
	FOR i IN 0 to 9 LOOP
		wait for 400 ns;
		play <= '0';
		wait for 20 ns;
		play <= '1';
	END LOOP;
	
	------
	wait for 400 ns;
	scroll_down <= '0';
	wait for 40 ns;
	scroll_down <= '1';
	wait for 70 ns;
	play <= '0';
	wait for 20 ns;
	play <= '1';
	
	-----
	wait for 200 ns;
	scroll_down <= '0';
	wait for 40 ns;
	scroll_down <= '1';
	wait for 70 ns;
	scroll_down <= '0';
	wait for 40 ns;
	scroll_down <= '1';
	wait for 70 ns;
	scroll_down <= '0';
	wait for 40 ns;
	scroll_down <= '1';
	wait for 70 ns;
	scroll_down <= '0';
	wait for 40 ns;
	scroll_down <= '1';
	wait for 70 ns;
	play <= '0';
	wait for 20 ns;
	play <= '1';
	-------
	wait for 200 ns;
	scroll_down <= '0';
	wait for 40 ns;
	scroll_down <= '1';
	wait for 70 ns;
	scroll_down <= '0';
	wait for 40 ns;
	scroll_down <= '1';
	wait for 70 ns;
	scroll_down <= '0';
	wait for 40 ns;
	scroll_down <= '1';
	wait for 70 ns;
	play <= '0';
	wait for 20 ns;
	play <= '1';
	--------
	wait for 200 ns;
	scroll_down <= '0';
	wait for 40 ns;
	scroll_down <= '1';
	wait for 70 ns;
	play <= '0';
	wait for 20 ns;
	play <= '1';
	-------
	wait for 300 ns;
	play <= '0';
	wait for 20 ns;
	play <= '1';
	-------
	wait for 200 ns;
	scroll_down <= '0';
	wait for 40 ns;
	scroll_down <= '1';
	wait for 70 ns;
	play <= '0';
	wait for 20 ns;
	play <= '1';
	------
	wait for 200 ns;
	play <= '0';
	wait for 20 ns;
	play <= '1';
	------
	wait for 300 ns;
	play <= '0';
	wait for 20 ns;
	play <= '1';
	
	wait;                                                  
END PROCESS generate_test;  
                                         
clock : PROCESS                                                                                
BEGIN   
	wait for 5 ns;
	clk <= not clk;
END PROCESS clock;
                                   
END g52_lab5_arch;
