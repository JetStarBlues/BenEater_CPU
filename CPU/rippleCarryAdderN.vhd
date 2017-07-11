library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity rippleCarryAdderN is

	port (
		a, b : in  std_logic_vector( N - 1 downto 0 );
		cIn  : in  std_logic;
		sum  : out std_logic_vector( N - 1 downto 0 );
		cOut : out std_logic
	);

end entity;


architecture ac of rippleCarryAdderN is

	signal carry : std_logic_vector( 0 to N );

begin

	carry(0) <= cIn;

	cOut <= carry(N);

	gen : for i in 0 to N - 1 generate

		comp : fullAdder port map ( a(i), b(i), carry(i), sum(i), carry( i + 1 ) );

	end generate;

end architecture;


--