-- MOD 13 circuit--
-- entity name: g52_mod13
--
-- Copyright (C) 2017 Jenna Mar
-- Version 1.0
-- Author: Jenna Mar; jenna.mar@mail.mcgill.ca
-- Date: 2017/03/07

library ieee; -- allows use of the std_logic_vector type
library lpm;
use ieee.std_logic_1164.all;
use lpm.lpm_components.all;
use ieee.numeric_std.all;

entity g52_mod13 is
	port ( value                : in std_logic_vector(5 downto 0) ;
			 mod13                : out std_logic_vector(3 downto 0) ;
			 floor					 : out std_logic_vector(3 downto 0) ) ;
end g52_mod13;

architecture arch of g52_mod13 is

component LPM_ADD_SUB
	generic (LPM_WIDTH : natural := 9;
				LPM_DIRECTION : string := "ADD";
				LPM_REPRESENTATION: string := "UNSIGNED";
				LPM_PIPELINE : natural := 0
	);
	port (DATAA : in std_logic_vector(LPM_WIDTH-1 downto 0);
			DATAB : in std_logic_vector(LPM_WIDTH-1 downto 0);
			RESULT : out std_logic_vector(LPM_WIDTH-1 downto 0)
	);
end component;

signal orig_val : std_logic_vector(8 downto 0);
signal shift1_2 : std_logic_vector(8 downto 0);
signal mult5 : std_logic_vector(8 downto 0);
signal mult13_1 : std_logic_vector(8 downto 0);
signal mult13_2 : std_logic_vector(8 downto 0);
signal add1 : std_logic_vector(8 downto 0);
signal add2 : std_logic_vector(8 downto 0);
signal add3 : std_logic_vector(8 downto 0);
signal add4 : std_logic_vector(8 downto 0);
signal res : std_logic_vector(8 downto 0);

begin

orig_val(5 downto 0) <= value(5 downto 0);
orig_val(8 downto 6) <= "000";

shift1_2(7 downto 2) <= value(5 downto 0);
shift1_2(1 downto 0) <= "00";
shift1_2(8) <= '0';

add1_inst : LPM_ADD_SUB
PORT MAP(DATAA => orig_val,
			DATAB => shift1_2,
			RESULT => mult5);

add1(5 downto 3) <= mult5(8 downto 6);
add1(8 downto 6) <= "000";
add1(2 downto 0) <= "000";

add2(4 downto 2) <= mult5(8 downto 6);	
add2(8 downto 5) <= "0000";
add2(1 downto 0) <= "00";

add2_inst : LPM_ADD_SUB
PORT MAP(DATAA => add1,
			DATAB => add2,
			RESULT => mult13_1);	
			
add3(2 downto 0) <= mult5(8 downto 6);
add3(8 downto 3) <= "000000";

add3_inst : LPM_ADD_SUB
PORT MAP(DATAA => mult13_1,
			DATAB => add3,
			RESULT => mult13_2);

--2's complement the sum
add4(8 downto 0) <= std_logic_vector(to_unsigned(to_integer(unsigned(not mult13_2(8 downto 0))) + 1,9));
			
--subtract			
add4_inst : LPM_ADD_SUB
PORT MAP(DATAA => orig_val,
			DATAB => add4,
			RESULT => res);
mod13(3 downto 0) <= res(3 downto 0);
floor(2 downto 0) <= mult5(8 downto 6);
floor(3) <= '0';

end arch;

