library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.mux_p.all;

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
signal reg_vals: slv_array_t(7 downto 0);

begin
	reg_gen: for i in 7 downto 0 generate
		mem_reg: work.reg generic map(NUM => 8)
			port map (
				d => reg_data,
				z => reg_vals(i),
				load_s => reg_load(i),
				clk => clock
			);
	end generate;
	reg_load_demux: work.demux
		port map (
			I => "1",
			S => unsigned(pc(2 downto 0)),
			O => reg_load
		);
	mux_a: work.mux
		port map (
			I => reg_vals(7) & reg_vals(6) & reg_vals(5) & reg_vals(4) & reg_vals(3) & reg_vals(2) & reg_vals(1) & reg_vals(0),
			S => unsigned(pc(5 downto 3)),
			O => a
		);
	mux_b: work.mux
		port map (
			I => reg_vals(7) & reg_vals(6) & reg_vals(5) & reg_vals(4) & reg_vals(3) & reg_vals(2) & reg_vals(1) & reg_vals(0),
			S => unsigned(pc(8 downto 6)),
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
	mux_alu_shifter: work.mux port map(
		I => shifter_out & alu_out,
		S => unsigned(pc(12 downto 12)),
		O => feedback_comp
	);
	mux_feedback: work.mux port map(
		I => data_in & feedback_comp,
		S => unsigned(pc(13 downto 13)),
		O => feedback
	);

end architecture;