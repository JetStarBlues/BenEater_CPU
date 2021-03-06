-- Code by www.jk-quantized.com
-- Redistribution and use of this code in source and binary forms
-- must retain the above attribution notice and this condition.

-- TODO:
--  Currently can count max (N-1) bits. Re 'q( N - 1 downto X )'
--  Find a way to improve, so that can count max N bits (i.e. X can be N)

library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity incrementXN is

	generic (

		X : integer
	);

	port (

		d : in  std_logic_vector( N - 1 downto 0 );
		q : out std_logic_vector( N - 1 downto 0 )
	);

end entity;


architecture ac of incrementXN is

	signal carry : std_logic_vector( 0 to X );

begin

	q( N - 1 downto X ) <= ( others => '0' );  -- drive unused low

	carry( 0 ) <= '1';  -- add one

	gen : for i in 0 to X - 1 generate

		comp : halfAdder port map ( d( i ), carry( i ), q( i ), carry( i + 1 ) );

	end generate;

end architecture;


--