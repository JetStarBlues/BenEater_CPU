-- Code by www.jk-quantized.com
-- Redistribution and use of this code in source and binary forms
-- must retain the above attribution notice and this condition.

library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity orNto1 is

	port (

		d : in  std_logic_vector( N - 1 downto 0 );
		q : out std_logic
	);
	
end entity;


architecture ac of orNto1 is
	
	signal x : std_logic_vector( N - 2 downto 0 );

begin

	x( N - 2 ) <= d( N - 1 );

	gen : for i in N - 2 downto 1 generate

		x( i - 1 ) <= d( i ) or x( i );

	end generate;

	q <= d( 0 ) or x( 0 );
	
end architecture;


--