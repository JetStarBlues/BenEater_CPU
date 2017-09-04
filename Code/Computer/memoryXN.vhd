-- Code by www.jk-quantized.com
-- Redistribution and use of this code in source and binary forms
-- must retain the above attribution notice and this condition.

library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity memoryXN is

	generic (

		X : integer
	);

	port (

		d          : in  std_logic_vector( N - 1 downto 0 );
		clk        : in  std_logic;
		loadAddr   : in  std_logic;
		loadData   : in  std_logic;
		clrAddr    : in  std_logic;
		q          : out std_logic_vector( N - 1 downto 0 )
	);

end entity;


architecture ac of memoryXN is

	signal address : std_logic_vector( N - 1 downto 0 );

begin

	-- Memory address register
	comp0 : registerN port map ( d, loadAddr, clk, clrAddr, address );

	-- Memory
	comp1 : singlePortRAMXN
	        	generic map ( X )
	        	port map    ( clk, d, address, loadData, q );

end architecture;


-- See,
--   https://youtu.be/uYXwCBo40iA
--   https://youtu.be/KNve2LCcSRc
--   https://youtu.be/5rl1tEFXKt0
--   https://github.com/kyllikki/eda-designs/blob/master/SAP-BE/sap-be.pdf