library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
use work.components_pk.all;


entity cpu is

	port (
		clock, reset      : in std_logic;
		hold              : in std_logic;  -- yield databus control to external device
		outputRegisterOut : out std_logic_vector( N - 1 downto 0 );
		
		databus : inout std_logic_vector( N - 1 downto 0 );

		c_memoryAddressRegister_in : out std_logic;
		c_memory_in                : out std_logic;
		c_memory_out               : out std_logic
	);

end entity;


architecture ac of cpu is

	-- Halt
	--signal haltCPU : std_logic;

	-- Internal clock
	signal clk : std_logic;

	-- Databus
	signal programCounter_oe      : std_logic;
	signal instructionRegister_oe : std_logic;
	signal ARegister_oe           : std_logic;
	signal ALU_oe                 : std_logic;
	--signal databus : std_logic_vector( N - 1 downto 0 );

	-- Instruction
	signal instruction : std_logic_vector( N - 1 downto 0 );

	-- ALU
	signal carryBit : std_logic;
	signal ARegisterOut, BRegisterOut : std_logic_vector( N - 1 downto 0 );

	-- Control
	signal c_halt                     : std_logic;
	--signal c_memoryAddressRegister_in : std_logic;
	--signal c_memory_in                : std_logic;
	--signal c_memory_out               : std_logic;
	signal c_instructionRegister_out  : std_logic;
	signal c_instructionRegister_in   : std_logic;
	signal c_ARegister_in             : std_logic;
	signal c_ARegister_out            : std_logic;
	signal c_ALU_out                  : std_logic;
	signal c_ALU_subtract             : std_logic;
	signal c_BRegister_in             : std_logic;
	signal c_outputRegister_in        : std_logic;
	signal c_programCounter_increment : std_logic;
	signal c_programCounter_out       : std_logic;
	signal c_programCounter_jump      : std_logic;


	-- Memory initialization helpers
	--signal memoryReady : std_logic := '0';

	--signal memClk, memLoadAddr, memLoadData : std_logic;

	--type states is ( sLoadAddr, sLoadData, sIncrementAddr );
	--signal state : states := sLoadAddr;

	--signal programLineNo : integer range 0 to programMemorySize - 1 := 0;
	--signal pMemAddr : std_logic_vector( N - 1 downto 0 ) := ( others => '0' );
	--signal pMemData : std_logic_vector( N - 1 downto 0 );
	--signal memLda, memLdd : std_logic;

begin

	clk <= clock and not c_halt;  -- halt disables clk
	--clk <= clock and not haltCPU;  -- halt disables clk

	--haltCPU <= '1' when memoryReady = '0' else halt;

	-- Disconnect from databus when hold = '1'
	programCounter_oe      <= c_programCounter_out      and not hold;
	instructionRegister_oe <= c_instructionRegister_out and not hold;
	ARegister_oe           <= c_ARegister_out           and not hold;
	ALU_oe                 <= c_ALU_out                 and not hold;

	comp_control : controlLogic port map (

		instruction,
		clk,
		reset,
		carryBit,

		c_halt,
		c_memoryAddressRegister_in,
		c_memory_in,
		c_memory_out,
		c_instructionRegister_out,
		c_instructionRegister_in,
		c_ARegister_in,
		c_ARegister_out,
		c_ALU_out,
		c_ALU_subtract,
		c_BRegister_in,
		c_outputRegister_in,
		c_programCounter_increment,
		c_programCounter_out,
		c_programCounter_jump
	);

	comp_programCounter : programCounterN_oe port map (

		databus,
		c_programCounter_jump,
		clk,
		reset,
		c_programCounter_increment,
		--c_programCounter_out
		programCounter_oe
	);

	comp_instructionRegister : registerN_IR_oe port map (

		databus,
		c_instructionRegister_in,
		clk,
		reset,
		--c_instructionRegister_out,
		instructionRegister_oe,
		instruction
	);

	comp_ARegister : registerN_oe port map (

		databus,
		c_ARegister_in,
		clk,
		reset,
		--c_ARegister_out,
		ARegister_oe,
		ARegisterOut
	);

	comp_BRegister : registerN_oe port map (

		databus,
		c_BRegister_in,
		clk,
		reset,
		'0',
		BRegisterOut
	);

	comp_outputRegister : registerN_oe port map (

		databus,
		c_outputRegister_in,
		clk,
		reset,
		'0',
		outputRegisterOut
	);

	comp_ALU : aluN_oe port map (

		databus,
		ARegisterOut,
		BRegisterOut,
		c_ALU_subtract,
		--c_ALU_out,
		ALU_oe,
		carryBit
	);

	--comp_mainMemory : memoryXN_oe
	--generic map (

	--	memorySize
	--)
	--port map (

	--	databus,
	--	clk,
	--	memoryAddressReg_in,
	--	memory_in,
	--	reset,
	--	memory_out
	--);

	-- ====================================================================

	-- Facilitate loading of user program onto main memory at startup
	--  Can be bypassed if store program and data in different locations...
	--  Revisit if Ben Eater changes CPU design accordingly

	--comp_mainMemory : memoryXN_oe
	--generic map (

	--	memorySize
	--)
	--port map (

	--	databus,
	--	memClk,
	--	memLoadAddr,
	--	memLoadData,
	--	reset,
	--	memory_out
	--);

	--comp_programMemory : programMemoryX
	--generic map (

	--	programMemorySize
	--)
	--port map (

	--	pMemAddr,
	--	pMemData
	--);

	--comp0 : mux2to1 port map (

	--	clock,                -- startup control
	--	clk,                  -- runtime control
	--	memoryReady,
	--	memClk
	--);
	--comp1 : mux2to1 port map (

	--	memLda,               -- startup control
	--	memoryAddressReg_in,  -- runtime control
	--	memoryReady,
	--	memLoadAddr
	--);
	--comp2 : mux2to1 port map (

	--	memLdd,               -- startup control
	--	memory_in,            -- runtime control
	--	memoryReady,
	--	memLoadData
	--);

	---- The process below could also be specified at the component level
	----  using flip flops, multiplexers etc. but I'm feeling lazy and
	----  will instead let the synthesis tool come up with whatever
	----  circuitry it wants to accomplish the task.
	--process ( clock )
	--begin

	--	if rising_edge( clock ) then

	--		-- Load programMemory contents onto mainMemory
	--		if memoryReady = '0' then

	--			case state is

	--				-- Send address
	--				when sLoadAddr =>

	--					databus <= pMemAddr;

	--					memLda <= '1';
	--					memLdd <= '0';

	--					state <= sLoadData;

	--				-- Send data
	--				when sLoadData =>

	--					databus <= pMemData;

	--					memLda <= '0';
	--					memLdd <= '1';

	--					state <= sIncrementAddr;

	--				-- Increment address
	--				when sIncrementAddr =>

	--					memLda <= '0';
	--					memLdd <= '0';

	--					if programLineNo < programMemorySize - 1 then

	--						programLineNo <= programLineNo + 1;

	--						pMemAddr <= std_logic_vector( to_unsigned( programLineNo, N ) );

	--						state <= sLoadAddr;

	--					else

	--						memoryReady <= '1';  -- done!

	--					end if;

	--				-- Should never get here
	--				when others =>

	--					null;

	--			end case;

	--		end if;

	--	end if;

	--end process;

end architecture;


-- See schematic
--  https://github.com/kyllikki/eda-designs/blob/master/SAP-BE/sap-be.pdf