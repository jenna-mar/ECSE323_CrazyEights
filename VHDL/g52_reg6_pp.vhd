-- register circuit for play pile --
-- entity name: g52_reg6_pp
--
-- Copyright (C) 2017 Jenna Mar
-- Version 1.0
-- Author: Jenna Mar; jenna.mar@mail.mcgill.ca
-- Date: 2017/03/31

library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;

entity g52_reg6_pp is
	port ( value_deck			   : in std_logic_vector(5 downto 0) ;
			 value_h					: in std_logic_vector(5 downto 0) ;
			 value_c					: in std_logic_vector(5 downto 0) ;
			 turn_H					: in std_logic;
			 turn_C					: in std_logic;
			 enable              : in std_logic;
			 rst						: in std_logic;
			 clk						: in std_logic;
			 play_pile_top_card	: out std_logic_vector(5 downto 0) ) ;
end g52_reg6_pp;

architecture arch of g52_reg6_pp is
signal init : std_logic_vector(1 downto 0);
signal turn : std_logic;

begin

process(clk, rst)
	begin
		if rst = '1' then
			play_pile_top_card <= (others => '0');
			init <= "00";
			turn <= '0';
		elsif clk'event and clk = '1' then
			if turn_H = '1' then
				turn <= '0';
			elsif turn_C = '1' then
				turn <= '1';
			end if;
			
			if enable = '1' then
				if init = "00" then --initialization, use a value from deck stack
					play_pile_top_card <= value_deck;
					init <= "01";
				elsif init = "01" then --wait 2 clock cycles
					init <= "11";
				elsif turn = '0' then
					play_pile_top_card <= value_h;
					turn <= '1';
				else
					play_pile_top_card <= value_c;
					turn <= '0';
				end if;
			end if;
		end if;
end process;

end arch;