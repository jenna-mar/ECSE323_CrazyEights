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
-- CREATED		"Mon Apr 10 17:23:35 2017"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY g52_crazyeightsgamesystem IS 
	PORT
	(
		CLK :  IN  STD_LOGIC;
		RESET :  IN  STD_LOGIC;
		scroll_down :  IN  STD_LOGIC;
		scroll_up :  IN  STD_LOGIC;
		play :  IN  STD_LOGIC;
		display_select :  IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
		display_0_code :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		display_1_code :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		display_2_code :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		display_3_code :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END g52_crazyeightsgamesystem;

ARCHITECTURE bdf_type OF g52_crazyeightsgamesystem IS 

COMPONENT g52_stack26
	PORT(ENABLE : IN STD_LOGIC;
		 RST : IN STD_LOGIC;
		 CLK : IN STD_LOGIC;
		 ADDR : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 DATA : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 MODE : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 P_EN : IN STD_LOGIC_VECTOR(51 DOWNTO 0);
		 EMPTY : OUT STD_LOGIC;
		 FULL : OUT STD_LOGIC;
		 NUM : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 VALUE : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
	);
END COMPONENT;

COMPONENT g52_dealer
	PORT(request_deal : IN STD_LOGIC;
		 rand_lt_num : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 rand_enable : OUT STD_LOGIC;
		 stack_enable : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT g52_7_segment_decoder
	PORT(mode : IN STD_LOGIC;
		 code : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 segments_out : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

COMPONENT g52_computer
	PORT(TURN : IN STD_LOGIC;
		 CLK : IN STD_LOGIC;
		 RESET : IN STD_LOGIC;
		 card_to_play : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 num_hand : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 play_pile_top_card : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 request_deal : OUT STD_LOGIC;
		 DONE : OUT STD_LOGIC;
		 MODE : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 num_card_to_play : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
	);
END COMPONENT;

COMPONENT lpm_compare0
	PORT(dataa : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 datab : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 alb : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT g52_stack52
	PORT(ENABLE : IN STD_LOGIC;
		 RST : IN STD_LOGIC;
		 CLK : IN STD_LOGIC;
		 ADDR : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 DATA : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 MODE : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 P_EN : IN STD_LOGIC_VECTOR(51 DOWNTO 0);
		 EMPTY : OUT STD_LOGIC;
		 FULL : OUT STD_LOGIC;
		 NUM : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
		 VALUE : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
	);
END COMPONENT;

COMPONENT g52_reg6_pp
	PORT(turn_H : IN STD_LOGIC;
		 turn_C : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 rst : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 value_c : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 value_deck : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 value_h : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 play_pile_top_card : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
	);
END COMPONENT;

COMPONENT g52_system_controller
	PORT(CLK : IN STD_LOGIC;
		 RESET : IN STD_LOGIC;
		 done_player : IN STD_LOGIC;
		 done_computer : IN STD_LOGIC;
		 rqt_deal_h : IN STD_LOGIC;
		 rqt_deal_comp : IN STD_LOGIC;
		 addr_com_deck : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 addr_deck : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 addr_hum_deck : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 num_com : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 num_deck : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 num_hum : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 play_pile_top_card : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 enable_stack_deck : OUT STD_LOGIC;
		 enable_pp : OUT STD_LOGIC;
		 enable_comp_deck : OUT STD_LOGIC;
		 enable_hum_deck : OUT STD_LOGIC;
		 request_deal : OUT STD_LOGIC;
		 game_over : OUT STD_LOGIC;
		 TURN_H : OUT STD_LOGIC;
		 TURN_C : OUT STD_LOGIC;
		 MODE : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 P_EN : OUT STD_LOGIC_VECTOR(51 DOWNTO 0);
		 winner : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT g52_ui
	PORT(RESET : IN STD_LOGIC;
		 CLK : IN STD_LOGIC;
		 play : IN STD_LOGIC;
		 scroll_up : IN STD_LOGIC;
		 scroll_down : IN STD_LOGIC;
		 TURN : IN STD_LOGIC;
		 game_over : IN STD_LOGIC;
		 card_to_play : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 display_select : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 num_comp : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 num_deck : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 num_hum : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 play_pile_top_card : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 winner : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 request_deal : OUT STD_LOGIC;
		 done : OUT STD_LOGIC;
		 display_0_mode : OUT STD_LOGIC;
		 display_1_mode : OUT STD_LOGIC;
		 card_addr : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
		 display_0_code : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 display_1_code : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 display_2_code : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		 display_3_code : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		 MODE : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT g52_randu_en
	PORT(rand_enable : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 rst : IN STD_LOGIC;
		 seed_prev : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 seed : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT g52_reg6_rand
	PORT(enable : IN STD_LOGIC;
		 rst : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 rand : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 q : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
	);
END COMPONENT;

COMPONENT g52_randu
	PORT(seed : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 rand : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	DATA :  STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL	rand :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_65 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_66 :  STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_67 :  STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_68 :  STD_LOGIC_VECTOR(51 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_69 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_70 :  STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_71 :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_72 :  STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_73 :  STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_19 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_74 :  STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_22 :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_75 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_26 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_76 :  STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_31 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_32 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_34 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_35 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_36 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_37 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_77 :  STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_78 :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_47 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_53 :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_54 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_56 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_58 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_62 :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_64 :  STD_LOGIC_VECTOR(31 DOWNTO 0);


BEGIN 
SYNTHESIZED_WIRE_56 <= '1';



b2v_comp_hand : g52_stack26
PORT MAP(ENABLE => SYNTHESIZED_WIRE_0,
		 RST => SYNTHESIZED_WIRE_65,
		 CLK => CLK,
		 ADDR => SYNTHESIZED_WIRE_66,
		 DATA => SYNTHESIZED_WIRE_67,
		 MODE => SYNTHESIZED_WIRE_4,
		 P_EN => SYNTHESIZED_WIRE_68,
		 NUM => SYNTHESIZED_WIRE_71,
		 VALUE => SYNTHESIZED_WIRE_70);


b2v_dealer : g52_dealer
PORT MAP(request_deal => SYNTHESIZED_WIRE_6,
		 rand_lt_num => SYNTHESIZED_WIRE_7,
		 reset => SYNTHESIZED_WIRE_65,
		 clk => CLK,
		 rand_enable => SYNTHESIZED_WIRE_54,
		 stack_enable => SYNTHESIZED_WIRE_31);


b2v_display_one : g52_7_segment_decoder
PORT MAP(mode => SYNTHESIZED_WIRE_9,
		 code => SYNTHESIZED_WIRE_10,
		 segments_out => display_1_code);


b2v_display_zero : g52_7_segment_decoder
PORT MAP(mode => SYNTHESIZED_WIRE_11,
		 code => SYNTHESIZED_WIRE_12,
		 segments_out => display_0_code);


b2v_inst : g52_computer
PORT MAP(TURN => SYNTHESIZED_WIRE_69,
		 CLK => CLK,
		 RESET => SYNTHESIZED_WIRE_65,
		 card_to_play => SYNTHESIZED_WIRE_70,
		 num_hand => SYNTHESIZED_WIRE_71,
		 play_pile_top_card => SYNTHESIZED_WIRE_72,
		 request_deal => SYNTHESIZED_WIRE_37,
		 DONE => SYNTHESIZED_WIRE_35,
		 MODE => SYNTHESIZED_WIRE_4,
		 num_card_to_play => SYNTHESIZED_WIRE_66);


b2v_inst10 : lpm_compare0
PORT MAP(dataa => rand(31 DOWNTO 26),
		 datab => SYNTHESIZED_WIRE_73,
		 alb => SYNTHESIZED_WIRE_7);


b2v_inst17 : g52_stack52
PORT MAP(ENABLE => SYNTHESIZED_WIRE_19,
		 RST => SYNTHESIZED_WIRE_65,
		 CLK => CLK,
		 ADDR => SYNTHESIZED_WIRE_74,
		 DATA => DATA,
		 MODE => SYNTHESIZED_WIRE_22,
		 P_EN => SYNTHESIZED_WIRE_68,
		 NUM => SYNTHESIZED_WIRE_73,
		 VALUE => SYNTHESIZED_WIRE_67);



b2v_inst2 : g52_reg6_pp
PORT MAP(turn_H => SYNTHESIZED_WIRE_75,
		 turn_C => SYNTHESIZED_WIRE_69,
		 enable => SYNTHESIZED_WIRE_26,
		 rst => SYNTHESIZED_WIRE_65,
		 clk => CLK,
		 value_c => SYNTHESIZED_WIRE_70,
		 value_deck => SYNTHESIZED_WIRE_67,
		 value_h => SYNTHESIZED_WIRE_76,
		 play_pile_top_card => SYNTHESIZED_WIRE_72);


SYNTHESIZED_WIRE_19 <= SYNTHESIZED_WIRE_31 OR SYNTHESIZED_WIRE_32;



b2v_inst24 : g52_system_controller
PORT MAP(CLK => CLK,
		 RESET => SYNTHESIZED_WIRE_65,
		 done_player => SYNTHESIZED_WIRE_34,
		 done_computer => SYNTHESIZED_WIRE_35,
		 rqt_deal_h => SYNTHESIZED_WIRE_36,
		 rqt_deal_comp => SYNTHESIZED_WIRE_37,
		 addr_com_deck => SYNTHESIZED_WIRE_66,
		 addr_deck => SYNTHESIZED_WIRE_74,
		 addr_hum_deck => SYNTHESIZED_WIRE_77,
		 num_com => SYNTHESIZED_WIRE_71,
		 num_deck => SYNTHESIZED_WIRE_73,
		 num_hum => SYNTHESIZED_WIRE_78,
		 play_pile_top_card => SYNTHESIZED_WIRE_72,
		 enable_stack_deck => SYNTHESIZED_WIRE_32,
		 enable_pp => SYNTHESIZED_WIRE_26,
		 enable_comp_deck => SYNTHESIZED_WIRE_0,
		 enable_hum_deck => SYNTHESIZED_WIRE_58,
		 request_deal => SYNTHESIZED_WIRE_6,
		 game_over => SYNTHESIZED_WIRE_47,
		 TURN_H => SYNTHESIZED_WIRE_75,
		 TURN_C => SYNTHESIZED_WIRE_69,
		 MODE => SYNTHESIZED_WIRE_22,
		 P_EN => SYNTHESIZED_WIRE_68,
		 winner => SYNTHESIZED_WIRE_53);


b2v_inst3 : g52_ui
PORT MAP(RESET => SYNTHESIZED_WIRE_65,
		 CLK => CLK,
		 play => play,
		 scroll_up => scroll_up,
		 scroll_down => scroll_down,
		 TURN => SYNTHESIZED_WIRE_75,
		 game_over => SYNTHESIZED_WIRE_47,
		 card_to_play => SYNTHESIZED_WIRE_76,
		 display_select => display_select,
		 num_comp => SYNTHESIZED_WIRE_71,
		 num_deck => SYNTHESIZED_WIRE_73,
		 num_hum => SYNTHESIZED_WIRE_78,
		 play_pile_top_card => SYNTHESIZED_WIRE_72,
		 winner => SYNTHESIZED_WIRE_53,
		 request_deal => SYNTHESIZED_WIRE_36,
		 done => SYNTHESIZED_WIRE_34,
		 display_0_mode => SYNTHESIZED_WIRE_11,
		 display_1_mode => SYNTHESIZED_WIRE_9,
		 card_addr => SYNTHESIZED_WIRE_77,
		 display_0_code => SYNTHESIZED_WIRE_12,
		 display_1_code => SYNTHESIZED_WIRE_10,
		 display_2_code => display_2_code,
		 display_3_code => display_3_code,
		 MODE => SYNTHESIZED_WIRE_62);


SYNTHESIZED_WIRE_65 <= NOT(RESET);



b2v_inst7 : g52_randu_en
PORT MAP(rand_enable => SYNTHESIZED_WIRE_54,
		 clk => CLK,
		 rst => SYNTHESIZED_WIRE_65,
		 seed_prev => rand,
		 seed => SYNTHESIZED_WIRE_64);


b2v_inst9 : g52_reg6_rand
PORT MAP(enable => SYNTHESIZED_WIRE_56,
		 rst => SYNTHESIZED_WIRE_65,
		 clk => CLK,
		 rand => rand,
		 q => SYNTHESIZED_WIRE_74);


b2v_player_hand : g52_stack26
PORT MAP(ENABLE => SYNTHESIZED_WIRE_58,
		 RST => SYNTHESIZED_WIRE_65,
		 CLK => CLK,
		 ADDR => SYNTHESIZED_WIRE_77,
		 DATA => SYNTHESIZED_WIRE_67,
		 MODE => SYNTHESIZED_WIRE_62,
		 P_EN => SYNTHESIZED_WIRE_68,
		 NUM => SYNTHESIZED_WIRE_78,
		 VALUE => SYNTHESIZED_WIRE_76);


b2v_RANDU : g52_randu
PORT MAP(seed => SYNTHESIZED_WIRE_64,
		 rand => rand);


DATA <= "000000";
END bdf_type;