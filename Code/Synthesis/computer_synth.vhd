-- Code by www.jk-quantized.com
-- Redistribution and use of this code in source and binary forms
-- must retain the above attribution notice and this condition.

library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;
use work.UART_pk.all;


entity computer_synth is

	port (

		clk   : in  std_logic;
		reset : in  std_logic;
		tx    : out std_logic;

		-- specific to development board
		leds : out std_logic_vector( 2 downto 0 )
	);

end entity;


architecture ac of computer_synth is

	-- Computer
	signal outputReady  : std_logic;
	signal outputRegOut : std_logic_vector( N - 1 downto 0 );

	-- UART
	--constant clksPerBit : integer := 26;    -- small value for testbench
	constant clksPerBit : integer := 434;   -- 50M Hz / 115200 Hz
	--constant clksPerBit : integer := 5208;  -- 50M Hz / 9600 Hz
	signal txActive, txDone : std_logic;

begin

	comp_computer : computer port map (

		clk,
		reset,
		txActive,
		outputReady,
		outputRegOut
	);

	comp_uartTX : UART_TX
	generic map (

		clksPerBit
	)
	port map (

		clk,
		outputReady,
		outputRegOut,
		tx,
		txActive,
		txDone
	);


	-- Specific to development board
	-- turn off onboard LEDs (active low)
	leds(0) <= '1';
	leds(1) <= '1';
	leds(2) <= '1';

end architecture;


--