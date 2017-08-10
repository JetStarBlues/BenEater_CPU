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

	signal q : std_logic_vector( N - 1 downto 0 );

begin

	comp0 : memoryXN
	           generic map ( X )
	           port map    ( databus, clk, loadAddr, loadData, clrAddr, q );

	comp1 : bufferN port map ( q, out_enable, databus );

end architecture;


-- See,
--   https://youtu.be/uYXwCBo40iA
--   https://youtu.be/KNve2LCcSRc
--   https://youtu.be/5rl1tEFXKt0
--   https://github.com/kyllikki/eda-designs/blob/master/SAP-BE/sap-be.pdf