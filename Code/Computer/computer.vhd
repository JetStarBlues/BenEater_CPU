library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components_pk.all;


entity computer is

	port (
		clock, reset : in  std_logic;
		outputRegOut : out std_logic_vector( N - 1 downto 0 )
	);

end entity;


architecture ac of computer is

	signal cpuClock : std_logic;

	signal hold  : std_logic := '1';

	signal databus : std_logic_vector( N - 1 downto 0 );

	signal memoryAddressRegister_in : std_logic;
	signal memory_in, memory_out : std_logic;


	-- Memory initialization helpers
	signal memoryReady : std_logic := '0';

	signal memClk : std_logic;
	signal memLoadAddr, memLoadData : std_logic;
	signal memLda, memLdd : std_logic;

	type states is ( sLoadAddr, sHoldAddr, sLoadData, sIncrementAddr );
	signal state : states := sLoadAddr;

	signal programLineNo : integer range 0 to programMemorySize - 1 := 0;
	signal pMemAddr : std_logic_vector( N - 1 downto 0 ) := ( others => '0' );
	signal pMemData : std_logic_vector( N - 1 downto 0 );

begin

	cpuClock <= '0' when memoryReady = '0' else clock;  -- rewrite as mux component

	comp_cpu : cpu port map (

		cpuClock,
		reset,
		hold,
		outputRegOut,

		databus,

		memoryAddressRegister_in,
		memory_in, memory_out
	);


	comp_mainMemory : memoryXN_oe
	generic map (

		memorySize
	)
	port map (

		databus,
		memClk,
		memLoadAddr,
		memLoadData,
		reset,
		memory_out
	);

	comp_programMemory : programMemoryX
	generic map (

		programMemorySize
	)
	port map (

		pMemAddr,
		pMemData
	);

	comp0 : mux2to1 port map (

		cpuClock,                  -- runtime control
		clock,                     -- startup control
		memoryReady,
		memClk
	);
	comp1 : mux2to1 port map (

		memoryAddressRegister_in,  -- runtime control
		memLda,                    -- startup control
		memoryReady,
		memLoadAddr
	);
	comp2 : mux2to1 port map (

		memory_in,                 -- runtime control
		memLdd,                    -- startup control
		memoryReady,
		memLoadData
	);

	-- The process below could also be specified at the component level
	--  using flip flops, multiplexers etc. but I'm feeling lazy and
	--  will instead let the synthesis tool come up with whatever
	--  circuitry it wants to accomplish the task.
	process ( clock )
	begin

		if rising_edge( clock ) then

			-- Load programMemory contents onto mainMemory
			if memoryReady = '0' then

				case state is

					-- Send address
					when sLoadAddr =>

						databus <= pMemAddr;

						memLda <= '1';
						memLdd <= '0';

						--state <= sLoadData;
						state <= sHoldAddr;

					when sHoldAddr =>

						memLda <= '0';
						memLdd <= '0';

						state <= sLoadData;

					-- Send data
					when sLoadData =>

						databus <= pMemData;

						memLda <= '0';
						memLdd <= '1';

						state <= sIncrementAddr;

					-- Increment address
					when sIncrementAddr =>

						memLda <= '0';
						memLdd <= '0';

						if programLineNo < programMemorySize - 1 then

							programLineNo <= programLineNo + 1;

							pMemAddr <= std_logic_vector( to_unsigned( programLineNo, N ) );

							state <= sLoadAddr;

						else

							memoryReady <= '1';  -- done!

							hold <= '0';

						end if;

					-- Should never get here
					when others =>

						null;

				end case;

			end if;

		end if;

	end process;

end architecture;