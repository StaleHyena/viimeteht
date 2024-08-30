library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mux_p.all;

entity alluvite is

port (clk: in std_logic;
	o: out std_logic_vector(7 downto 0);
	leds: out std_logic_vector(7*4 - 1 downto 0)
	);
end entity;

architecture A of alluvite is
signal data_in, data_out : std_logic_vector(7 downto 0);
signal pc : std_logic_vector(13 downto 0);
signal zero, negative, overflow, carry, clock : std_logic;
begin
	DP: work.datapath port map(
		clock => clk,
		data_in => data_in,
		data_out => data_out,
		pc => pc,
		n => negative, z => zero, v => overflow, c => carry
	);
	
	FSM: work.FSM port map(
		clk => clk,
		zero => zero, negative => negative, overflow => overflow, carry => carry,
		pc => pc
	);
	
	o <= data_out;
	leds <= (others => '0');
end architecture;