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
-- Generated on "04/10/2017 09:31:55"
                                                            
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
SIGNAL card_to_play : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL CLK : STD_LOGIC := '1';
SIGNAL done : STD_LOGIC;
SIGNAL mode : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL num_card_to_play : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL num_hand : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL TURN : STD_LOGIC;
SIGNAL play_pile_top_card : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL request_deal : STD_LOGIC;
SIGNAL RESET : STD_LOGIC;
COMPONENT g52_computer
	PORT (
	card_to_play : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
	CLK : IN STD_LOGIC;
	done : OUT STD_LOGIC;
	mode : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
	num_card_to_play : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
	num_hand : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	TURN : IN STD_LOGIC;
	play_pile_top_card : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
	request_deal : OUT STD_LOGIC;
	RESET : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : g52_computer
	PORT MAP (
-- list connections between master ports and signals
	card_to_play => card_to_play,
	CLK => CLK,
	done => done,
	mode => mode,
	num_card_to_play => num_card_to_play,
	num_hand => num_hand,
	TURN => TURN,
	play_pile_top_card => play_pile_top_card,
	request_deal => request_deal,
	RESET => RESET
	);
generate_test : PROCESS                                               
                        
BEGIN                                                        
		reset <= '0';
		wait for 10 ns;
		reset <= '1';
		wait for 10 ns;
		reset <= '0';
		play_pile_top_card <= "001010"; --card J spades
		card_to_play <= "000000"; -- first card A spades
		num_hand <= "00111"; --7 cards in hand
		TURN <= '0';
		wait for 15 ns;
		turn <= '1';
		wait for 40 ns;
		play_pile_top_card <= "100011"; --something not spades, not legal
		wait for 200 ns;
		--pretend to add a card
		num_hand <= "01000";
				
	WAIT;                                                       
END PROCESS generate_test;                                           

clock : PROCESS                                                                                 
BEGIN                                                         
 wait for 5 ns;
 clk <= not clk;                                                      
END PROCESS clock;     
                                     
END g52_lab5_arch;
