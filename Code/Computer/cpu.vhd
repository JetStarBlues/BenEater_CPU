-- Code by www.jk-quantized.com
-- Redistribution and use of this code in source and binary forms
-- must retain the above attribution notice and this condition.

library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity cpu is

	port (

		databus                    : inout std_logic_vector( N - 1 downto 0 );
		
		clock                      : in std_logic;
		reset                      : in std_logic;
		hold                       : in std_logic;  -- yield databus control to external device
		waitt                      : in std_logic;  -- suspend CPU
		
		outputReady                : out std_logic;
		outputRegisterOut          : out std_logic_vector( N - 1 downto 0 );

		c_memoryAddressRegister_in : out std_logic;
		c_memory_in                : out std_logic;
		c_memory_out               : out std_logic
	);

end entity;


architecture ac of cpu is

	-- 
	signal suspend : std_logic;

	-- Internal clocks
	signal clk : std_logic;

	-- Databus
	signal programCounter_oe      : std_logic;
	signal instructionRegister_oe : std_logic;
	signal ARegister_oe           : std_logic;
	signal ALU_oe                 : std_logic;

	-- Instruction
	signal instruction : std_logic_vector( N - 1 downto 0 );

	-- ALU
	signal fZero        : std_logic;
	signal fCarry       : std_logic;
	signal ALU_flags    : std_logic_vector( N - 1 downto 0 );
	signal ARegisterOut : std_logic_vector( N - 1 downto 0 );
	signal BRegisterOut : std_logic_vector( N - 1 downto 0 );
	signal FRegisterOut : std_logic_vector( N - 1 downto 0 );

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
	signal c_FRegister_in             : std_logic;

begin

	-- Suspend CPU
	suspend <= waitt or c_halt;
	clk     <= clock and not suspend;

	-- Disconnect from databus when hold = '1'
	programCounter_oe      <= c_programCounter_out      and not hold;
	instructionRegister_oe <= c_instructionRegister_out and not hold;
	ARegister_oe           <= c_ARegister_out           and not hold;
	ALU_oe                 <= c_ALU_out                 and not hold;

	-- Update status
	outputReady <= c_outputRegister_in;

	-- Compose flags byte
	ALU_flags <= "000000" & fZero & fCarry;  -- concatenate bits

	comp_control : controlLogic port map (

		instruction,
		clk,
		reset,
		FRegisterOut,

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
		c_programCounter_jump,
		c_FRegister_in
	);

	comp_programCounter : programCounterN_oe port map (

		databus,

		c_programCounter_jump,
		clk,
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
		clk,
		reset,
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

	comp_flagsRegister : registerN port map (

		ALU_flags,
		c_FRegister_in,
		clk,
		reset,

		FRegisterOut
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

		fZero,
		fCarry
	);

end architecture;


-- See schematic
--  https://github.com/kyllikki/eda-designs/blob/master/SAP-BE/sap-be.pdf