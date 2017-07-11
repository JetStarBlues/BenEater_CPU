library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity cpu is

	port (
		clk, reset   : in  std_logic;
		outputRegOut : out std_logic_vector( N - 1 downto 0 )
	);

end entity;


architecture ac of cpu is

	signal databus : std_logic_vector( N - 1 downto 0 );

	-- Instruction
	signal instruction : std_logic_vector( N - 1 downto 0 );

	-- ALU
	signal carryBit : std_logic;
	signal ARegOut, BRegOut : std_logic_vector( N - 1 downto 0 );

	-- Control
	halt                     : std_logic;
	memoryAddressReg_in      : std_logic;
	memory_in                : std_logic;
	memory_out               : std_logic;
	instructionReg_out       : std_logic;
	instructionReg_in        : std_logic;
	ARegister_in             : std_logic;
	ARegister_out            : std_logic;
	ALU_out                  : std_logic;
	ALU_subtract             : std_logic;
	BRegister_in             : std_logic;
	outputRegister_in        : std_logic;
	programCounter_increment : std_logic;
	programCounter_out       : std_logic;
	programCounter_jump      : std_logic;

begin

	comp_control : controlLogic port map (

		instruction,
		clk,
		reset,
		carryBit,

		halt,
		memoryAddressReg_in,
		memory_in,
		memory_out,
		instructionReg_out,
		instructionReg_in,
		ARegister_in,
		ARegister_out,
		ALU_out,
		ALU_subtract,
		BRegister_in,
		outputRegister_in,
		programCounter_increment,
		programCounter_out,
		programCounter_jump
	);

	comp_memory : memoryXN_oe
	generic map (

		memSize
	)
	port map (

		databus,
		clk,
		memoryAddressReg_in,
		memory_in,
		reset,
		memory_out
	);

	comp_programCounter : programCounterN_oe port map (

		databus,
		programCounter_jump,
		clk,
		reset,
		programCounter_increment,
		programCounter_out,
		open

	);

	comp_instructionReg : registerN_oe port map (

		databus,
		instructionReg_in,
		clk,
		reset,
		instructionReg_out,
		instruction
	);

	comp_AReg : registerN_oe port map (

		databus,
		ARegister_in,
		clk,
		reset,
		ARegister_out,
		ARegOut
	);

	comp_BReg : registerN_oe port map (

		databus,
		BRegister_in,
		clk,
		reset,
		'0',
		BRegOut
	);

	comp_outputReg : registerN_oe port map (

		databus,
		outputRegister_in,
		clk,
		reset,
		'0',
		outputRegOut
	);

	comp_ALU : aluN_oe port map (

		databus,
		ARegOut,
		BRegOut,
		ALU_subtract,
		ALU_out,
		carryBit
	);

end architecture;


-- See https://github.com/kyllikki/eda-designs/blob/master/SAP-BE/sap-be.pdf