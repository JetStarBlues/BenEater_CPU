library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


-- Not generic, specific to Ben Eater CPU. For example, its
--  . Hardcoded for the BE_CPU instruction set architecture
--  . Hardcoded for the BE_CPU microcode encoding
--  . Hardcoded for 5 micro instructions per instruction

entity controlLogic is

	port (
		instruction : in std_logic_vector( N - 1 downto 0 );
		clk, clr : in std_logic;
		carryBit : in std_logic;

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
		programCounter_jump      : out std_logic
	);

end entity;


architecture ac of controlLogic is

	signal clock : std_logic;

	signal zero : std_logic_vector( N - 1 downto 0 ) := ( others => '0' );
	signal counterOut : std_logic_vector( N - 1 downto 0 );
	signal count5 : std_logic;  -- longest instruction has five micro instructions
	                            --  See https://youtu.be/X7rCxs1ppyY?t=7m40s
	                            --   Note: longest instruction shortened from 6 to 5 later in video
	signal resetCounter : std_logic;

	signal step : std_logic_vector( 2 downto 0 );
	signal stepDec : std_logic_vector( 7 downto 0 );
	signal offset : std_logic_vector( 3 downto 0 );

	signal controlBits_upperByte_addr, controlBits_lowerByte_addr : std_logic_vector( N - 1 downto 0 );
	signal controlBits_upperByte, controlBits_lowerByte : std_logic_vector( 7 downto 0 );

begin

	clock <= not clk;  -- inverted. Explanation at https://youtu.be/X7rCxs1ppyY?t=3m47s
	                   --  something about this leading main clock

	resetCounter <= clr or count5;

	count5 <= stepDec(5);  -- reset counter when step == 5
	                        --  Even though zero indexed count, we don't stop at 4 because
	                        --  clear is asynchronous/immediate

	offset <= instruction( 7 downto 4 );
	step <= counterOut( 2 downto 0 );

	controlBits_upperByte_addr <= ( 

		7          => '0',
		6 downto 3 => offset,
		2 downto 0 => step,
		others     => '0'
	);

	controlBits_lowerByte_addr <= (  -- Offset by 128 in ROM, see https://youtu.be/JUVt_KYAp-I?t=17m50s

		7          => '1',
		6 downto 3 => offset,
		2 downto 0 => step,
		others     => '0'
	);

	halt                     <= controlBits_upperByte(7);
	memoryAddressReg_in      <= controlBits_upperByte(6);
	memory_in                <= controlBits_upperByte(5);
	memory_out               <= controlBits_upperByte(4);
	instructionReg_out       <= controlBits_upperByte(3);
	instructionReg_in        <= controlBits_upperByte(2);
	ARegister_in             <= controlBits_upperByte(1);
	ARegister_out            <= controlBits_upperByte(0);

	ALU_out                  <= controlBits_lowerByte(7);
	ALU_subtract             <= controlBits_lowerByte(6);
	BRegister_in             <= controlBits_lowerByte(5);
	outputRegister_in        <= controlBits_lowerByte(4);
	programCounter_increment <= controlBits_lowerByte(3);
	programCounter_out       <= controlBits_lowerByte(2);
	programCounter_jump      <= controlBits_lowerByte(1);


	-- microcode ROM
	comp : microcode port map (

		controlBits_upperByte_addr,
		controlBits_lowerByte_addr,
		controlBits_upperByte,
		controlBits_lowerByte
	);
	
	-- step counter
	comp : counterXN    
	           generic map ( 3 )
	           port map    ( zero, '0', clock, resetCounter, '1', counterOut );

	comp : decoder3to8 port map ( step, stepDec );

end architecture;


-- See,
--  https://youtu.be/X7rCxs1ppyY
--  https://youtu.be/dHWFpkGsxOs
--  https://youtu.be/JUVt_KYAp-I