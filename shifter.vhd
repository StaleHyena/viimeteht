library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shifter is
generic (data_width: integer := 8);

port (a :  in std_logic_vector(data_width-1 downto 0);
		s : out std_logic_vector(data_width-1 downto 0);
		opsel: in std_logic);
end shifter;

architecture shifter_arch of shifter is

component mux is
  port (
    I : in std_logic_vector;
    S : in unsigned;
    O : out std_logic_vector
  );
end component;
signal mux_sel: unsigned(0 to 0);
signal sig_a : std_logic_vector(data_width+1 downto 0);
signal sig_interm : std_logic_vector(data_width+1 downto 0);

begin
with opsel select
  mux_sel <=
  "0" when '0',
  "1" when others;
  
  sig_a <= "0" & a & "0";

SHIFT: for i in data_width-1 downto 0 generate
  SHIFT_R: mux port map(
		I => sig_a(i+2 downto i+1),
		S => mux_sel,
		O => sig_interm(i+1 downto i+1)
	);
  SHIFT_L: mux port map(
		I => sig_interm(i+1 downto i+0),
		S => mux_sel,
		O => s(i downto i)
	);
  end generate;

end shifter_arch;