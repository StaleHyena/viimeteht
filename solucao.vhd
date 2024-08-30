<<<<<<< HEAD
library IEEE;
=======
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.mux_p.all;

entity DataPath is port (
	data_in: in std_logic_vector(7 downto 0);
	data_out: out std_logic_vector(7 downto 0);
	pc: in std_logic_vector(13 downto 0);
	z, n, c, v: out std_logic;
	clock: in std_logic
);
end entity;

architecture a of DataPath is

signal a: std_logic_vector(7 downto 0);
signal b: std_logic_vector(7 downto 0);
signal reg_load: std_logic_vector(7 downto 0);
signal reg_data: std_logic_vector(7 downto 0);
signal reg_vals: slv_array_t(7 downto 0)(7 downto 0);
signal feedback: std_logic_vector(7 downto 0);
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
			sel_i => to_integer(unsigned(pc(2 downto 0))),
			z_o => reg_load
		);
	mux_a: work.mux
		port map (
			v_i => reg_vals,
			sel_i => to_integer(unsigned(pc(5 downto 3))),
			z_o => a
		);
	mux_b: work.mux
		port map (
			v_i => reg_vals,
			sel_i => to_integer(unsigned(pc(8 downto 6))),
			z_o => b
		);
	
	data_out <= b;
	reg_data <= feedback;
	
	alu: work.alu generic map (data_width => 8)
		port map (
			a => a,
			b => b,
			s => feedback,
			opsel => pc(10 downto 9),
			zero => z, negative => n, co => c, overflow => v
		);
	
	mux_feedback: work.mux 

end architecture;
>>>>>>> e340084 (ch-ch-changes)
