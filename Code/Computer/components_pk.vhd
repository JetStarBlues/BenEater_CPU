-- Code by www.jk-quantized.com
-- Redistribution and use of this code in source and binary forms
-- must retain the above attribution notice and this condition.

library ieee;
use ieee.std_logic_1164.all;


package components_pk is


	--- Configure ---

	constant N                 : integer := 8;    -- number of bits
	constant memorySize        : integer := 256;  -- size in words
	constant programMemorySize : integer := 256;  -- size in words


	--- General ---

	constant zero : std_logic_vector( N - 1 downto 0 ) := ( others => '0' );


	component bufferr is
		port (
			d, oe : in  std_logic;
			q     : out std_logic
		);
	end component;


	component bufferN is
		port (
			d  : in  std_logic_vector( N - 1 downto 0 );
			oe : in  std_logic;
			q  : out std_logic_vector( N - 1 downto 0 )
		);
	end component;
	

	component decoder3to8 is
		port (
			d : in  std_logic_vector( 2 downto 0 );
			q : out std_logic_vector( 7 downto 0 )
		);
	end component;


	component mux2to1 is
		port (
			d1, d0 : in std_logic;
			s      : in std_logic;
			q      : out std_logic
		);
	end component;


	component muxN2to1 is
		port (
			d1, d0 : in std_logic_vector( N - 1 downto 0 );
			s      : in std_logic;
			q      : out std_logic_vector( N - 1 downto 0 )
		);
	end component;


	component orNto1 is
		port (
			d : in  std_logic_vector( N - 1 downto 0 );
			q : out std_logic
		);
	end component;


	component divFreqBy2 is
		port (
			d : in  std_logic;
			q : out std_logic
		);
	end component;


	--- Memory ---

	component dFlipFlop is
		port (
			d, e, clk : in  std_logic;
			clr       : in  std_logic;
			q         : out std_logic
		);
	end component;


	component registerN is
		port (
			d              : in  std_logic_vector( N - 1 downto 0 );
			load, clk, clr : in  std_logic;
			q              : out std_logic_vector( N - 1 downto 0 )
		);
	end component;


	component registerN_oe is
		port (
			databus        : inout std_logic_vector( N - 1 downto 0 );
			load, clk, clr : in    std_logic;
			out_enable     : in    std_logic;
			q              : out   std_logic_vector( N - 1 downto 0 )
		);
	end component;


	component registerN_IR_oe is
		port (
			databus        : inout std_logic_vector( N - 1 downto 0 );
			load, clk, clr : in    std_logic;
			out_enable     : in    std_logic;
			q              : out   std_logic_vector( N - 1 downto 0 )
		);
	end component;


	component singlePortRAMXN is
		generic (
			X : integer
		);
		port (
			clk     : in  std_logic;
			d, addr : in  std_logic_vector( N - 1 downto 0 );
			load    : in  std_logic;
			q       : out std_logic_vector( N - 1 downto 0 )
		);
	end component;


	component memoryXN is
		generic (
			X : integer
		);
		port (
			d          : in  std_logic_vector( N - 1 downto 0 );
			clk        : in  std_logic;
			loadAddr   : in  std_logic;
			loadData   : in  std_logic;
			clrAddr    : in  std_logic;
			q          : out std_logic_vector( N - 1 downto 0 )
		);

	end component;


	component memoryXN_oe is
		generic (
			X : integer
		);
		port (
			databus    : inout std_logic_vector( N - 1 downto 0 );
			clk        : in    std_logic;
			loadAddr   : in    std_logic;
			loadData   : in    std_logic;
			clrAddr    : in    std_logic;
			out_enable : in    std_logic
		);
	end component;


	component microcode is
		port (
			addr_one : in  std_logic_vector( 9 downto 0 );
			addr_two : in  std_logic_vector( 9 downto 0 );
			q_one    : out std_logic_vector( 7 downto 0 );
			q_two    : out std_logic_vector( 7 downto 0 )
		);
	end component;


	component programMemoryXN is
		generic (
			X : integer
		);
		port (
			addr : in  std_logic_vector( N - 1 downto 0 );
			q    : out std_logic_vector( N - 1 downto 0 )
		);
	end component;


	--- Arithmetic ---

	component isZeroN is
		port (
			d : in  std_logic_vector( N - 1 downto 0 );
			q : out std_logic
		);
	end component;


	component halfAdder is
		port (
			a, b       : in  std_logic;
			sum, carry : out std_logic
		);
	end component;


	component fullAdder is
		port (
			a, b, cIn : in  std_logic;
			sum, cOut : out std_logic
		);
	end component;


	component rippleCarryAdderN is
		port (
			a, b : in  std_logic_vector( N - 1 downto 0 );
			cIn  : in  std_logic;
			sum  : out std_logic_vector( N - 1 downto 0 );
			cOut : out std_logic
		);
	end component;


	component aluN is
		port (
			da, db   : in  std_logic_vector( N - 1 downto 0 );
			subtract : in  std_logic;
			q        : out std_logic_vector( N - 1 downto 0 );
			fZero    : out std_logic;
			fCarry   : out std_logic
		);
	end component;


	component aluN_oe is
		port (
			databus    : inout std_logic_vector( N - 1 downto 0 );
			da, db     : in    std_logic_vector( N - 1 downto 0 );
			subtract   : in    std_logic;
			out_enable : in    std_logic;
			fZero      : out   std_logic;
			fCarry     : out   std_logic
		);
	end component;


	--- Counters ---

	component incrementXN is
		generic (
			X : integer
		);
		port (
			d : in  std_logic_vector( N - 1 downto 0 );
			q : out std_logic_vector( N - 1 downto 0 )
		);
	end component;


	component counterXN is
		generic (
			X : integer
		);
		port (
			d              : in  std_logic_vector( N - 1 downto 0 );
			load, clk, clr : in  std_logic;
			increment      : in  std_logic;
			q              : out std_logic_vector( N - 1 downto 0 )
		);
	end component;


	component programCounterN_oe is
		port (
			databus        : inout std_logic_vector( N - 1 downto 0 );
			load, clk, clr : in    std_logic;
			increment      : in    std_logic;
			out_enable     : in    std_logic
		);
	end component;


	--- CPU ---

	component controlLogic is
		port (
			instruction : in std_logic_vector( N - 1 downto 0 );
			clk, clr    : in std_logic;
			flags       : in std_logic_vector( N - 1 downto 0 );

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
	end component;


	component cpu is
		port (
			databus : inout std_logic_vector( N - 1 downto 0 );
			
			clock : in std_logic;
			reset : in std_logic;
			hold  : in std_logic;
			waitt : in std_logic;
			
			outputReady                : out std_logic;
			outputRegisterOut          : out std_logic_vector( N - 1 downto 0 );

			c_memoryAddressRegister_in : out std_logic;
			c_memory_in                : out std_logic;
			c_memory_out               : out std_logic
		);
	end component;


	--- Computer ---

	component computer is
		port (
			clock        : in  std_logic;
			reset        : in  std_logic;
			waitt        : in  std_logic;
			outputReady  : out std_logic;
			outputRegOut : out std_logic_vector( N - 1 downto 0 )
		);
	end component;


end package;


--