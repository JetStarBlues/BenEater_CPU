library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity registerN_oe is

	port (
		databus        : inout std_logic_vector( N - 1 downto 0 );
		load, clk, clr : in    std_logic;
		out_enable     : in    std_logic;
		q              : out   std_logic_vector( N - 1 downto 0 )
	);

end entity;


architecture ac of registerN_oe is

	signal d, q0, q1 : std_logic_vector( N - 1 downto 0 );

begin

	d <= databus;
	q <= q0;
	databus <= q1;

	comp0 : registerN port map ( d, load, clk, clr, q0 );

	comp1 : buffer port map ( q0, out_enable, q1 );


end architecture;


-- See,
--  . array of dffs  - https://youtu.be/-arYx_oVIj8?t=3m56s
--  . output buffers - https://youtu.be/CiMaWbz_6E8