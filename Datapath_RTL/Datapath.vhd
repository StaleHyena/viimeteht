Library IEEE;
USE IEEE.std_logic_1164.all;

Entity Datapath is
Port(DataIn : in std_logic_vector(7 downto 0);
     clock, reset : in std_logic;
     PC : in std_logic_vector(13 downto 0);
	  v,c,z,n : out std_logic;
     DataOut : out std_logic_vector(7 downto 0)
	  );
end Datapath;

Architecture Arq of Datapath is

component Reg8b is
Port(clock, reset,carga: in std_logic;
     D: in std_logic_vector(7 downto 0);
	  Q : out std_logic_vector(7 downto 0)
	  );
end component;

component Mux8_1 is
Port(A,B,C,D,E,F,G,H: in std_logic_vector(7 downto 0);
     sel : in std_logic_vector(2 downto 0);
	  Y: out std_logic_vector(7 downto 0)
	  );
end component;

component Mux2_1 is
Port(A,B: in std_logic_vector(7 downto 0);
     sel : in std_logic;
	  Y: out std_logic_vector(7 downto 0)
	  );
end component;

component DEC3_8 is
Port(Y: in std_logic_vector(2 downto 0);
	  saida: out std_logic_vector(7 downto 0)
	  );
end component;

component Deslc is
Port(ent: in std_logic_vector(7 downto 0);
     dir_esq: in std_logic;
	  saida: out std_logic_vector(7 downto 0)
	  );
end component;

component ULA is
Port(A,B : in std_logic_vector(7 downto 0);
     sel : in std_logic_vector(1 downto 0);
	  v,c,z,n : out std_logic;--v:overflow c:carry out
     saida : out std_logic_vector(7 downto 0)
	  );
end component;

signal mux_reg,carga,ULA_MUX,Shift_Mux,mux_mux : std_logic_vector(7 downto 0);
signal s_Reg0,S_Reg1,S_Reg2,S_Reg3,S_Reg4,S_Reg5,S_Reg6,S_Reg7 : std_logic_vector(7 downto 0);
signal OpA, OpB : std_logic_vector(7 downto 0);

--signal SReg array 0 to 7 of std_logic_vector(7 downto 0);

begin

DataOut <= OpB;

R0: Reg8b port map (clock => clock, 
                    reset => reset,
						  carga => carga(0),
						  D => mux_reg,
						  Q => s_Reg0);

R1: Reg8b port map (clock => clock, 
                    reset => reset,
						  carga => carga(1),
						  D => mux_reg,
						  Q => s_Reg1);
						  
R2: Reg8b port map (clock => clock, 
                    reset => reset,
						  carga => carga(2),
						  D => mux_reg,
						  Q => s_Reg2);

R3: Reg8b port map (clock => clock, 
                    reset => reset,
						  carga => carga(3),
						  D => mux_reg,
						  Q => s_Reg3);


R4: Reg8b port map (clock => clock, 
                    reset => reset,
						  carga => carga(4),
						  D => mux_reg,
						  Q => s_Reg4);
						  
R5: Reg8b port map (clock => clock, 
                    reset => reset,
						  carga => carga(5),
						  D => mux_reg,
						  Q => s_Reg5);

R6: Reg8b port map (clock => clock, 
                    reset => reset,
						  carga => carga(6),
						  D => mux_reg,
						  Q => s_Reg6);
						  

R7: Reg8b port map (clock => clock, 
                    reset => reset,
						  carga => carga(7),
						  D => mux_reg,
						  Q => s_Reg7);
						  
DEC: DEC3_8 port map(Y => PC(2 downto 0),
                     saida => carga);	

MUXA: MUX8_1 port map(A => S_Reg0,
                      B => S_Reg1,
							 C => S_Reg2,
							 D => S_Reg3,
							 E => S_Reg4,
							 F => S_Reg5,
							 G => S_Reg6,
							 H => S_Reg7,
							 sel => PC(8 downto 6),
							 Y => OpA);	

MUXB: MUX8_1 port map(A => S_Reg0,
                      B => S_Reg1,
							 C => S_Reg2,
							 D => S_Reg3,
							 E => S_Reg4,
							 F => S_Reg5,
							 G => S_Reg6,
							 H => S_Reg7,
							 sel => PC(5 downto 3),
							 Y => OpB);	
						
ALU: ULA port map (A => OpA,
                   B => OpB,
						 sel => PC(10 downto 9), 
                   v => v,
						 c => c,
						 z => z,
						 n => n,
						 saida => ULA_MUX);
					
shifter: Deslc port map(ent => OpB,
                        dir_esq => PC(11),
								saida => Shift_Mux);
						
MUX_ULA_Shift: MUX2_1 port map (A => ULA_MUX,
                                B => Shift_Mux,
										  sel => PC(12),
										  Y => mux_mux);
										
MUX_FINAL: MUX2_1 port map (A => mux_mux,
                                B => DataIn,
										  sel => PC(13),
										  Y => mux_reg);
end arq;	  
