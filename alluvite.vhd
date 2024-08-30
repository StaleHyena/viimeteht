library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alluvite is

port (clk: in std_logic;
	o: out std_logic_vector(7 downto 0);
	leds: out std_logic_vector(7*8 - 1 downto 0)
	);
end entity;

architecture A of alluvite is
signal data_in, data_out : std_logic_vector(7 downto 0);
signal pc : std_logic_vector(13 downto 0);
signal pc_e: unsigned(15 downto 0);
signal zero, negative, overflow, carry, clock : std_logic;
signal digits: std_logic_vector(4*4 - 1 downto 0);
signal data_out_val: integer range 999 downto 0;
signal state_num: unsigned(3 downto 0);
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
		pc => pc,
		data_in => data_in,
		state_num => state_num
	);
	
	o <= data_out;
	data_out_val <= to_integer(unsigned(data_out));
	digits(3 downto 0) <= std_logic_vector(to_unsigned(data_out_val mod 10, 4));
	digits(7 downto 4) <= std_logic_vector(to_unsigned((data_out_val / 10) mod 10, 4));
	digits(11 downto 8) <= std_logic_vector(to_unsigned((data_out_val / 100) mod 10, 4));
	
	LED_DRIVER: for i in 0 to 2 generate
		LED: work.BCD_TO_7SEG port map(
			digit => to_integer(unsigned(digits(4*(i+1) - 1 downto 4*i))),
			segments => leds(7*(i+1)-1 downto 7*i)
		);
	end generate;
	LED_STATE: work.BCD_TO_7SEG port map(
		digit => to_integer(state_num),
		segments => leds(7*(3+1)-1 downto 7*3)
	);
	pc_e <= resize(unsigned(pc), 16);
	LED_PC_GEN: for i in 0 to 3 generate
		LED_PC: work.BCD_TO_7SEG port map(
			digit => to_integer(pc_e((i+1)*4-1 downto i*4)),
			segments => leds(7*(i+4+1)-1 downto 7*(i+4))
		);
	end generate;
	
end architecture;