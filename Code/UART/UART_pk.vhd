-- Code by www.jk-quantized.com
-- Redistribution and use of this code in source and binary forms
-- must retain the above attribution notice and this condition.

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


	component singlePortDualAddressRAMXN is
		generic (
			X : integer;
			N : integer
		);
		port (
			clk    : in  std_logic;
			d      : in  std_logic_vector( N - 1 downto 0 );
			wrAddr : in  std_logic_vector( N - 1 downto 0 );
			wrEn   : in  std_logic;
			rdAddr : in  std_logic_vector( N - 1 downto 0 );
			q      : out std_logic_vector( N - 1 downto 0 )
		);
	end component;


	component FIFO is
		generic (
			N                : integer;
			depth            : integer;
			almostFullLevel  : integer;
			almostEmptyLevel : integer
		);
		port (
			clk, rst : in std_logic;

			wrEn     : in  std_logic;
			wrData   : in  std_logic_vector( N - 1 downto 0 );
			AF, full : out std_logic;

			rdEn      : in  std_logic;
			rdData    : out std_logic_vector( N - 1 downto 0 );
			AE, empty : out std_logic
		);

	end component;


end package;


--