Library IEEE;
Use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity BCD_TO_7SEG is
Port(
	digit : in natural range 0 to 15;
	segments : out std_logic_vector(6 downto 0)
);
END BCD_TO_7SEG;

architecture behav of BCD_TO_7SEG is
begin
ENCODER_PROC : process(digit)
begin
  case digit is
 
    when 0 => segments <= not "0111111";
    when 1 => segments <= not "0000110";
    when 2 => segments <= not "1011011";
    when 3 => segments <= not "1001111";
    when 4 => segments <= not "1100110";
    when 5 => segments <= not "1101101";
    when 6 => segments <= not "1111101";
    when 7 => segments <= not "0000111";
    when 8 => segments <= not "1111111";
    when 9 => segments <= not "1101111";
	 when 10 => segments <= not "1011111";
	 when 11 => segments <= not "1101111";
	 when 12 => segments <= not "1101111";
	 when 13 => segments <= not "1101111";
	 when 14 => segments <= not "1101111";
	 when 15 => segments <= not "1101111";
   
    end case;
end process;
END architecture;