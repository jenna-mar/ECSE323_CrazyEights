-- dealer circuit--
-- entity name: g52_dealer
--
-- Copyright (C) 2017 Jenna Mar
-- Version 1.0
-- Author: Jenna Mar; jenna.mar@mail.mcgill.ca
-- Date: 2017/03/31

library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;

entity g52_dealer is
	port ( request_deal 			  : in std_logic ;
			 rand_lt_num			  : in std_logic;
			 reset					  : in std_logic;
			 clk						  : in std_logic;
			 rand_enable			  : out std_logic;
			 stack_enable			  : out std_logic );
end g52_dealer;

architecture arch of g52_dealer is

type State_type is (A,B,C,D);
signal y : State_type;

begin		

	process(clk, reset)
	begin
		if reset = '1' then
		y <= A;
		
		elsif clk'event and clk = '1' then
			case y is
				when A => --request_deal is low
					if request_deal = '0' then
						y <= B;
					end if;
				when B => --request_deal has gone low then high
					if request_deal = '1' then
						y <= C;
					end if;
				when C => --check rand compare
					if rand_lt_num = '1' then
						y <= D;
					end if;
				when D => --enable stack
					y <= A;
			end case;
		end if;
	end process;
	
	with y select
		rand_enable <= '1' when C,
							'0' when others;
	with y select
		stack_enable <= '1' when D,
							 '0' when others;

end arch;