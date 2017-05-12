-- user interface circuit --
-- entity name: g52_UI
--
-- Copyright (C) 2017 Jenna Mar
-- Version 1.0
-- Author: Jenna Mar; jenna.mar@mail.mcgill.ca
-- Date: 2017/03/31

library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity g52_UI is
	port ( RESET				: in std_logic ; -- starts a new game
			 CLK					: in std_logic ; --the clock
			 play					: in std_logic ; -- plays the selected card
			 scroll_up			: in std_logic ; -- selects card to play (up)
			 scroll_down 		: in std_logic ; -- selects card to play (down)
			 display_select	: in std_logic_vector(4 downto 0); --switches to select display;
			 
			 TURN 				: in std_logic; --represents if human's turn or not
			 play_pile_top_card : in std_logic_vector(5 downto 0); --card on top of the play pile
			 
			 card_to_play		: in std_logic_vector(5 downto 0); --current selected card in player's hand
			 num_hum				: in std_logic_vector(4 downto 0); --number of cards in the (human) player's hand
			 
			 num_comp			: in std_logic_vector(4 downto 0); --number of cards in the computer's hand
			 num_deck			: in std_logic_vector(5 downto 0); --number of cards remaining in deck
			 
			 game_over			: in std_logic; --if game is over (1 = over)
			 winner				: in std_logic_vector(1 downto 0); --who the winner is (01 = player, 10 = computer, 00 = draw);
			 
			 card_addr			: out std_logic_vector(5 downto 0); --address of card in hand for access
			 request_deal		: out std_logic; --to request a deal/draw
			 done 				: out std_logic;
			 MODE					: out std_logic_vector(1 downto 0);--mode for player stack/deck
			 display_0_mode	: out std_logic;	--displays
			 display_0_code 	: out std_logic_vector(3 downto 0);
			 display_1_mode	: out std_logic;
			 display_1_code	: out std_logic_vector(3 downto 0);
			 display_2_code	: out std_logic_vector(6 downto 0); --switch to 7 segment format for last 2 displays
			 display_3_code	: out std_logic_vector(6 downto 0)) ;
end g52_UI;

