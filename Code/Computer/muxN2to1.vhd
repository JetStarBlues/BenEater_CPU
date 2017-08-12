library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity muxN2to1 is

	port (
		d1, d0 : in std_logic_vector( N - 1 downto 0 );
		s      : in std_logic;
		q      : out std_logic_vector( N - 1 downto 0 )
	);
	
end entity;


architecture ac of muxN2to1 is

begin

	gen : for i in N - 1 downto 0 generate

		comp : mux2to1 port map( d1(i), d0(i), s, q(i) );

	end generate;
	
end architecture;


--