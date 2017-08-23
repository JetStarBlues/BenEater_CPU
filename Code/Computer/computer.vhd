library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components_pk.all;


entity computer is

	port (

		clock        : in  std_logic;
		reset        : in  std_logic;
		waitt        : in  std_logic;  -- 'wait' (spelled properly) is a reserved keyword
		outputReady  : out std_logic;
		outputRegOut : out std_logic_vector( N - 1 downto 0 )
	);

end entity;


architecture ac of computer is

	-- CPU
	signal databus : std_logic_vector( N - 1 downto 0 ) := ( others => '0' );
	signal cpuHold, cpuWait : std_logic;
	signal memoryAddressRegister_in : std_logic;
	signal memory_in, memory_out : std_logic;

	-- Memory initialization helpers
	signal memoryNotReady : std_logic := '1';
	signal override : std_logic_vector( N - 1 downto 0 );
	signal memLoadAddr, memLoadData : std_logic;
	signal memLda, memLdd : std_logic;

	type states is ( sLoadAddr, sValid, sLoadData, sIncrementAddr );
	signal state : states := sLoadAddr;
	signal nxtState : states := sLoadData;

	signal programLineNo : integer range 0 to programMemorySize := 0;
	signal pMemAddr : std_logic_vector( N - 1 downto 0 ) := ( others => '0' );
	signal pMemData : std_logic_vector( N - 1 downto 0 );

begin

	cpuHold <= memoryNotReady;  -- yield databus
	--cpuWait <= '1' when memoryNotReady = '1' else waitt;  -- suspend CPU

	comp_cpuWait : mux2to1 port map (

		'1',
		waitt,
		memoryNotReady,
		cpuWait
	);

	comp_cpu : cpu port map (

		databus,

		clock,
		reset,
		cpuHold,
		cpuWait,

		outputReady,
		outputRegOut,

		memoryAddressRegister_in,
		memory_in,
		memory_out
	);

	comp_mainMemory : memoryXN_oe
	generic map (

		memorySize
	)
	port map (

		databus,
		clock,
		memLoadAddr,
		memLoadData,
		reset,
		memory_out
	);

	comp_programMemory : programMemoryXN
	generic map (

		programMemorySize
	)
	port map (

		pMemAddr,
		pMemData
	);

	-- Initialize main memory
	comp_st0 : bufferN port map (

		override,                  -- startup control
		memoryNotReady,
		databus
	);
	comp_st1 : mux2to1 port map (

		memLda,                    -- startup control
		memoryAddressRegister_in,  -- runtime control
		memoryNotReady,
		memLoadAddr
	);
	comp_st2 : mux2to1 port map (

		memLdd,                    -- startup control
		memory_in,                 -- runtime control
		memoryNotReady,
		memLoadData
	);

	-- The process below initializes main memory
	--  The process could also be specified at the component level
	--  using flip flops, multiplexers etc. but I'm feeling lazy and
	--  will instead let the synthesis tool come up with whatever
	--  circuitry it wants to accomplish the task.
	process ( clock )
	begin

		if rising_edge( clock ) then

			-- Load programMemory contents onto mainMemory
			if memoryNotReady = '1' then

				case state is

					-- Hold before going to next
					when sValid =>

						memLda <= '0';
						memLdd <= '0';

						state <= nxtState;


					-- Send address
					when sLoadAddr =>

						memLda <= '1';
						memLdd <= '0';

						override <= pMemAddr;

						nxtState <= sLoadData;

						state <= sValid;


					-- Send data
					when sLoadData =>

						memLda <= '0';
						memLdd <= '1';

						override <= pMemData;

						nxtState <= sIncrementAddr;

						state <= sValid;


					-- Increment address
					when sIncrementAddr =>

						memLda <= '0';
						memLdd <= '0';


						if programLineNo < programMemorySize then

							programLineNo <= programLineNo + 1;

							pMemAddr <= std_logic_vector( to_unsigned( programLineNo, N ) );

							nxtState <= sLoadAddr;

							state <= sValid;

						else

							memoryNotReady <= '0';  -- done!

						end if;


					-- Should never get here
					when others =>

						null;

				end case;

			end if;

		end if;

	end process;

end architecture;


--