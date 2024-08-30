Library IEEE;
USE IEEE.std_logic_1164.all;

Entity Mux2_1 is
Port(A,B: in std_logic_vector(7 downto 0);
     sel : in std_logic;
	  Y: out std_logic_vector(7 downto 0)
	  );
end Mux2_1;
Architecture arq of MUX2_1 is

begin

with sel select
  Y <= A when '0',
       B when '1'; 
end arq; 		 