-- rules circuit--
-- entity name: g52_rules
--
-- Copyright (C) 2017 Jenna Mar
-- Version 1.0
-- Author: Jenna Mar; jenna.mar@mail.mcgill.ca
-- Date: 2017/03/20

library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;

entity g52_rules is
	port ( play_pile_top_card : in std_logic_vector(5 downto 0) ; --card on top of the play pile
			 card_to_play       : in std_logic_vector(5 downto 0) ; --card to be played
			 legal_play			  : out std_logic );
end g52_rules;

architecture arch of g52_rules is

signal top_card_no : std_logic_vector(3 downto 0);
signal top_card_suit : std_logic_vector(3 downto 0);
signal play_card_no : std_logic_vector(3 downto 0);
signal play_card_suit : std_logic_vector(3 downto 0);
signal legal_in : std_logic;

component g52_mod13
	port (
		value : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		mod13 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		floor : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
end component;

begin

	U1 : g52_mod13
		PORT MAP (
		value => play_pile_top_card,
		mod13 => top_card_no,
		floor => top_card_suit
		);
		
	U2 : g52_mod13
		PORT MAP (
		value => card_to_play,
		mod13 => play_card_no,
		floor => play_card_suit
		);

	process(top_card_no,play_card_no,top_card_suit,play_card_suit)
	begin
		legal_play <= '0';
		if play_card_no = "0111" then 
			legal_play <= '1';
		elsif top_card_no = "0111" then 
			legal_play <= '1';
		elsif play_card_suit = top_card_suit then 
			legal_play <= '1';
		elsif play_card_no = top_card_no then
			legal_play <= '1';
		end if;
	end process;
	
end arch;