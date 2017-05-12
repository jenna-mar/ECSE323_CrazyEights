-- this circuit implements the computer player --
-- entity name: g52_computer
--
-- Copyright (C) 2017 Jenna Mar
-- Version 1.0
-- Author: Jenna Mar; jenna.mar@mail.mcgill.ca
-- Date: 2017/03/31

library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity g52_computer is
	port ( TURN 				  : in std_logic ;
			 CLK					  : in std_logic ;
			 RESET 				  : in std_logic ;
			 play_pile_top_card : in std_logic_vector(5 downto 0) ;
			 card_to_play		  : in std_logic_vector(5 downto 0) ; --card to play from computer's hand (stack)
			 num_hand			  : in std_logic_vector(4 downto 0) ; --number of cards in hand
			 MODE					  : out std_logic_vector(1 downto 0) ; --mode for stack
			 num_card_to_play	  : out std_logic_vector(5 downto 0) ; --address of the card to play (in stack)
			 request_deal		  : out std_logic ; --for requesting a card from the play deck;
			 DONE					  : out std_logic );
end g52_computer;

architecture arch of g52_computer is

type State_type is (A,B,C,D,E,F,G,H);
signal y : State_type;
signal legal_play : std_logic;
signal num_card_to_play_int : std_logic_vector(5 downto 0);
signal new_num_hand : std_logic_vector(5 downto 0);
signal num_hand_prev : std_logic_vector(4 downto 0);

component g52_rules
	port (
		play_pile_top_card : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		card_to_play 		 : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		legal_play 			 : OUT STD_LOGIC
		);
end component;

begin		

	rules : g52_rules
	PORT MAP (
	play_pile_top_card => play_pile_top_card,
	card_to_play => card_to_play,
	legal_play => legal_play
	);
	
	new_num_hand(4 downto 0) <= num_hand;
	new_num_hand(5) <= '0';
	
	process(CLK, RESET)
	begin
		if reset = '1' then
		y <= A;
		
		elsif clk'event and clk = '1' then
			case y is
				when A => --for initialization
					if num_hand = "00111" then --filled
						y <= B;
					end if;
				when B => --turn is low
					num_card_to_play_int <= "000000";
					if TURN = '1' then
						y <= C;
					end if;
				when C => --deassert DONE
						y <= D;
				when D => --check validity of cards
					if legal_play = '1' then
						y <= F;
					elsif num_card_to_play_int < new_num_hand then 
						--current card invalid
						y <= E;
					else --no valid card found
						y <= G;
					end if;
				when E => --increment and check validity again in state C
					if legal_play = '1' then
						y <= F;
					else
						num_card_to_play_int <= std_logic_vector(to_unsigned(to_integer(unsigned(num_card_to_play_int)) + 1,6));
						y <= D;
					end if;
				when F => --play valid card and assert DONE
					y <= B;
				when G => --take/request a card
					y <= H;
				when H =>
					if num_hand > num_hand_prev then --card added
						y <= B;
					end if;
			end case;
		end if;
	end process;
	
	with y select
		DONE <= '1' when A,
				  '1' when B,
				  '1' when F,
				  '1' when G,
				  '1' when H,
				  '0' when others;
				  
	with y select
		MODE <= "10" when A, --for init
				  "11" when F, --pop current card
				  "10" when H, --push a new card to hand from play deck
				  "01" when others; --"view" mode
	
	with y select
		request_deal <= '0' when G,
						    '1' when others;
							 
	with y select
		num_hand_prev <= num_hand when A, 
							  num_hand when G,
							  num_hand_prev when others;
							 
	num_card_to_play <= num_card_to_play_int;
									
end arch;