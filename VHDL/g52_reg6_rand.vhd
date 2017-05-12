-- circuit taking 32 bit random input and storing 6 bit random number --
-- entity name: g52_reg6
--
-- Copyright (C) 2017 Jenna Mar
-- Version 1.0
-- Author: Jenna Mar; jenna.mar@mail.mcgill.ca
-- Date: 2017/03/21

library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;

entity g52_reg6_rand is
	port ( rand                : in std_logic_vector(31 downto 0) ;
			 enable              : in std_logic;
			 rst						: in std_logic;
			 clk						: in std_logic;
			 q							: out std_logic_vector(5 downto 0) ) ;
end g52_reg6_rand;

architecture arch of g52_reg6_rand is

begin

process(clk, rst)
	begin
		if rst = '1' then
			q <= (others => '0');
		elsif clk'event and clk = '1' then
			if enable = '1' then
				q <= rand(31 downto 26); --use higher order bits
			end if;
		end if;
end process;

end arch;