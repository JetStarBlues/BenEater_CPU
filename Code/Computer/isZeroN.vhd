-- Code by www.jk-quantized.com
-- Redistribution and use of this code in source and binary forms
-- must retain the above attribution notice and this condition.

library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity isZeroN is

	port (

		d : in  std_logic_vector( N - 1 downto 0 );
		q : out std_logic
	);

end entity;


architecture ac of isZeroN is

	signal q0 : std_logic;

begin

	-- OrNto1
	comp : OrNto1 port map ( d, q0 );

	q <= not q0;

end architecture;


-- See,
--  https://youtu.be/-arYx_oVIj8?t=3m56s
--  https://youtu.be/CiMaWbz_6E8