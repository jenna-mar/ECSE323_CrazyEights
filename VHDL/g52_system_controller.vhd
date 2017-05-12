-- this circuit implements the system controller FSM --
-- entity name: g52_system_controller
--
-- Copyright (C) 2017 Jenna Mar
-- Version 1.0
-- Author: Jenna Mar; jenna.mar@mail.mcgill.ca
-- Date: 2017/04/1

library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;

entity g52_system_controller is
	port ( CLK					  : in std_logic ;
			 RESET 				  : in std_logic ;
			 num_deck 			  : in std_logic_vector(5 downto 0);
			 num_hum				  : in std_logic_vector(4 downto 0);
			 num_com				  : in std_logic_vector(4 downto 0);
			 addr_deck			  : in std_logic_vector(5 downto 0); --address of the play deck stack (from random)
			 addr_com_deck		  : in std_logic_vector(5 downto 0); --address for the computer's deck stack
			 addr_hum_deck		  : in std_logic_vector(5 downto 0); --address for the (human) player's deck stack
			 play_pile_top_card : in std_logic_vector(5 downto 0);
			 done_player		  : in std_logic;
			 done_computer		  : in std_logic;
			 rqt_deal_h			  : in std_logic;
			 rqt_deal_comp		  : in std_logic;
			 P_EN					  : out std_logic_vector(51 downto 0);
			 enable_stack_deck  : out std_logic ; --enable for the play deck stack
			 enable_pp			  : out std_logic ; --enable for the play pile register
			 enable_comp_deck	  : out std_logic ; --enable for the computer hand stack
			 enable_hum_deck	  : out std_logic ; --enable for the player hand stack
			 request_deal		  : out std_logic;
			 MODE 				  : out std_logic_vector(1 downto 0);
			 game_over			  : out std_logic;
			 winner				  : out std_logic_vector(1 downto 0);
			 TURN_H				  : out std_logic;
			 TURN_C				  : out std_logic );
end g52_system_controller;

architecture arch of g52_system_controller is

type State_type is (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P);
signal y : State_type;
signal current_addr : std_logic_vector(5 downto 0);
signal num_deck_prev : std_logic_vector(5 downto 0);
signal turn_int: std_logic_vector(1 downto 0);

component g52_pop_enable
port (
	clk : IN STD_LOGIC;
	N : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
	P_EN : OUT STD_LOGIC_VECTOR(51 DOWNTO 0)
	);
end component;

begin		

	--the controller will handle a "universal" pop_enable
	U1 : g52_pop_enable
		PORT MAP (
		CLK => CLK,
		N => current_addr,
		P_EN => P_EN
	);


	process(CLK, RESET)
	begin
		if reset = '1' then
			y <= A;
		elsif clk'event and clk = '1' then
			case y is 
				when A =>
					--initialize game
					y <= B;
				when B =>
					--request a deal
					y <= C;
				when C =>
					if num_deck = "000000" then --no more cards in stockpile
						if turn_int = "01" then --change turn to comp
							y <= L;
						elsif turn_int = "10" then --change turn to human
							y <= H;
						end if;
					elsif num_deck < num_deck_prev then --pop completed
						if turn_int = "00" then --initialization type deal
							y <= D;
						elsif turn_int = "01" then --deal to player
							y <= K;
						elsif turn_int = "10" then --deal to computer
							y <= N;
						end if;
					end if;
				when D =>
					if num_hum < "00111" then
						y <= E;
					elsif num_com < "00111" then
						y <= F;
					else
						y <= G;
					end if;
				when E => --push to player's hand
					y <= B;
				when F => --push to computer's hand
					y <= B;
				when G => --now place a card on the play pile
					if play_pile_top_card > "000000" then
						y <= H;
					end if;				
				when H =>
					--initialization finished.
					--start (human) player's turn, change pop_enable to player stack
					if num_com = "00000" then
						y <= P;
					else 
						y <= I;
					end if;
				when I =>
					if done_player = '1' then
						if rqt_deal_h = '0' then
							y <= B;
						else
							y <= J;
						end if;
					end if;
				when J => --put to play pile
					if turn_int = "01" then
						y <= K;
					elsif turn_int = "10" then
						y <= N;
					end if;
				when K => --enable hand stack
					y <= L; --will PUSH or have no effect
				when L => --start computer turn
					if num_hum = "00000" then
						y <= O; --player win
					else 
						y <= M;
					end if;
				when M =>
					if done_computer = '1' then
						if rqt_deal_comp = '0' then
							y <= B;
						else
							y <= J; --pop to play pile
						end if;
					end if;
				when N => --enable comp stack
					y <= H; --will PUSH or have no effect
				when O => --player win
					y <= O;
				when P => --computer win
					y <= P;
			end case;
		end if;
	end process;
	
	with y select
		MODE <= "01" when A,
				  "11" when others;
	with y select
		enable_stack_deck <= '1' when A, --the dealer will be enabling all other uses of the stack
									'0' when others;
	
	with y select
		num_deck_prev <= num_deck when A,
							  num_deck when B,
							  num_deck_prev when others;
							  
	with y select
		current_addr <= addr_hum_deck when H, 
							 addr_hum_deck when I, 
							 addr_hum_deck when K,
							 addr_hum_deck when L,
							 addr_com_deck when M,
							 addr_com_deck when N,
							 addr_deck when others;
	
	with y select
		enable_hum_deck <= '1' when E,
								 '1' when I,
								 '1' when K,
								 '0' when others;
	with y select
		enable_comp_deck <= '1' when F,
								  '1' when M,
								  '1' when N,
								  '0' when others;
								  						  
	with y select
		enable_pp <= '1' when G,
						 '1' when J,
						 '0' when others;	

	with y select
		request_deal <= '0' when B,
							 '1' when others;

	with y select 
		turn_int <= "00" when A,
						"01" when H,
						"10" when L,
						turn_int when others;	
	
	with y select
		TURN_H <= '1' when H,
					 '1' when I,
					 '0' when others;
	
	with y select
		TURN_C <= '1' when L,
				    '0' when others;
	  
	with y select
		game_over <= '1' when O,
						 '1' when P,
						 '0' when others;
	with y select
		winner <= "01" when O,
					 "10" when P,
					 "00" when others;
									
end arch;