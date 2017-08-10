library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components_pk.all;


-- Since bespoke, may as well make it possible to retrieve two values simultaneously

entity microcode is

	port (
		addr_one : in  std_logic_vector( N - 1 downto 0 );
		addr_two : in  std_logic_vector( N - 1 downto 0 );
		q_one    : out std_logic_vector( 7 downto 0 );
		q_two    : out std_logic_vector( 7 downto 0 )
	);

end entity;


architecture ac of microcode is

	type rom_type is array( 255 downto 0 ) of std_logic_vector( 7 downto 0 );
	
	constant rom : rom_type := (

		x"40", x"14", x"00", x"00", x"00", x"00", x"00", x"00",
		x"40", x"14", x"48", x"12", x"00", x"00", x"00", x"00",
		x"40", x"14", x"48", x"10", x"02", x"00", x"00", x"00",
		x"40", x"14", x"48", x"10", x"02", x"00", x"00", x"00",
		x"40", x"14", x"48", x"21", x"00", x"00", x"00", x"00",
		x"40", x"14", x"0a", x"00", x"00", x"00", x"00", x"00",
		x"40", x"14", x"08", x"00", x"00", x"00", x"00", x"00",
		x"40", x"14", x"00", x"00", x"00", x"00", x"00", x"00",
		x"40", x"14", x"00", x"00", x"00", x"00", x"00", x"00",
		x"40", x"14", x"00", x"00", x"00", x"00", x"00", x"00",
		x"40", x"14", x"00", x"00", x"00", x"00", x"00", x"00",
		x"40", x"14", x"00", x"00", x"00", x"00", x"00", x"00",
		x"40", x"14", x"00", x"00", x"00", x"00", x"00", x"00",
		x"40", x"14", x"00", x"00", x"00", x"00", x"00", x"00",
		x"40", x"14", x"01", x"00", x"00", x"00", x"00", x"00",
		x"40", x"14", x"80", x"00", x"00", x"00", x"00", x"00",
		x"04", x"08", x"00", x"00", x"00", x"00", x"00", x"00",
		x"04", x"08", x"00", x"00", x"00", x"00", x"00", x"00",
		x"04", x"08", x"00", x"20", x"80", x"00", x"00", x"00",
		x"04", x"08", x"00", x"20", x"c0", x"00", x"00", x"00",
		x"04", x"08", x"00", x"00", x"00", x"00", x"00", x"00",
		x"04", x"08", x"00", x"00", x"00", x"00", x"00", x"00",
		x"04", x"08", x"02", x"00", x"00", x"00", x"00", x"00",
		x"04", x"08", x"00", x"00", x"00", x"00", x"00", x"00",
		x"04", x"08", x"00", x"00", x"00", x"00", x"00", x"00",
		x"04", x"08", x"00", x"00", x"00", x"00", x"00", x"00",
		x"04", x"08", x"00", x"00", x"00", x"00", x"00", x"00",
		x"04", x"08", x"00", x"00", x"00", x"00", x"00", x"00",
		x"04", x"08", x"00", x"00", x"00", x"00", x"00", x"00",
		x"04", x"08", x"00", x"00", x"00", x"00", x"00", x"00",
		x"04", x"08", x"10", x"00", x"00", x"00", x"00", x"00",
		x"04", x"08", x"00", x"00", x"00", x"00", x"00", x"00"
	);


begin

	q_one <= rom( to_integer( unsigned( addr_one ) ) );
	q_two <= rom( to_integer( unsigned( addr_two ) ) );

end architecture;


-- See https://youtu.be/JUVt_KYAp-I