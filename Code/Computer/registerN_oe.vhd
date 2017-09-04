-- Code by www.jk-quantized.com
-- Redistribution and use of this code in source and binary forms
-- must retain the above attribution notice and this condition.

library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity registerN_oe is

	port (

		databus        : inout std_logic_vector( N - 1 downto 0 );
		load, clk, clr : in    std_logic;
		out_enable     : in    std_logic;
		q              : out   std_logic_vector( N - 1 downto 0 )
	);

end entity;


architecture ac of registerN_oe is

	signal q0 : std_logic_vector( N - 1 downto 0 );

begin

	q <= q0;

	comp0 : registerN port map ( databus, load, clk, clr, q0 );

	comp1 : bufferN port map ( q0, out_enable, databus );


end architecture;


-- See,
--  . array of dffs  - https://youtu.be/-arYx_oVIj8?t=3m56s
--  . output buffers - https://youtu.be/CiMaWbz_6E8