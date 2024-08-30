entity full_adder is
Port(ai : in bit;
     bi : in bit;
	  ci : in bit;
	  ro : out bit;
	  co : out bit);
end full_adder;

architecture full_adder_arch of full_adder is
begin

ro <= ai xor bi xor ci;
co <= (ai and bi) or (ai and ci) or (bi and ci);

end full_adder_arch;