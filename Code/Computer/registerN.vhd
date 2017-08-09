library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity registerN is

	port (
		d              : in  std_logic_vector( N - 1 downto 0 );
		load, clk, clr : in  std_logic;
		q              : out std_logic_vector( N - 1 downto 0 )
	);

end entity;


architecture ac of registerN is

begin

	gen : for i in N - 1 downto 0 generate

		comp : dFlipFlop port map ( d(i), load, clk, clr, q(i) );

	end generate;

end architecture;


-- See,
--  https://youtu.be/-arYx_oVIj8?t=3m56s
--  https://youtu.be/CiMaWbz_6E8