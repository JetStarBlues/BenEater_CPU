library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity aluN is

	port (

		da, db   : in  std_logic_vector( N - 1 downto 0 );
		subtract : in  std_logic;
		q        : out std_logic_vector( N - 1 downto 0 );
		cOut     : out std_logic
	);

end entity;


architecture ac of aluN is

	signal cIn : std_logic;
	signal db0 : std_logic_vector( N - 1 downto 0 );

begin

	cIn <= subtract;

	comp : rippleCarryAdderN port map ( da, db0, cIn, q, cOut );

	gen : for i in N - 1 downto 0 generate

		db0(i) <= db(i) xor subtract;  -- ones complement

	end generate;

end architecture;


-- See https://youtu.be/mOVOS9AjgFs