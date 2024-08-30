Library IEEE;
USE IEEE.std_logic_1164.all;

Entity Mux8_1 is
Port(A,B,C,D,E,F,G,H: in std_logic_vector(7 downto 0);
     sel : in std_logic_vector(2 downto 0);
	  Y: out std_logic_vector(7 downto 0)
	  );
end Mux8_1;
Architecture arq of MUX8_1 is

begin

with sel select
  Y <= A when "000",
       B when "001", 
		 C when "010",
		 D when "011",
	    E when "100",
	    F when "101",
       G when "110",
       H when "111";
end arq; 		 