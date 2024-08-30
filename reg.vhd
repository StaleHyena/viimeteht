library IEEE;
use ieee.std_logic_1164.all;

entity reg is
	generic (NUM : natural);
	port (
		d : in std_logic_vector(NUM-1 downto 0);
		z : out std_logic_vector(NUM-1 downto 0);
		load_s : in std_logic;
		clk: in std_logic);
end entity;

architecture syn of reg is
component FFD is
Port( d, clock, spre, sclear: in std_logic;
		q, qnot: out std_logic);
END Component;
signal pre_z: std_logic_vector(NUM-1 downto 0);
begin
FFDs_gen: for i in NUM-1 downto 0 generate
	FFD_i: FFD port map(
		d => load_s,
		clock => clk,
		spre => '0',
		sclear => '0',
		q => pre_z(i),
		qnot => open
	);
	z(i) <= pre_z(i);
	end generate;
end architecture;