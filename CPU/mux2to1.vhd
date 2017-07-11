library ieee;
use ieee.std_logic_1164.all;


entity mux2to1 is

	port(
		d1, d0 : in std_logic;
		s      : in std_logic;
		q      : out std_logic
	);
	
end entity;


architecture ac of mux2to1 is

	signal s0, j0, j1 : std_logic;
	
begin

	s0 <= not s;
	j0 <= s0 and d0;
	j1 <=  s and d1;
	q  <= j0 or j1;
	
end architecture;


--	def mux_( d1, d0, sel ):
--	
--		''' out = d0 if sel == 0
--		          d1 if sel == 1  '''		 
--	
--		out = or_( 
--			and_( not_( sel ), d0 ),
--			and_( sel, d1 )
--		)
--		return out