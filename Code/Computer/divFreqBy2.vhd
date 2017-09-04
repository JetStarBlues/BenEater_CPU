-- Code by www.jk-quantized.com
-- Redistribution and use of this code in source and binary forms
-- must retain the above attribution notice and this condition.

library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity divFreqBy2 is

	port (

		d : in  std_logic;
		q : out std_logic
	);

end entity;


architecture ac of divFreqBy2 is

	signal q0, nq0 : std_logic;

begin

	q <= q0;

	nq0 <= not q0;

	comp : dFlipFlop port map (

		nq0, '1', d, '0', q0
	);

end architecture;


-- http://www.electronics-tutorials.ws/sequential/seq_4.html