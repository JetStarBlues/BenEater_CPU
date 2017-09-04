-- Code by www.jk-quantized.com
-- Redistribution and use of this code in source and binary forms
-- must retain the above attribution notice and this condition.

library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity counterXN is

	generic (

		X : integer
	);

	port (

		d              : in  std_logic_vector( N - 1 downto 0 );
		load, clk, clr : in  std_logic;
		increment      : in  std_logic;
		q              : out std_logic_vector( N - 1 downto 0 )
	);

end entity;


architecture ac of counterXN is

	signal doSomething : std_logic;
	signal reg_in, reg_out, incr_out : std_logic_vector( N - 1 downto 0 );

begin

	doSomething <= load xor increment;

	q <= reg_out;

	-- increment value currently stored in register
	comp0 : incrementXN
			generic map ( X )
			port map    ( reg_out, incr_out );

	-- if doSomething, overwrite register with increment or jump value
	comp1 : muxN2to1 port map ( incr_out, d, increment, reg_in );

	-- new value assignment of register won't take effect until next clock cycle
	comp2 : registerN port map ( reg_in, doSomething, clk, clr, reg_out );

end architecture;


-- See https://youtu.be/g_1HyxBzjl0