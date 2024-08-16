library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
generic (data_width: integer := 6);

port (a :  in std_logic_vector(data_width-1 downto 0);
      b :  in std_logic_vector(data_width-1 downto 0);
		opsel: in std_logic_vector(2 downto 0);
		s : buffer std_logic_vector(data_width-1 downto 0);
		co : out std_logic;
		overflow : out std_logic;
		zero: out std_logic;
		negative: out std_logic;
    led : out std_logic_vector(13 downto 0)
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

--component decod7s is
--Port(
--	A			: in std_logic_vector(3 downto 0); --NAO FUNCIONA COM MAIS DE 4!!!!
--	Y 			: out std_logic_vector(0 to 13)
--);
--end component;

component bin2segment is port (
  I: in std_logic_vector;
  O: out std_logic_vector
);
end component;

signal
	addsub_out,
	shift_out,
	logic_and_out,
	logic_or_out,
	logic_not_out: std_logic_vector(data_width-1 downto 0);

signal mux_sel: unsigned(2 downto 0);
signal zerov: std_logic_vector(data_width-1 downto 0) := (others => '0');

  begin
	with opsel select
  mux_sel <=
		"000" when "000", -- add
		"000" when "001", -- sub
		"001" when "010",	-- shift_l
		"001" when "011", -- shift_r
		"010" when "100", -- and
		"011" when "101",	-- or
		"100" when "110",	-- not
		"101" when "111", -- NOP
		"101" when others;

	OUTMUX: mux port map(
		I => logic_not_out
			& logic_or_out
			& logic_and_out
			& shift_out
			& addsub_out,
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
 
  SHIFTER_INST: shifter port map(
    a => a,
    s => shift_out,
    opsel => opsel(0)
  );
  
--  DECOD_INST: decod7s port map(
--    A => s,
--    Y => led
--  );
  
  DECOD_INST: bin2segment port map(
    I => s,
    O => led
  );
  
  logic_and_out <= a and b;
	logic_or_out <= a or b;
	logic_not_out <= not a;

	negative <= s(s'high);
	with s select
  zero <= 
		'1' when zerov,
		'0' when others;
end alu_arch;