library ieee;
use ieee.std_logic_1164.all;
use work.components_pk.all;


entity decoder3to8 is

	port (
		d : in  std_logic_vector( 2 downto 0 );
		q : out std_logic_vector( 7 downto 0 )
	);
	
end entity;


architecture ac of decoder3to8 is

	signal nd : std_logic_vector( 2 downto 0 );
	
begin

	nd <= not d;
	
	q(7) <=  d(2) and  d(1) and  d(0);
	q(6) <=  d(2) and  d(1) and nd(0);
	q(5) <=  d(2) and nd(1) and  d(0);
	q(4) <=  d(2) and nd(1) and nd(0);
	q(3) <= nd(2) and  d(1) and  d(0);
	q(2) <= nd(2) and  d(1) and nd(0);
	q(1) <= nd(2) and nd(1) and  d(0);
	q(0) <= nd(2) and nd(1) and nd(0);
	
end architecture;


--	def decoder3to8_( d2, d1, d0 ):
--		q7 = and3_(       d2  ,       d1  ,       d0   )
--		q6 = and3_(       d2  ,       d1  , not_( d0 ) )
--		q5 = and3_(       d2  , not_( d1 ),       d0   )
--		q4 = and3_(       d2  , not_( d1 ), not_( d0 ) )
--		q3 = and3_( not_( d2 ),       d1  ,       d0   ) 
--		q2 = and3_( not_( d2 ),       d1  , not_( d0 ) )
--		q1 = and3_( not_( d2 ), not_( d1 ),       d0   )
--		q0 = and3_( not_( d2 ), not_( d1 ), not_( d0 ) )
--		return ( q7, q6, q5, q4, q3, q2, q1, q0 )