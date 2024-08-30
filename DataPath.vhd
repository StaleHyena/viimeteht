library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity datapath is port (
	data_in: in std_logic_vector(7 downto 0);
	data_out: out std_logic_vector(7 downto 0);
	pc: in std_logic_vector(13 downto 0);
	z, n, c, v: out std_logic;
	clock: in std_logic
);
end entity;

architecture a of datapath is

signal a, b: std_logic_vector(7 downto 0);
signal reg_load, reg_data, alu_out, shifter_out, feedback_comp, feedback: std_logic_vector(7 downto 0);
signal reg_vals: std_logic_vector(8*8-1 downto 0);
signal reg_vals_all: std_logic_vector(8*8-1 downto 0);

begin
	--reg_vals_all <= reg_vals(7) & reg_vals(6) & reg_vals(5) & reg_vals(4) & reg_vals(3) & reg_vals(2) & reg_vals(1) & reg_vals(0);
	reg_gen: for i in 7 downto 0 generate
		mem_reg: work.reg generic map(NUM => 8)
			port map (
				d => reg_data,
				z => reg_vals((i+1)*8 - 1 downto i*8),
				load_s => reg_load(i),
				clk => clock
			);
	end generate;
	reg_load_demymux: work.demymux generic map(NUM => 8)
		port map (
			S => to_integer(unsigned(pc(2 downto 0))),
			O => reg_load
		);
	mymux_a: work.mymux generic map(NUM => 8)
		port map (
			I => reg_vals,
			S => to_integer(unsigned(pc(5 downto 3))),
			O => a
		);
	mymux_b: work.mymux generic map(NUM => 8)
		port map (
			I => reg_vals,
			S => to_integer(unsigned(pc(8 downto 6))),
			O => b
		);
	
	data_out <= b;
	reg_data <= feedback;
	
	alu: work.alu generic map (data_width => 8)
		port map (
			a => a,
			b => b,
			s => alu_out,
			opsel => pc(10 downto 9),
			zero => z, negative => n, co => c, overflow => v
		);
		
	shifter: work.shifter port map(
		a => b,
		s => shifter_out,
		opsel => pc(11)
	);
	mymux_alu_shifter: work.mymux generic map(NUM => 2)
	port map(
		I => shifter_out & alu_out,
		S => to_integer(unsigned(pc(12 downto 12))),
		O => feedback_comp
	);
	mymux_feedback: work.mymux generic map(NUM => 2)
	port map(
		I => data_in & feedback_comp,
		S => to_integer(unsigned(pc(13 downto 13))),
		O => feedback
	);

end architecture;