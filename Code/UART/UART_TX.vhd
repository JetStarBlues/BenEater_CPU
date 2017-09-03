-- Code based on
--  https://www.nandland.com/goboard/uart-go-board-project-part2.html

-- Settings
--  8N1, baud rate set by generic

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity UART_TX is

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

end entity;


architecture ac of UART_TX is

	type states is ( sIdle, sStartBit, sDataBits, sStopBit );
	signal state : states := sIdle;

	signal clkCount : integer range 1 to clksPerBit := 1;
	signal bitIndex : integer range 0 to 7 := 0;
	signal data     : std_logic_vector( 7 downto 0 ) := ( others => '0' );

begin

	process ( clk )
	begin

		if rising_edge( clk ) then

			case state is

				when sIdle =>

					tx       <= '1';  -- drive high when idle
					txActive <= '0';
					txDone   <= '0';
					clkCount <= 1;
					bitIndex <= 0;

					if dataValid = '1' then

						data <= txData;  -- store data so not overwritten while we are transmitting it

						state <= sStartBit;

					else

						state <= sIdle;

					end if;

				-- Send start bit
				when sStartBit =>

					txActive <= '1';

					tx <= '0';  -- drive low

					if clkCount < clksPerBit then  -- hold for clksPerBit

						clkCount <= clkCount + 1;

						state <= sStartBit;

					else

						clkCount <= 1;

						state <= sDataBits;

					end if;

				-- Send data bits
				when sDataBits =>

					tx <= data( bitIndex );

					if clkCount < clksPerBit then  -- hold for clksPerBit

						clkCount <= clkCount + 1;

						state <= sDataBits;

					else

						clkCount <= 1;

						-- Check if we've transmitted all bits
						if bitIndex < 7 then

							bitIndex <= bitIndex + 1;

							state <= sDataBits;

						else

							bitIndex <= 0;

							state <= sStopBit;

						end if;

					end if;

				-- Send stop bit
				when sStopBit =>

					tx <= '1';  -- drive high

					if clkCount < clksPerBit then  -- hold for clksPerBit

						clkCount <= clkCount + 1;

						state <= sStopBit;

					else

						txDone <= '1';

						clkCount <= 1;

						state <= sIdle;

					end if;

				when others =>

					state <= sIdle;

			end case;

		end if;

	end process;

end architecture;


--