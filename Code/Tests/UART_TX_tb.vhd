library ieee;
use ieee.std_logic_1164.all;
use work.UART_pk.all;
use ieee.numeric_std.all;


entity UART_TX_tb is
end entity;


architecture ac of UART_TX_tb is

	signal clk : std_logic := '0';
	signal dataValid  : std_logic;
	signal txData : std_logic_vector( 7 downto 0 );
	signal tx, txActive, txDone : std_logic;

	signal char : integer range 0 to 127 := 0;
	type states is ( sSend, sHold );
	signal state : states := sSend;

	constant clksPerBit : integer := 1;
	constant nPacketBits : integer := 10;
	signal clkCount : integer range 1 to clksPerBit * nPacketBits := 1;

begin

	comp_uartTx : UART_TX 
	generic map (

		clksPerBit
	)
	port map (

		clk,
		dataValid,
		txData,
		tx,
		txActive,
		txDone
	);

	clk <= not clk after 1 ps;

	process( clk )
	begin

		if rising_edge( clk ) then

			if state = sSend then

				if char < 127 then

					char <= char + 1;

				else

					char <= 32;

				end if;

				dataValid <= '1';
				txData <= std_logic_vector( to_unsigned( char, 8 ) );

				state <= sHold;

			elsif state = sHold then
				
				dataValid <= '0';

				-- hold for clksPerBit * nPacketBits
				if clkCount < clksPerBit * nPacketBits then

					clkCount <= clkCount + 1;

					state <= sHold;

				else

					clkCount <= 1;

					state <= sSend;

				end if;				

			else

				null;

			end if;

		end if;

	end process;


end architecture;


--