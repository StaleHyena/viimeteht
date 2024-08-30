Library IEEE;
USE IEEE.std_logic_1164.all;

Entity DEC3_8 is
Port(Y: in std_logic_vector(2 downto 0);
	  saida: out std_logic_vector(7 downto 0)
	  );
end DEC3_8;

architecture arq of DEC3_8 is

begin


with Y select
saida <= "00000001" when "000",
         "00000010" when "001",
			"00000100" when "010",
			"00001000" when "011",
			"00010000" when "100",
			"00100000" when "101",
			"01000000" when "110",
			"10000000" when "111";
end arq;
			
