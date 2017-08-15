library ieee;
use ieee.std_logic_1164.all;


package UART_pk is

	component UART_TX is
		generic (
			clksPerBit : integer  -- Frequency of clk / Frequency of communication (baud rate)
		);
		port (
			clk              : in  std_logic;
			dataValid        : in std_logic;
			txData           : in  std_logic_vector( 7 downto 0 );
			tx               : out std_logic;
			txActive, txDone : out std_logic
		);
	end component;


end package;


--