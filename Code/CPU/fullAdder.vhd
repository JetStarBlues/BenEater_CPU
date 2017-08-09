library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity fullAdder is

	port (
		a, b, cIn : in  std_logic;
		sum, cOut : out std_logic
	);

end entity;


architecture ac of fullAdder is

	signal sum1, carry1, carry2 : std_logic;

begin

	comp0 : halfAdder port map (    a,   b, sum1, carry1 );
	comp1 : halfAdder port map ( sum1, cIn,  sum, carry2 );

	cOut <= carry1 or carry2;

end architecture;


--