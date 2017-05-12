-- MOD 10 circuit for 7 segment displays--
-- entity name: g52_mod10
--
-- Copyright (C) 2017 Jenna Mar
-- Version 1.0
-- Author: Jenna Mar; jenna.mar@mail.mcgill.ca
-- Date: 2017/04/01

library ieee; -- allows use of the std_logic_vector type
library lpm;
use ieee.std_logic_1164.all;
use lpm.lpm_components.all;
use ieee.numeric_std.all;

entity g52_mod10 is
	port ( value                : in std_logic_vector(5 downto 0) ;
			 mod10                : out std_logic_vector(3 downto 0) ;
			 floor					 : out std_logic_vector(3 downto 0) ) ;
end g52_mod10;

architecture arch of g52_mod10 is

component LPM_ADD_SUB
	generic (LPM_WIDTH : natural := 10;
				LPM_DIRECTION : string := "ADD";
				LPM_REPRESENTATION: string := "UNSIGNED";
				LPM_PIPELINE : natural := 0
	);
	port (DATAA : in std_logic_vector(LPM_WIDTH-1 downto 0);
			DATAB : in std_logic_vector(LPM_WIDTH-1 downto 0);
			RESULT : out std_logic_vector(LPM_WIDTH-1 downto 0)
	);
end component;

signal orig_val : std_logic_vector(9 downto 0);
signal shift_3 : std_logic_vector(9 downto 0);
signal shift_2 : std_logic_vector(9 downto 0);
signal mult13_1 : std_logic_vector(9 downto 0);
signal mult13_2 : std_logic_vector(9 downto 0);
signal mult10 : std_logic_vector(9 downto 0);
signal add1 : std_logic_vector(9 downto 0);
signal add2 : std_logic_vector(9 downto 0);
signal add3 : std_logic_vector(9 downto 0);
signal res : std_logic_vector(9 downto 0);

begin

--we will use 13 / 128 (shift of 7 bits)
-- [000]000000
orig_val(5 downto 0) <= value(5 downto 0);
orig_val(9 downto 6) <= "0000";

shift_3(8 downto 3) <= value(5 downto 0);
shift_3(2 downto 0) <= "000";
shift_3(9) <= '0';

shift_2(7 downto 2) <= value(5 downto 0);
shift_2(1 downto 0) <= "00";
shift_2(9 downto 8) <= "00";

add1_inst : LPM_ADD_SUB
PORT MAP(DATAA => shift_3,
			DATAB => shift_2,
			RESULT => mult13_1);
			
add2_inst : LPM_ADD_SUB
PORT MAP(DATAA => mult13_1,
			DATAB => orig_val,
			RESULT => mult13_2);
------------ 3 places, and 1 place
add1(5 downto 3) <= mult13_2(9 downto 7);
add1(9 downto 6) <= "0000";
add1(2 downto 0) <= "000";

add2(3 downto 1) <= mult13_2(9 downto 7);	
add2(9 downto 4) <= "000000";
add2(0) <= '0';

add3_inst : LPM_ADD_SUB
PORT MAP(DATAA => add1,
			DATAB => add2,
			RESULT => mult10);	

--2's complement the sum
add3(9 downto 0) <= std_logic_vector(to_unsigned(to_integer(unsigned(not mult10(9 downto 0))) + 1,10));
			
--subtract			
add4_inst : LPM_ADD_SUB
PORT MAP(DATAA => orig_val,
			DATAB => add3,
			RESULT => res);
mod10(3 downto 0) <= res(3 downto 0);
floor(2 downto 0) <= mult13_2(9 downto 7);
floor(3) <= '0';

end arch;

