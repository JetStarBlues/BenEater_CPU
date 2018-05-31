-- Code by www.jk-quantized.com
-- Redistribution and use of this code in source and binary forms
-- must retain the above attribution notice and this condition.

library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


-- Not generic, specific to Ben Eater Computer. For example, it is
--  . Hardcoded for the BE_Computer instruction set architecture
--  . Hardcoded for the BE_Computer microcode encoding
--  . Hardcoded for 5 micro instructions per instruction


entity controlLogic is

	port (

		instruction              : in std_logic_vector( N - 1 downto 0 );
		clk, clr                 : in std_logic;
		flags                    : in std_logic_vector( N - 1 downto 0 );

		halt                     : out std_logic;
		memoryAddressReg_in      : out std_logic;
		memory_in                : out std_logic;
		memory_out               : out std_logic;
		instructionReg_out       : out std_logic;
		instructionReg_in        : out std_logic;
		ARegister_in             : out std_logic;
		ARegister_out            : out std_logic;
		ALU_out                  : out std_logic;
		ALU_subtract             : out std_logic;
		BRegister_in             : out std_logic;
		outputRegister_in        : out std_logic;
		programCounter_increment : out std_logic;
		programCounter_out       : out std_logic;
		programCounter_jump      : out std_logic;
		FRegister_in             : out std_logic
	);

end entity;


architecture ac of controlLogic is

	signal clock : std_logic;

	-- longest instruction has five micro instructions
	--  See https://youtu.be/X7rCxs1ppyY?t=7m40s
	--  Note, longest instruction shortened from 6 to 5 later in video
	signal counted5       : std_logic;
	signal resetCounter   : std_logic;
	signal stepCounterOut : std_logic_vector( N - 1 downto 0 );
	signal step           : std_logic_vector( 2 downto 0 );
	signal stepDecoded    : std_logic_vector( 7 downto 0 );

	signal opcode                                       : std_logic_vector( 3 downto 0 );
	signal microcodeAddr_upper, microcodeAddr_lower     : std_logic_vector( 9 downto 0 );
	signal controlBits_upperByte, controlBits_lowerByte : std_logic_vector( 7 downto 0 );

	signal flagss : std_logic_vector( 1 downto 0 );

begin

	clock <= not clk;  -- inverted. Explanation at https://youtu.be/X7rCxs1ppyY?t=3m47s
	                   --  something about this leading main clock

	resetCounter <= clr or counted5;

	counted5 <= stepDecoded( 5 );  -- reset counter when step == 5
	                             --  Even though zero indexed count, we don't stop at 4 because
	                             --  clear is asynchronous/immediate

	-- microinstruction called depends on opcode, step, and status of flags
	step   <= stepCounterOut( 2 downto 0 );
	opcode <= instruction( 7 downto 4 );
	flagss <= flags( 1 downto 0 );


	microcodeAddr_upper <= '0' & flagss & opcode & step;
	microcodeAddr_lower <= '1' & flagss & opcode & step;  -- Offset in ROM, see https://youtu.be/JUVt_KYAp-I?t=17m50s

	halt                     <= controlBits_upperByte( 7 ) and not clr;
	memoryAddressReg_in      <= controlBits_upperByte( 6 ) and not clr;
	memory_in                <= controlBits_upperByte( 5 ) and not clr;
	memory_out               <= controlBits_upperByte( 4 ) and not clr;
	instructionReg_out       <= controlBits_upperByte( 3 ) and not clr;
	instructionReg_in        <= controlBits_upperByte( 2 ) and not clr;
	ARegister_in             <= controlBits_upperByte( 1 ) and not clr;
	ARegister_out            <= controlBits_upperByte( 0 ) and not clr;

	ALU_out                  <= controlBits_lowerByte( 7 ) and not clr;
	ALU_subtract             <= controlBits_lowerByte( 6 ) and not clr;
	BRegister_in             <= controlBits_lowerByte( 5 ) and not clr;
	outputRegister_in        <= controlBits_lowerByte( 4 ) and not clr;
	programCounter_increment <= controlBits_lowerByte( 3 ) and not clr;
	programCounter_out       <= controlBits_lowerByte( 2 ) and not clr;
	programCounter_jump      <= controlBits_lowerByte( 1 ) and not clr;
	FRegister_in             <= controlBits_lowerByte( 0 ) and not clr;


	-- Microcode ROM
	comp0 : microcode port map (

		microcodeAddr_upper,
		microcodeAddr_lower,
		controlBits_upperByte,
		controlBits_lowerByte
	);
	
	-- Step counter
	comp1 : counterXN    
	           generic map ( 3 )
	           port map    ( zero, '0', clock, resetCounter, '1', stepCounterOut );

	-- Step decoder
	comp2 : decoder3to8 port map ( step, stepDecoded );

end architecture;


-- See,
--  https://youtu.be/X7rCxs1ppyY
--  https://youtu.be/dHWFpkGsxOs
--  https://youtu.be/JUVt_KYAp-I