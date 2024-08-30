Library IEEE;
USE IEEE.std_logic_1164.all;

Entity FSM is
Port(clock, reset, ent : in std_logic;
     saida : out std_logic_vector(1 downto 0)
	  );
end FSM;

architecture arq of FSM is

type tipo_estado is (S0,S1,S2,S3);
signal atual, proximo : tipo_estado;

begin

P0: process(clock,reset)
    begin
	    if reset = '1' then
		    atual <= S0;
		 elsif rising_edge(clock) then
		    atual <= proximo;
		 end if;
	 end process;

P1: process(atual,reset,ent)
    begin
	    case atual is
		    when S0 => 
			    saida <= "00";
				 if ent = '1' then
				    proximo <= S1;
				 else
				    proximo <= S0;
				 end if;
				 
		    when S1 => 
			    saida <= "01";
				 if ent = '1' then
				    proximo <= S2;
				 else
				    proximo <= S1;
				 end if;
				 
		    when S2 => 
			    saida <= "10";
				 if ent = '1' then
				    proximo <= S3;
				 else
				    proximo <= S2;
				 end if;

		    when S3 => 
			    saida <= "11";
				 if ent = '1' then
				    proximo <= S0;
				 else
				    proximo <= S3;
				 end if;
		 end case;
		 
	 end process;
	 
end arq;
