library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity programCounterN_oe is

	port (
		d              : in  std_logic_vector( N - 1 downto 0 );
		load, clk, clr : in  std_logic;
		increment      : in  std_logic;
		out_enable     : in  std_logic;
		q              : out std_logic_vector( N - 1 downto 0 )
	);

end entity;


architecture ac of programCounterN_oe is

	signal q0 : std_logic_vector( N - 1 downto 0 );

begin

	comp0 : counterXN
	           generic map ( N )
	           port map    ( d, load, clk, clr, increment, q0 );

	comp1 : bufferN port map ( q0, out_enable, q );

end architecture;


-- See https://youtu.be/g_1HyxBzjl0