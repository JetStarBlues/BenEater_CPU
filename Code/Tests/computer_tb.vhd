library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity computer_tb is
end entity;


architecture ac of computer_tb is

	signal clk, reset   : std_logic := '0';
	signal outputReady  : std_logic;
	signal outputRegOut : std_logic_vector( N - 1 downto 0 );

begin

	comp_computer : computer port map (

		clk,
		reset,
		outputReady,
		outputRegOut
	);

	clk <= not clk after 1 ps;

end architecture;


--