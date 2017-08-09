library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


-- Code based on,
--  https://www.doulos.com/knowhow/vhdl_designers_guide/models/simple_ram_model/

entity arrayMemoryXN_hmmm is

	generic (
		X : integer
	);

	port (
		ram     : inout ram_type;
		d, addr : in    std_logic_vector( N - 1 downto 0 );
		load    : in    std_logic;
		q       : out   std_logic_vector( N - 1 downto 0 )
	);

end entity;


architecture ac of arrayMemoryXN_hmmm is

	signal ram : ram_type;

	signal q0, q1 : std_logic_vector( N - 1 downto 0 );

begin

	q0 <= ram( to_integer( unsigned( addr ) ) );

	ram( to_integer( unsigned( addr ) ) ) <= q1;
	

	--q <= q0;

	comp : muxN2to1 port map ( d, q0, load, q1 );


			if load = '1' then


			end if;


end architecture;


--