-- Code from Altera,
--  http://quartushelp.altera.com/14.1/mergedProjects/hdl/vhdl/vhdl_pro_ram_inferred.htm
--  Synthesis infers block RAM

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity singlePortDualAddressRAMXN is

	generic (

		X : integer;
		N : integer
	);
	port (

		clk    : in  std_logic;
		d      : in  std_logic_vector( N - 1 downto 0 );
		wrAddr : in  std_logic_vector( N - 1 downto 0 );
		wrEn   : in  std_logic;
		rdAddr : in  std_logic_vector( N - 1 downto 0 );
		q      : out std_logic_vector( N - 1 downto 0 )
	);

end entity;


architecture ac of singlePortDualAddressRAMXN is

	type ram_type is array( 0 to X - 1 ) of std_logic_vector( N - 1 downto 0 );
	signal ram : ram_type;

begin

	process ( clk )
	begin

		if rising_edge( clk ) then

			if wrEn = '1' then

				ram( to_integer( unsigned( wrAddr ) ) ) <= d;

			end if;

			q <= ram( to_integer( unsigned( rdAddr ) ) );

		end if;

	end process;

end architecture;


--