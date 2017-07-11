library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity memoryXN_oe is

	generic (
		X : integer
	);

	port (
		databus    : inout std_logic_vector( N - 1 downto 0 );
		clk        : in    std_logic;
		loadAddr   : in    std_logic;
		loadData   : in    std_logic;
		clrAddr    : in    std_logic;
		out_enable : in    std_logic
	);

end entity;


architecture ac of memoryXN_oe is

	signal d, q, q0 : std_logic_vector( N - 1 downto 0 );

begin

	d <= databus;
	databus <= q;

	comp0 : memoryXN
	           generic map ( X )
	           port map    ( d, clk, loadAddr, loadData, clrAddr, q0 );

	comp1 : bufferN port map ( q0, out_enable, q );

end architecture;


-- See,
--   https://youtu.be/uYXwCBo40iA
--   https://youtu.be/KNve2LCcSRc
--   https://youtu.be/5rl1tEFXKt0