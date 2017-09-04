-- Code by www.jk-quantized.com
-- Redistribution and use of this code in source and binary forms
-- must retain the above attribution notice and this condition.

library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity decoder3to8 is

	port (

		d : in  std_logic_vector( 2 downto 0 );
		q : out std_logic_vector( 7 downto 0 )
	);
	
end entity;


architecture ac of decoder3to8 is

	signal nd : std_logic_vector( 2 downto 0 );
	
begin

	nd <= not d;
	
	q(7) <=  d(2) and  d(1) and  d(0);
	q(6) <=  d(2) and  d(1) and nd(0);
	q(5) <=  d(2) and nd(1) and  d(0);
	q(4) <=  d(2) and nd(1) and nd(0);
	q(3) <= nd(2) and  d(1) and  d(0);
	q(2) <= nd(2) and  d(1) and nd(0);
	q(1) <= nd(2) and nd(1) and  d(0);
	q(0) <= nd(2) and nd(1) and nd(0);
	
end architecture;


--