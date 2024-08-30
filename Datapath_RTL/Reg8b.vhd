Library IEEE;
USE IEEE.std_logic_1164.all;

Entity Reg8b is
Port(clock, reset,carga: in std_logic;
     D: in std_logic_vector(7 downto 0);
	  Q : out std_logic_vector(7 downto 0)
	  );
end Reg8b;

Architecture Arq of Reg8b is
begin

Process(clock,reset,D,carga)
begin
    if reset = '1' then
	    Q <= "00000000";
	 elsif clock'event and clock = '1' then
	    if carga = '1' then
		    Q <= D;
		 end if;
	 end if;
end process;

end arq;
