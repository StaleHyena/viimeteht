library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package mux_p is
  --- type slv_array_t is array (natural range <>) of std_logic_vector;
  type slv_array_t is array (natural range <>) of std_logic_vector(7 downto 0);
end package;

package body mux_p is
end package body;

--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--use ieee.math_real.all;
--use work.mux_p;

--entity muxNx8 is
--  generic(
--    NUM : natural);  -- Number of inputs
--  port(
--    v_i   : in  mux_p.slv_array_t(0 to NUM - 1);
--    sel_i : in  natural range 0 to NUM - 1;
--	 --sel_i : in unsigned(integer(ceil(log2(real(NUM)))) - 1 downto 0);
--    z_o   : out std_logic_vector(7 downto 0));
--end entity;
--
--architecture syn of muxNx8 is
--begin
--  z_o <= v_i(sel_i);
--end architecture;
--
--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--use ieee.math_real.all;
--use work.mux_p;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- mux based upon
-- https://community.element14.com/technologies/fpga-group/b/blog/posts/the-art-of-fpga-design---post-14

entity mux is
  port (
    I : in std_logic_vector;
    S : in unsigned;
    O : out std_logic_vector
  );
end mux;

architecture behav of mux is
  constant WIDTH: integer := O'length;
  constant N: integer := 2**S'length; -- number of inputs, ceil'd to the closest 2**x
  signal II: std_logic_vector(N*WIDTH-1 + I'low downto I'low); -- I might not be 0 based
begin
  assert I'length mod O'length=0 report "I'length must be a multiple of O'length!" severity warning;
  -- not going to lie, don't understand this assertion
  assert (2**S'length<=I'length/O'length) and (I'length/O'length<2**(S'length+1))
    report "Ports I, O and SEL have inconsistent sizes!" severity warning;

  II <= std_logic_vector(resize(unsigned(I), II'length));

  -- This is the dead simple behavioural implementation, i'm ignoring the
  -- optimizations laid out in the blog post
  O <= II(WIDTH*(TO_INTEGER(S)+1)-1+II'low downto WIDTH*TO_INTEGER(S)+II'low);
  
end behav;

--
--entity demuxN is
--	generic(NUM : natural);
--	port(
--		sel_i: in natural range integer(ceil(log2(real(NUM)))) - 1 downto 0;
--		--sel_i: in unsigned(integer(ceil(log2(real(NUM)))) - 1 downto 0);
--		z_o: out std_logic_vector(NUM - 1 downto 0));
--end entity;
--
--architecture syn of demuxN is
--signal z_uns: unsigned(NUM - 1 downto 0);
--begin
--	z_uns <= shift_left(resize("1", NUM),sel_i);
--	z_o <= std_logic_vector(z_uns);
--end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- demux based upon
-- https://community.element14.com/technologies/fpga-group/b/blog/posts/the-art-of-fpga-design---post-14

entity demux is
  port (
    I : in std_logic_vector;
    S : in unsigned;
    O : out std_logic_vector
  );
end demux;

architecture behav of demux is
  constant WIDTH: integer := I'length;
  constant N: integer := 2**S'length; -- number of inputs, ceil'd to the closest 2**x
begin
  assert O'length mod I'length=0 report "O'length must be a multiple of I'length!" severity error;
  -- not going to lie, don't understand this assertion
  assert (2**S'length<=O'length/I'length) and (O'length/I'length<2**(S'length+1))
    report "Ports I, O and SEL have inconsistent sizes!" severity warning;

  -- This is the dead simple behavioural implementation, i'm ignoring the
  -- optimizations laid out in the blog post
  O(WIDTH*(TO_INTEGER(S)+1)-1+O'low downto WIDTH*TO_INTEGER(S)+O'low) <= I;
  
end behav;
