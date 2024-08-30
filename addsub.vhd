library ieee;
use ieee.std_logic_1164.all;

entity addsub is
generic (data_width: integer := 8);

port (a :  in std_logic_vector(data_width-1 downto 0);
      b :  in std_logic_vector(data_width-1 downto 0);
		s : out std_logic_vector(data_width-1 downto 0);
		c : out std_logic;
		opsel: in std_logic;
    ov : out std_logic);
end addsub;

architecture addsub_arch of addsub is

component adder is
generic (data_width : integer := data_width);
port (a :  in std_logic_vector(data_width-1 downto 0);
      b :  in std_logic_vector(data_width-1 downto 0);
		c :  in std_logic;
		so : out std_logic_vector(data_width-1 downto 0);
		co : out std_logic
    );
end component;


--signal  : std_logic_vector(7 downto 0) := (others => '1');
signal sig_b : std_logic_vector(data_width-1 downto 0);
signal sig_s : std_logic_vector(data_width-1 downto 0);
signal sig_c : std_logic;
begin
	INV: for i in data_width-1 downto 0 generate
		sig_b(i) <= b(i) xor opsel;
   end generate;
	AD: adder port map(
		a => a,
    b => sig_b,
		c => opsel,
		so => sig_s,
		co => sig_c
    );
    
    ov <= sig_s(sig_s'high) xor sig_c; -- talvez erradinho da silva
    s <= sig_s;
    c <= sig_c;
    
end addsub_arch;
