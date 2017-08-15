library ieee;
use ieee.std_logic_1164.all;


entity halfAdder is

	port (

		a, b       : in  std_logic;
		sum, carry : out std_logic
	);

end entity;


architecture ac of halfAdder is
begin

	sum   <= a xor b;
	carry <= a and b;

end architecture;


--