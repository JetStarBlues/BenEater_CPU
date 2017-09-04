-- Code by www.jk-quantized.com
-- Redistribution and use of this code in source and binary forms
-- must retain the above attribution notice and this condition.

library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity computer_tb is
end entity;


architecture ac of computer_tb is

	signal clk, reset, waitt : std_logic := '0';
	signal outputReady       : std_logic;
	signal outputRegOut      : std_logic_vector( N - 1 downto 0 );

begin

	clk <= not clk after 1 ps;

	comp_computer : computer port map (

		clk,
		reset,
		waitt,
		outputReady,
		outputRegOut
	);


	--	process
	--	begin
	--
	--		wait for 2500 ps;
	--		reset <= '1';
	--		wait for 100 ps;
	--		reset <= '0';
	--
	--		wait; --
	--
	--	end process;

end architecture;


--