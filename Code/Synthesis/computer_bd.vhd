library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;
use work.UART_TX;


entity computer_bd is

	port (

		clk   : in  std_logic;
		reset : in  std_logic;
		tx    : out std_logic
	);

end entity;


architecture ac of computer_bd is

	signal outputReady  : std_logic;
	signal outputRegOut : std_logic_vector( N - 1 downto 0 );

begin

	comp_computer : computer port map (

		clk,
		reset,
		outputReady,
		outputRegOut
	);

	comp_uartTX : UART_TX
	generic map (

		434  -- 50M Hz / 115200 Hz
	)
	port map (

		clk,
		outputReady,
		outputRegOut,
		tx,
		open,
		open
	);

end architecture;


--