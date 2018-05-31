-- Code by www.jk-quantized.com
-- Redistribution and use of this code in source and binary forms
-- must retain the above attribution notice and this condition.

library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity aluN_oe is

	port (

		databus    : inout std_logic_vector( N - 1 downto 0 );
		da, db     : in    std_logic_vector( N - 1 downto 0 );
		subtract   : in    std_logic;
		out_enable : in    std_logic;
		fZero      : out   std_logic;
		fCarry     : out   std_logic
	);

end entity;


architecture ac of aluN_oe is

	signal q : std_logic_vector( N - 1 downto 0 );

begin

	comp0 : aluN port map ( da, db, subtract, q, fZero, fCarry );

	comp1 : bufferN port map ( q, out_enable, databus );

end architecture;


-- See https://youtu.be/mOVOS9AjgFs