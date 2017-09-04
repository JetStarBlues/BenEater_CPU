-- Code by www.jk-quantized.com
-- Redistribution and use of this code in source and binary forms
-- must retain the above attribution notice and this condition.

library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity programCounterN_oe is

	port (

		databus        : inout std_logic_vector( N - 1 downto 0 );
		load, clk, clr : in    std_logic;
		increment      : in    std_logic;
		out_enable     : in    std_logic
	);

end entity;


architecture ac of programCounterN_oe is

	signal q : std_logic_vector( N - 1 downto 0 );

begin

	comp0 : counterXN
	           generic map ( N )
	           port map    ( databus, load, clk, clr, increment, q );

	comp1 : bufferN port map ( q, out_enable, databus );

end architecture;


-- See https://youtu.be/g_1HyxBzjl0