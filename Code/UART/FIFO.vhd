-- Code based on
--  https://www.nandland.com/vhdl/modules/module-fifo-regs-with-flags.html
--  https://www.nandland.com/articles/crossing-clock-domains-in-an-fpga.html

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.UART_pk.all;


entity FIFO is

	generic (

		N                : integer;
		depth            : integer;
		almostFullLevel  : integer;
		almostEmptyLevel : integer
	);

	port (

		clk, rst : in std_logic;

		-- Write interface
		wrEn     : in  std_logic;
		wrData   : in  std_logic_vector( N - 1 downto 0 );
		AF, full : out std_logic;

		-- Read interface
		rdEn      : in  std_logic;
		rdData    : out std_logic_vector( N - 1 downto 0 );
		AE, empty : out std_logic
	);

end entity;

architecture arch of FIFO is

	signal wrIndex, rdIndex : integer range 0 to depth - 1 := 0;
	signal ffCount : integer range 0 to depth := 0;

	signal ffFull, ffEmpty : std_logic;

	signal wrAddr, rdAddr : std_logic_vector( N - 1 downto 0 ); 


begin

	full   <= ffFull;
	empty  <= ffEmpty;

	ffFull  <= '1' when ffCount = depth else '0';
	ffEmpty <= '1' when ffCount = 0     else '0';

	AF <= '1' when ffCount > almostFullLevel  else '0';
	AE <= '1' when ffCount < almostEmptyLevel else '0';

	wrAddr <= std_logic_vector( to_unsigned( wrIndex, N ) );
	rdAddr <= std_logic_vector( to_unsigned( rdIndex, N ) );


	comp : singlePortDualAddressRAMXN
	generic map (

		depth,
		N
	)
	port map (

		clk,

		wrData,
		wrAddr,
		wrEn,

		rdAddr,
		rdData
	);


	process ( clk )
	begin

		if rising_edge( clk ) then

			if rst = '1' then

				ffCount	<= 0;
				wrIndex <= 0;
				rdIndex <= 0;

			else

				-- Track number of elements in FIFO
				if ( wrEn = '1' ) and ( rdEn = '0' ) then

					ffCount <= ffCount + 1;

				elsif ( wrEn = '0' ) and ( rdEn = '1' ) then

					ffCount <= ffCount - 1;

				end if;

				-- Track write index
				if ( wrEn = '1' ) and ( ffFull = '0' ) then

					if wrIndex = depth - 1 then

						wrIndex <= 0;

					else

						wrIndex <= wrIndex + 1;

					end if;

				end if;

				-- Track read index
				if ( rdEn = '1' ) and ( ffEmpty = '0' ) then

					if rdIndex = depth - 1 then

						rdIndex <= 0;

					else

						rdIndex <= rdIndex + 1;

					end if;
					
				end if;

			end if;

		end if;

	end process;

end architecture;


--