library ieee;
use ieee.std_logic_1164.all;

library altera;
use altera.altera_primitives_components.tri;


entity bufferr is

	port (

		d, oe : in  std_logic;
		q     : out std_logic
	);

end entity;


architecture ac of bufferr is

begin

	comp : tri port map ( d, oe, q );

end architecture;


-- See http://quartushelp.altera.com/14.1/mergedProjects/hdl/prim/prim_file_tri.htm