-- pop enable circuit --
-- entity name: g52_pop_enable
--
-- Copyright (C) 2017 Jenna Mar
-- Version 1.0
-- Author: Jenna Mar; jenna.mar@mail.mcgill.ca
-- Date: 2017/02/13

library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;
library lpm;
use lpm.lpm_components.all;

entity g52_pop_enable is
	port ( N                : in std_logic_vector(5 downto 0) ;
			 CLK					: in std_logic ;
			 P_EN             : out std_logic_vector(51 downto 0) ) ;
end g52_pop_enable;

architecture internal of g52_pop_enable is

begin

crc_table : LPM_ROM
	generic map(
			LPM_WIDTH => 52,    -- width of the word stored in each ROM location
         LPM_WIDTHAD => 6,    -- sets the width of the ROM address bus
         LPM_NUMWORDS => 64, -- sets the number of words stored in the ROM
         LPM_ADDRESS_CONTROL => "REGISTERED", -- register on the input
         LPM_OUTDATA => "UNREGISTERED", --no register on the output
         LPM_FILE => "crc_rom.mif") -- the ascii file containing the 
         port map(ADDRESS => N, INCLOCK => CLK, Q => P_EN);

end internal;