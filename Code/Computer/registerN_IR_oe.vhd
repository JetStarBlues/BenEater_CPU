library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


-- Instruction register only dumps lower nibble onto bus
--  IIIIDDDD encoding of Ben Eater computer


entity registerN_IR_oe is

	port (
		databus        : inout std_logic_vector( N - 1 downto 0 );
		load, clk, clr : in    std_logic;
		out_enable     : in    std_logic;
		q              : out   std_logic_vector( N - 1 downto 0 )
	);

end entity;


architecture ac of registerN_IR_oe is

	signal q0, q1 : std_logic_vector( N - 1 downto 0 );

begin

	-- Upper nibble, instruction
	q <= (

		7 downto 4 => q0( 7 downto 4 ),  -- 2008+ VHDL
		others     => '0' 
	);

	-- Lower nibble, immediate
	q1 <= (

		3 downto 0 => q0( 3 downto 0 ),
		others     => '0' 
	);

	comp0 : registerN port map ( databus, load, clk, clr, q0 );

	comp1 : bufferN port map ( q1, out_enable, databus );


end architecture;


-- See,
--  . array of dffs  - https://youtu.be/-arYx_oVIj8?t=3m56s
--  . output buffers - https://youtu.be/CiMaWbz_6E8