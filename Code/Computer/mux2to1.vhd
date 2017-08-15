library ieee;
use ieee.std_logic_1164.all;


entity mux2to1 is

	port (

		d1, d0 : in std_logic;
		s      : in std_logic;
		q      : out std_logic
	);
	
end entity;


architecture ac of mux2to1 is
	
begin

	q <= ( s and d1 ) or ( ( not s ) and d0 );
	
end architecture;


--