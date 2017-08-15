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

	comp_computer_synth : entity computer_synth port map (

		clk,
		reset,
		tx,

		leds
	);

	clk <= not clk after 1 ps;

end architecture;


--