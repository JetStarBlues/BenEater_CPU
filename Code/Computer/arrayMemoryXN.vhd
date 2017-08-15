library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components_pk.all;


-- Code from Doulos,
--  https://www.doulos.com/knowhow/vhdl_designers_guide/models/simple_ram_model/
--  "[S]ynthesises into internal block memories in the majority of FPGA architectures"


entity arrayMemoryXN is

	generic (

		X : integer
	);

	port (

		d, addr : in  std_logic_vector( N - 1 downto 0 );
		load    : in  std_logic;
		clk     : in  std_logic;
		q       : out std_logic_vector( N - 1 downto 0 )
	);

end entity;


architecture ac of arrayMemoryXN is

	type ram_type is array( 0 to X - 1 ) of std_logic_vector( N - 1 downto 0 );
	signal ram : ram_type;

	signal read_addr : std_logic_vector( N - 1 downto 0 ) := ( others => '0' );

begin

	q <= ram( to_integer( unsigned( read_addr ) ) );
	--q <= ram( to_integer( unsigned( addr ) ) );

	process ( clk )
	begin

		if rising_edge ( clk ) then

			if load = '1' then

				ram( to_integer( unsigned( addr ) ) ) <= d;

			end if;

			read_addr <= addr;

		end if;

	end process;

end architecture;


--