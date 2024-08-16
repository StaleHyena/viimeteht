library ieee;
use ieee.std_logic_1164.all;

package mux_p is
  type slv_array_t is array (natural range <>) of std_logic_vector;
end package;

package body mux_p is
end package body;

library ieee;
use ieee.std_logic_1164.all;
use work.mux_p;

entity mux is
  generic(
    LEN : natural;   -- Bits in each input
    NUM : natural);  -- Number of inputs
  port(
    v_i   : in  mux_p.slv_array_t(0 to NUM - 1)(LEN - 1 downto 0);
    sel_i : in  natural range 0 to NUM - 1;
    z_o   : out std_logic_vector(LEN - 1 downto 0));
end entity;

architecture syn of mux is
begin
  z_o <= v_i(sel_i);
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use work.mux_p;

entity demux is
	generic(NUM : natural);
	port(
		sel_i: in natural range integer(ceil(log2(real(NUM)))) - 1 downto 0;
		z_o: out mux_p.slv_array_t(NUM - 1 downto 0));
end entity;

architecture syn of demux is
begin
	z_o <= (others <= '0') or shift_left(1,sel_i);
end architecture;
