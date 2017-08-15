library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;
use work.UART_pk.all;


use ieee.numeric_std.all;


entity computer_synth is

	port (

		clk   : in  std_logic;
		reset : in  std_logic;
		tx    : out std_logic;

		leds : out std_logic_vector( 2 downto 0 )
		--mLeds : out std_logic_vector( 7 downto 0 )
	);

end entity;


architecture ac of computer_synth is

	--signal reset : std_logic := '0';

	signal outputReady  : std_logic;
	signal outputRegOut : std_logic_vector( N - 1 downto 0 );

	--signal txActive, txDone : std_logic;

	--signal char : integer range 32 to 127 := 65;
	--type states is ( sSend, sHold );
	--signal state : states := sSend;

	--constant clksPerBit : integer := 434;
	--constant nPacketBits : integer := 10;
	--signal clkCount : integer range 1 to clksPerBit * nPacketBits := 1;

begin

	-- turn off (active low)
	leds(0) <= '1';
	leds(1) <= '1';
	leds(2) <= '1';

	comp_computer : computer port map (

		clk,
		reset,
		outputReady,
		outputRegOut
	);

	comp_uartTX : UART_TX
	generic map (

		434  -- 50M Hz / 115200 Hz
		--5208   -- 50M Hz / 9600 Hz
	)
	port map (

		clk,
		outputReady,
		outputRegOut,
		tx,
		open,
		open
	);


	-- Quickly test UART
	--process( clk )
	--begin

	--	if rising_edge( clk ) then

	--		if state = sSend then

	--			if char < 127 then

	--				char <= char + 1;

	--			else

	--				char <= 32;

	--			end if;

	--			outputReady <= '1';
	--			outputRegOut <= std_logic_vector( to_unsigned( char, 8 ) );

	--			state <= sHold;

	--		elsif state = sHold then
				
	--			outputReady <= '0';

	--			-- hold for clksPerBit * nPacketBits
	--			if clkCount < clksPerBit * nPacketBits then

	--				clkCount <= clkCount + 1;

	--				state <= sHold;

	--			else

	--				clkCount <= 1;

	--				state <= sSend;

	--			end if;				

	--		else

	--			null;

	--		end if;

	--	end if;

	--end process;


end architecture;


--