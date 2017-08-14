library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity cpu is

	port (
		databus : inout std_logic_vector( N - 1 downto 0 );
		
		clock, reset : in std_logic;
		hold         : in std_logic;  -- yield databus control to external device
		
		outputUpdated              : out std_logic;
		outputRegisterOut          : out std_logic_vector( N - 1 downto 0 );

		c_memoryAddressRegister_in : out std_logic;
		c_memory_in                : out std_logic;
		c_memory_out               : out std_logic
	);

end entity;


architecture ac of cpu is

	-- Internal clocks
	signal clk, clk2 : std_logic;

	-- Databus
	signal programCounter_oe      : std_logic;
	signal instructionRegister_oe : std_logic;
	signal ARegister_oe           : std_logic;
	signal ALU_oe                 : std_logic;

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

begin

	clk <= clock and not c_halt;  -- halt disables clk

	-- Disconnect from databus when hold = '1'
	programCounter_oe      <= c_programCounter_out      and not hold;
	instructionRegister_oe <= c_instructionRegister_out and not hold;
	ARegister_oe           <= c_ARegister_out           and not hold;
	ALU_oe                 <= c_ALU_out                 and not hold;

	outputUpdated <= c_outputRegister_in;  -- use to indicate new output


	comp_divClock : divFreqBy2 port map (

		clk,
		clk2
	);

	comp_control : controlLogic port map (

		instruction,
		clk2,
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
		clk2,
		reset,
		c_programCounter_increment,
		programCounter_oe
	);

	comp_instructionRegister : registerN_IR_oe port map (

		databus,
		c_instructionRegister_in,
		clk,
		reset,
		instructionRegister_oe,
		instruction
	);

	comp_ARegister : registerN_oe port map (

		databus,
		c_ARegister_in,
		clk2,
		reset,
		ARegister_oe,
		ARegisterOut
	);

	comp_BRegister : registerN_oe port map (

		databus,
		c_BRegister_in,
		clk2,
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
		ALU_oe,
		carryBit
	);

end architecture;


-- See schematic
--  https://github.com/kyllikki/eda-designs/blob/master/SAP-BE/sap-be.pdf