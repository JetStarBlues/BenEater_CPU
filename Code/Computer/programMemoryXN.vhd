library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components_pk.all;


entity programMemoryXN is

	generic (

		X : integer
	);

	port (

		addr : in  std_logic_vector( N - 1 downto 0 );
		q    : out std_logic_vector( N - 1 downto 0 )
	);

end entity;


architecture ac of programMemoryXN is

	type rom_type is array( 0 to X - 1 ) of std_logic_vector( N - 1 downto 0 );
	
	constant rom : rom_type := (

		-- Increment ( OUT = OUT + 1 ) (datatype - uint8)
		0 => "01010001",
		1 => "01001111",
		2 => "01010000",
		3 => "00101111",
		4 => "11100000",
		5 => "01100011",

		-- Multiples of 3 ( OUT = 3x ) (datatype - uint8)
		--0 => "01010011",
		--1 => "01001111",
		--2 => "01010000",
		--3 => "00101111",
		--4 => "11100000",
		--5 => "01100011",

		-- Arithmetic test ( OUT = 5 + 2 - 15 ) (datatype - int8)
		--0  => "01010101",
		--1  => "01001111",
		--2  => "01010010",
		--3  => "01001110",
		--4  => "01011111",
		--5  => "01001101",
		--6  => "00011111",
		--7  => "00101110",
		--8  => "00111101",
		--9  => "11100000",
		--10 => "11110000",

		-- Hello world ( OUT =  ) (datatype - ascii)
		--0  => "01010001",
		--1  => "01001111",
		--2  => "01010000",
		--3  => "01001110",
		--4  => "00011110",
		--5  => "00101111",
		--6  => "01001110",
		--7  => "11100000",
		--8  => "01011010",
		--9  => "11100000",
		--10 => "01100100",


		others => x"00"
	);

begin

	q <= rom( to_integer( unsigned( addr ) ) );

end architecture;


--