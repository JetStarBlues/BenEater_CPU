library ieee;
use ieee.std_logic_1164.all;

library altera;
use altera.altera_primitives_components.dffe;


entity dFlipFlop is

	port (

		d, e, clk : in  std_logic;
		clr       : in  std_logic;
		q         : out std_logic
	);

end entity;


architecture ac of dFlipFlop is

	signal clear  : std_logic;
	signal preset : std_logic;

begin

	clear  <= not clr;  -- treat as active high
	preset <= '1';      -- active low
	
	comp : dffe port map ( 

		d    => d,
		clk  => clk,
		clrn => clear,
		prn  => preset,
		ena  => e,
		q    => q
	);

end architecture;


-- See http://quartushelp.altera.com/15.0/mergedProjects/hdl/prim/prim_file_dffe.htm