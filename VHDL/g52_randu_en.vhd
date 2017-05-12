-- circuit for enabling RANDU and reinitializing number generated --
-- entity name: g52_randu_en
--
-- Copyright (C) 2017, Jenna Mar
-- Version 1.0
-- Author: Jenna Mar; jenna.mar@mail.mcgill.ca
-- Date: 2017/03/21

library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;

entity g52_randu_en is
	port ( rand_enable                : in std_logic ;
			 clk								 : in std_logic;
			 rst								 : in std_logic;
			 seed_prev 						 : in std_logic_vector(31 downto 0);
			 seed							    : out std_logic_vector(31 downto 0) ) ;
end g52_randu_en;

architecture arch of g52_randu_en is
signal seed_in : std_logic_vector(31 downto 0);

begin

process (clk, rst)
	begin
	if rst = '1' then
		seed_in <= "01001101100111000101100110111001"; --use some random initial seed
	elsif clk'event and clk = '1' then
		if rand_enable = '1' then
			seed_in <= seed_prev;
		end if;
	end if;
	
end process;

seed <= seed_in;

end arch;