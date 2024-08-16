Library IEEE;
Use IEEE.std_logic_1164.all;

Entity FFD is
Port( d, clock, spre, sclear: in std_logic;
		q, qnot: out std_logic);
END FFD;

architecture primitives of FFD is
COMPONENT DFFEAS
 PORT (
 d : IN STD_LOGIC;
 clk : IN STD_LOGIC;
 clrn : IN STD_LOGIC;
 prn : IN STD_LOGIC;
 ena : IN STD_LOGIC;
 asdata : IN STD_LOGIC;
 aload : IN STD_LOGIC;
 sclr : IN STD_LOGIC;
 sload : IN STD_LOGIC;
 q : OUT STD_LOGIC );
END COMPONENT;
signal pre_q: std_logic;
begin
	FF: DFFEAS port map(
		d => d,
		clk => clock,
		clrn => '1',
		prn => '1',
		ena => '1',
		asdata => '0',
		aload => '0',
		sclr => sclear,
		sload => spre,
		q => pre_q
	);
	q <= pre_q;
	qnot <= not pre_q;
end architecture;
