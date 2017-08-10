library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity bufferN is

	port (
		d  : in  std_logic_vector( N - 1 downto 0 );
		oe : in  std_logic;
		q  : out std_logic_vector( N - 1 downto 0 )
	);

end entity;


architecture ac of bufferN is

begin

	gen : for i in N - 1 downto 0 generate

		comp : bufferr port map ( d(i), oe, q(i) );

	end generate;

end architecture;


--