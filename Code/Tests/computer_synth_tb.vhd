-- Code by www.jk-quantized.com
-- Redistribution and use of this code in source and binary forms
-- must retain the above attribution notice and this condition.

library ieee;
use ieee.std_logic_1164.all;
use work.computer_synth;


entity computer_synth_tb is
end entity;


architecture ac of computer_synth_tb is

	signal clk, reset : std_logic := '0';
	signal tx : std_logic;
	signal leds : std_logic_vector( 2 downto 0 );

begin

	clk <= not clk after 1 ps;

	comp_computer_synth : entity computer_synth port map (

		clk,
		reset,
		tx,

		leds
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