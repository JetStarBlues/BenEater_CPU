library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components_pk.all;


entity programMemoryX is

	generic (
		X : integer
	);

	port (
		addr : in  std_logic_vector( N - 1 downto 0 );
		q    : out std_logic_vector( N - 1 downto 0 )
	);

end entity;


architecture ac of programMemoryX is

	type rom_type is array( 0 to X - 1 ) of std_logic_vector( N - 1 downto 0 );
	
	constant rom : rom_type := (

		0 => "01010011",
		1 => "01001111",
		2 => "01010000",
		3 => "00101111",
		4 => "11100000",
		5 => "01100011",

		others => x"00"
	);


begin

	q <= rom( to_integer( unsigned( addr ) ) );

end architecture;


--