-- stack circuit for players--
-- entity name: g52_stack26
--
-- Copyright (C) 2017 Jenna Mar
-- Version 1.0
-- Author: Jenna Mar; jenna.mar@mail.mcgill.ca
-- Date: 2017/03/31

library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity g52_stack26 is
	port ( DATA                : in std_logic_vector(5 downto 0) ; --contains the data to be "PUSH"ed onto the stack
			 MODE                : in std_logic_vector(1 downto 0) ; --determines what action is to be taken on the next rising clock transition
			 ADDR                : in std_logic_vector(5 downto 0) ; --sets the locaiton to be viewed, and the location of element to be removed during POP
			 ENABLE              : in std_logic ; --enables the operation specified by the MODE
			 RST                	: in std_logic ; --clears all stack locations and sets NUM <= 0
			 CLK                 : in std_logic ; --the clock
			 P_EN						: in std_logic_vector(51 downto 0);
			 VALUE               : out std_logic_vector(5 downto 0); --indicates the value of the stack location pointed to by ADDR
			 EMPTY					: out std_logic ; --indicates if the stack if empty
			 FULL						: out std_logic ; --indicates if the stack is full
			 NUM						: out std_logic_vector(4 downto 0) --indicates the number of stack elements
			 ) ;
end g52_stack26;

architecture arch of g52_stack26 is
	-- use internal signal to store the value of the shift register
	signal internal : std_logic_vector(155 downto 0);
	--other signals for use inside process
	signal dat_out : std_logic_vector(5 downto 0);
	signal num_int : std_logic_vector(4 downto 0);
	signal full_int : std_logic;
	signal empty_int : std_logic;
	signal popped : std_logic;
	
	begin
	
	process(clk, RST)
	
	 begin
		if RST ='1' then --Asynch reset for data
			internal <= std_logic_vector(to_unsigned(0,156)); --reset all bits
			num_int <= "00000"; --reset num
			dat_out <= "000000";
			popped <= '0';
			
		elsif (CLK'event and CLK='1') then
			if popped = '1' then 
				FOR i IN 0 to 25 LOOP
					if (P_EN(i)='1') then
						if (i=25) then
						internal(155 downto 150) <= "000000"; -- clear last entry
						else
						--example. (0 to 5) <= (6 to 11)
						internal(i*6+5 downto i*6) <= internal((i+1)*6+5 downto (i+1)*6); --push values from addr+1 up above addr
						end if;
					end if;
				END LOOP;
				popped <= '0';
			end if;
			
			if ENABLE='1' then
			   if MODE="01" then --change INIT to 'view' mode specially for player decks
					dat_out <= internal(to_integer(unsigned(ADDR))*6+5 downto to_integer(unsigned(ADDR))*6); --put data from addr into output
				
				elsif MODE="10" and full_int/='1' then --mode is PUSH
					--example. i=52 (306 to 311) <= (300 to 305)
					FOR i IN 25 downto 1 LOOP --push all values down, with new value on top (at 0)
						internal(i*6+5 downto i*6) <= internal ((i-1)*6+5 downto (i-1)*6);
					END LOOP;
					internal(5 downto 0) <= DATA; --Push onto stack
					dat_out <= internal(5 downto 0);
					num_int <= std_logic_vector(to_unsigned(to_integer(unsigned(num_int)) + 1,5)); --increment NUM
			
				elsif MODE="11" and empty_int/='1' then --mode is POP					
					dat_out(5 downto 0) <= internal(to_integer(unsigned(ADDR))*6+5 downto to_integer(unsigned(ADDR))*6); --put data from addr into output
					popped <= '1';
					num_int <= std_logic_vector(to_unsigned(to_integer(unsigned(num_int)) - 1,5)); --decrement NUM
				end if;
			end if;
		-- signal updated at end of process
		end if;
		
		--update additional params		
		if num_int="00000" then
			empty_int <= '1';
			full_int <= '0';
		elsif num_int="11010" then
			full_int <= '1';
			empty_int <= '0';	
		else
			full_int <= '0';
			empty_int <= '0';
		end if;
	
	end process;
	
	FULL <= full_int;
	EMPTY <= empty_int;
	NUM <= num_int;
	VALUE <= dat_out; --update the output ports at the end of the process
end arch;