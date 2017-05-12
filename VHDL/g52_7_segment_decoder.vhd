-- this circuit implements the 7 segment decoder--
-- entity name: g52_7_segment_decoder
--
-- Copyright (C) 2017 Jenna Mar
-- Version 1.0
-- Author: Jenna Mar; jenna.mar@mail.mcgill.ca
-- Date: 2017/02/20

library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;

entity g52_7_segment_decoder is
	port ( code				: in std_logic_vector(3 downto 0) ;
			 mode				: in std_logic ;
			 segments_out	: out std_logic_vector(6 downto 0)) ;
end g52_7_segment_decoder;

architecture decoder of g52_7_segment_decoder is

SIGNAL xcode : std_logic_vector(4 downto 0);

BEGIN

xcode (4 downto 1) <= code; 
xcode(0) <= mode;

WITH xcode SELECT
segments_out <=
	"1000000" WHEN "00000", -- code = 0 mode = 0
	"1111001" WHEN "00010", -- code = 1 mode = 0
	"0100100" WHEN "00100", -- code = 2 mode = 0
	"0110000" WHEN "00110", -- code = 3 mode = 0
	"0011001" WHEN "01000", -- code = 4 mode = 0
	"0010010" WHEN "01010", -- code = 5 mode = 0
	"0000010" WHEN "01100", -- code = 6 mode = 0
	"1111000" WHEN "01110", -- code = 7 mode = 0
	"0000000" WHEN "10000", -- code = 8 mode = 0
	"0010000" WHEN "10010", -- code = 9 mode = 0
	"0001000" WHEN "10100", -- code = A mode = 0
	"0000011" WHEN "10110", -- code = B mode = 0
	"1000110" WHEN "11000", -- code = C mode = 0
	"0100001" WHEN "11010", -- code = D mode = 0
	"0000110" WHEN "11100", -- code = E mode = 0
	"0001110" WHEN "11110", -- code = F mode = 0

	"0001000" WHEN "00001", -- code = A mode = 1
	"0100100" WHEN "00011", -- code = 2 mode = 1
	"0110000" WHEN "00101", -- code = 3 mode = 1
	"0011001" WHEN "00111", -- code = 4 mode = 1
	"0010010" WHEN "01001", -- code = 5 mode = 1
	"0000010" WHEN "01011", -- code = 6 mode = 1
	"1111000" WHEN "01101", -- code = 7 mode = 1
	"0000000" WHEN "01111", -- code = 8 mode = 1
	"0010000" WHEN "10001", -- code = 9 mode = 1
	"1000000" WHEN "10011", -- code = 0 mode = 1
	"1100001" WHEN "10101", -- code = J mode = 1
	"0100011" WHEN "10111", -- code = Q mode = 1
	"0001001" WHEN "11001", -- code = K mode = 1
	"0010001" WHEN "11011",	-- code = Y mode = 1
	"0111111" WHEN others; -- code =-

end decoder;	