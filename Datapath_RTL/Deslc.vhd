Library IEEE;
USE IEEE.std_logic_1164.all;

Entity Deslc is
Port(ent: in std_logic_vector(7 downto 0);
     dir_esq: in std_logic;
	  saida: out std_logic_vector(7 downto 0)
	  );
end Deslc;

architecture arq of Deslc is
signal dir, esq : std_logic_vector(7 downto 0);

begin

dir <= '0'&ent(7 downto 1); --shift right
esq <= ent(6 downto 0)&'0'; --shift left

saida <= esq when (dir_esq = '0') else dir;

end arq;