architecture arch of g52_UI is
	
	type State_type is (A,B,C,D,E,F,G,H,I,J,K,L);
	signal y : State_type;
	signal card_addr_in : std_logic_vector(5 downto 0);
	
	signal num_c_hum : std_logic_vector(5 downto 0);
	signal num_c_com : std_logic_vector(5 downto 0);
	
	signal num_hum_prev : std_logic_vector(4 downto 0);
	
	signal display_select_in : std_logic_vector(5 downto 0);
	
	signal pptc_suit : std_logic_vector(3 downto 0); --play pile top card
	signal pptc_face : std_logic_vector(3 downto 0);
	signal ctp_suit : std_logic_vector(3 downto 0); --card to play
	signal ctp_face : std_logic_vector(3 downto 0);
	signal chp_ones : std_logic_vector(3 downto 0); --cards in player's hand
	signal chp_tens : std_logic_vector(3 downto 0);
	signal ccp_ones : std_logic_vector(3 downto 0); --cards in computer's hand
	signal ccp_tens : std_logic_vector(3 downto 0);	
	signal cdk_ones : std_logic_vector(3 downto 0); --cards in deck
	signal cdk_tens : std_logic_vector(3 downto 0);
	
	signal legal_play : std_logic; --for checking validity of play
	
	component g52_mod13
		port (
		value : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		mod13 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		floor : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	end component;
	
	component g52_mod10
		port (
		value : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		mod10 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		floor : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	end component;
	
	component g52_rules
		port (
			play_pile_top_card : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			card_to_play 		 : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			legal_play 			 : OUT STD_LOGIC
			);
	end component;
	
BEGIN
	
	num_c_com(4 downto 0) <= num_comp;
	num_c_com(5) <= '0';
	
	num_c_hum(4 downto 0) <= num_hum;
	num_c_hum(5) <= '0';
	
	pptc : g52_mod13
		PORT MAP (
		value => play_pile_top_card,
		mod13 => pptc_face,
		floor => pptc_suit
	);
	
	ctp : g52_mod13
		PORT MAP (
		value => card_to_play,
		mod13 => ctp_face,
		floor => ctp_suit
	);
	
	hpc : g52_mod10
		PORT MAP (
			value => num_c_hum,
			mod10 => chp_ones,
			floor => chp_tens
	);	

	cpc : g52_mod10
		PORT MAP (
		value => num_c_com,
		mod10 => ccp_ones,
		floor => ccp_tens
	);
	
	cdck : g52_mod10
		PORT MAP (
		value => num_deck,
		mod10 => cdk_ones,
		floor => cdk_tens
	);
	
	prules : g52_rules
		PORT MAP (
			play_pile_top_card => play_pile_top_card,
			card_to_play => card_to_play,
			legal_play => legal_play
		);
		
	process(CLK,RESET)
	begin
		if RESET = '1' then
			display_2_code <= "1111111";
			display_3_code <= "1111111";
			display_select_in <= "000000";
			y <= A;
		elsif clk'event and clk = '1' then
			if game_over = '1' then
				display_3_code <= "1000010"; --"G"
				display_2_code <= "1000000"; --"O"
				if winner = "10" then --computer winner
					display_select_in <= "100000";
				elsif winner = "01" then --player winner
					display_select_in <= "100001";
				else
					display_select_in <= "111111";
				end if;
			else 
				if turn = '0' then
					display_3_code <= "0111111"; --computer's turn
				else
					display_3_code <= "1111001"; --player's turn
				end if;
				
				if legal_play = '0' and display_select = "00010" then --for displaying legality of card
					display_2_code <= "0111111";
				else
					display_2_code <= "1111111";
				end if;
				
				display_select_in(4 downto 0) <= display_select;
				display_select_in(5) <= '0';
			end if;
			
			case y is 
				when A => --for initialization
					if num_hum = "00111" then --filled
						y <= B;
					end if;
				when B =>
					card_addr_in <= "000000";
					if TURN = '1' then --turn
						y <= C;
					end if;
				when C =>
					if play = '0' then --any button is pressed
							y <= D;
					elsif scroll_up = '0' then
							y <= G;
					elsif scroll_down = '0' then
							y <= I;
					end if;
				
				when D => --want to play card
					if play = '1' then --released button
						y <= E;
					end if;
				when E => --finished play signal
					if legal_play = '1' then
						y <= F;
					else 
						y <= K; --draw a card
					end if;
				when F =>
					y <= B;				
				when G =>
					if scroll_up = '1' then --released
						y <= H;
					end if;
				when H => --want to scroll up
					if card_addr_in > "000000" then
						card_addr_in <= std_logic_vector(to_unsigned(to_integer(unsigned(card_addr_in)) - 1,6));
					end if;
					y <= C;
				when I =>
					if scroll_down = '1' then --released
						y <= J;
					end if;
				when J =>
					if card_addr_in < num_c_hum then
						card_addr_in <= std_logic_vector(to_unsigned(to_integer(unsigned(card_addr_in)) + 1,6));
					end if;
					y <= C;
				when K =>
					y <= L; --draw a card
				when L => --push the card
					if num_hum > num_hum_prev then --card added
						y <= B;
					end if;
			end case;				
		end if;		
	end process;
	
	card_addr <= card_addr_in;
	
	with y select
		request_deal <= '0' when K,
							 '1' when others;
	
	with y select
		done <= '1' when F,
				  '1' when K,
				  '1' when L,
				  '1' when A,
				  '1' when B,
				  '0' when others;
	with y select
		MODE <= "11" when F,
				  "10" when A, --for init
				  "10" when L, --for getting a card
				  "01" when others;
	
	with y select
		num_hum_prev <= num_hum when A, 
							 num_hum when K,
							 num_hum_prev when others;
	
	with display_select_in select
		display_0_mode <= 
			'0' when "000100", --number of cards in (human) player's hand
			'0' when "001000", --number of cards in computer's hand
			'0' when "010000", --number of cards in deck
			'1' when others;
	with display_select_in select
		display_0_code <= 
			pptc_face when "000001", --card on top of the play pile
			ctp_face when "000010", --selected card in (human) player's hand
			chp_ones when "000100", --number of cards in (human) player's hand
			ccp_ones when "001000", --number of cards in computer's hand
			cdk_ones when "010000", --number of cards in deck
			"1100" when "100000", --display computer winner
			"1101" when "100001", --display player as winner
			"1111" when others;
	

	with display_select_in select
		display_1_mode <= 
			'0' when "000001",
			'0' when "000010",
			'0' when "000100",
			'0' when "001000",
			'0' when "010000",
			'1' when others;	
	with display_select_in select
			display_1_code <= 
			pptc_suit when "000001", --card on top of the play pile
			ctp_suit when "000010", --selected card in (human) player's hand
			chp_tens when "000100", --number of cards in (human) player's hand
			ccp_tens when "001000", --number of cards in computer's hand
			cdk_tens when "010000", --number of cards in deck
			"1111" when others;
	
end arch;	