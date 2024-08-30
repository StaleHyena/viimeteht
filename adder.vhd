library ieee;
use ieee.std_logic_1164.all;

entity adder is
generic (data_width: integer := 4);

port (a :  in std_logic_vector(data_width-1 downto 0);
      b :  in std_logic_vector(data_width-1 downto 0);
		c :  in std_logic;
		so :  out std_logic_vector(data_width-1 downto 0);
		co : out std_logic);
end adder;

architecture adder_arch of adder is

component full_adder is
Port(ai : in std_logic;
     bi : in std_logic;
	  ci : in std_logic;
	  ro : out std_logic;
	  co : out std_logic);
end component;

signal sig_c : std_logic_vector(data_width downto 0);
begin
	sig_c(0) <= c;
GEN: for idx in 0 to data_width-1 generate
	FA: full_adder port map(
		ai => a(idx),
		bi => b(idx),
		ci => sig_c(idx),
		ro => so(idx),
		co => sig_c(idx+1));
	end generate GEN;
	co <= sig_c(data_width);

end adder_arch;
