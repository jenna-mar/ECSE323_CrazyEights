-- this circuit implements the IBM RANDU version of a linear congruential generator--
-- entity name: g52_RANDU
--
-- Copyright (C) 2017, Jenna Mar
-- Version 1.0
-- Author: Jenna Mar; jenna.mar@mail.mcgill.ca
-- Date: 2017/02/13

library ieee; -- allows use of the std_logic_vector type
library lpm;
use ieee.std_logic_1164.all;
use lpm.lpm_components.all;

entity g52_RANDU is
	port ( seed                : in std_logic_vector(31 downto 0) ;
			 rand                : out std_logic_vector(31 downto 0) ) ;
end g52_RANDU;

architecture internal of g52_RANDU is

component LPM_ADD_SUB
	generic (LPM_WIDTH : natural := 48;
				LPM_DIRECTION : string := "ADD";
				LPM_REPRESENTATION: string := "UNSIGNED";
				LPM_PIPELINE : natural := 0
	);
	port (DATAA : in std_logic_vector(LPM_WIDTH-1 downto 0);
			DATAB : in std_logic_vector(LPM_WIDTH-1 downto 0);
			RESULT : out std_logic_vector(LPM_WIDTH-1 downto 0)
	);
end component;

signal orig_seed : std_logic_vector(47 downto 0);
signal shift16_1 : std_logic_vector(47 downto 0);
signal shift1_2 : std_logic_vector(47 downto 0);
signal sum1 : std_logic_vector(47 downto 0);
signal multR : std_logic_vector(47 downto 0);

begin

shift16_1(47 downto 16) <= seed(31 downto 0);
shift16_1(15 downto 0) <= "0000000000000000";
shift1_2(32 downto 1) <= seed(31 downto 0);
shift1_2 (47 downto 33) <= "000000000000000";
--shift1_2(32 downto 1) <= seed (31 downto 0);
shift1_2(0) <= '0';
orig_seed(31 downto 0) <= seed(31 downto 0);
orig_seed(47 downto 32) <= "0000000000000000";

add1_inst : LPM_ADD_SUB
PORT MAP(DATAA => shift16_1,
			DATAB => shift1_2,
			RESULT => sum1);

add2_inst : LPM_ADD_SUB
PORT MAP(DATAA => sum1,
			DATAB => orig_seed,
			RESULT => multR);	

rand(30 downto 0) <= multR(30 downto 0);
rand(31) <= '0';

end internal;

