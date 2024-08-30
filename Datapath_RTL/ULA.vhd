Library IEEE;
USE IEEE.std_logic_1164.all;

Entity ULA is
Port(A,B : in std_logic_vector(7 downto 0);
     sel : in std_logic_vector(1 downto 0);
	  v,c,z,n : out std_logic;--v:overflow c:carry out
     saida : out std_logic_vector(7 downto 0)
	  );
end ULA;

Architecture Arq of ULA is

component HA is
port(a,b : in std_logic;
	  s,cout : out std_logic);
end component;

component FA is
port(a,b,cin : in std_logic;
	  s,cout : out std_logic);
end component;

signal s_xor,s,s_saida : std_logic_vector(7 downto 0);
signal s_and,s_xorop : std_logic_vector(7 downto 0);
signal aux : std_logic_vector(8 downto 0); 



begin
saida <= s_saida;

--MUX4:1
with sel select
s_saida <= s when "00",
         s when "01",
			s_and when "10",
			A xor B when "11";


--operação AND
s_and <= a and b;
--operação XOR
--s_xorop <= a xor b;

aux(0) <= sel(0); --seletor ('0' + / '1' -)
v <= aux(8) xor aux(7);--overflow
c <= aux(8);--carry out
n <= s_saida(7);
z <= '1' when s_saida = "00000000" else '0';

G1: For i in 0 to 7 generate 	
 s_xor(i) <= B(i) xor sel(0);
 Mx: FA port map ( a 	=> A(i),
                   b 	=> s_xor(i),
					    cin 	=> aux(i),
					    s 	=> s(i),
					    cout => aux(i+1));
 end generate;

 
end Arq;
