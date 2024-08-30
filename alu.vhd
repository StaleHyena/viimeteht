library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mux_p.all;

entity alu is
generic (data_width: integer := 6);

port (a :  in std_logic_vector(data_width-1 downto 0);
      b :  in std_logic_vector(data_width-1 downto 0);
		opsel: in std_logic_vector(1 downto 0);
		s : buffer std_logic_vector(data_width-1 downto 0);
		co : out std_logic;
		overflow : out std_logic;
		zero: out std_logic;
		negative: out std_logic
    );
end alu;

architecture alu_arch of alu is
component addsub is
generic (data_width : integer := data_width);
port (a :  in std_logic_vector(data_width-1 downto 0);
      b :  in std_logic_vector(data_width-1 downto 0);
		s : out std_logic_vector(data_width-1 downto 0);
		c : out std_logic;
		opsel: in std_logic;
		ov :  out std_logic);
end component;
component mux is
  port (
    I : in std_logic_vector;
    S : in unsigned;
    O : out std_logic_vector
  );
end component;

component shifter is
generic (data_width: integer := data_width);
port (a :  in std_logic_vector(data_width-1 downto 0);
      s : out std_logic_vector(data_width-1 downto 0);
      opsel: in std_logic);
end component;

signal
	addsub_out,
	logic_and_out,
	logic_xor_out: std_logic_vector(data_width-1 downto 0);

signal mux_sel: unsigned(1 downto 0);

  begin
	with opsel select
  mux_sel <=
		"00" when "00", -- add
		"00" when "01", -- sub
		"10" when "10",	-- and
		"11" when "11"; -- xor

	OUTMUX: mux port map(
		I => logic_xor_out & logic_and_out & addsub_out,
		S => mux_sel,
		O => s
	);
	ADDSUB_INST: addsub port map(
		a => a,
		b => b,
		s => addsub_out,
		c => co,
		opsel => opsel(0),
    ov => overflow
	);

	logic_and_out <= a and b;
	logic_xor_out <= a xor b;

	negative <= s(s'high);
	with s select
  zero <= 
		'1' when std_logic_vector(resize("0", data_width)),
		'0' when others;
end alu_arch;