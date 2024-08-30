library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity FSM is port (
	clk, zero, negative, carry, overflow: in std_logic;
	data_in: out std_logic_vector(7 downto 0);
	pc : out std_logic_vector(13 downto 0);
	state_num: out unsigned(3 downto 0)
);
end entity;

architecture ex9 of FSM is
	type state_t is (
		READ_START,
		WRITE_START,
		READ_STEP,
		READ_FINAL,
		ACC_X,
		X_PLUS_STEP,
		ACC_PLUS_X,
		TEMP_FINAL_MINUS_X,
		WRITE_ACC
		);
	signal data_in_val: natural;
	signal cur_state: state_t;
begin
	process(clk, zero)
	variable state : state_t := READ_START;
	variable dvr: integer := 0;
	variable pcr: unsigned(13 downto 0);
	begin
		if rising_edge(clk) then
			case state is
				when READ_START =>  state := WRITE_START; dvr := 0; pcr := "1XXXXXXXXXX000";
				when WRITE_START => state := READ_STEP; pcr := "00X11100000000";
				when READ_STEP =>   state := READ_FINAL; dvr := 5; pcr := "1XXXXXXXXXX001";
				when READ_FINAL =>  state := ACC_X; dvr := 35; pcr := "1XXXXXXXXXX010";
				when ACC_X =>		  state := X_PLUS_STEP; pcr:= "00X11010000010";
				when X_PLUS_STEP => state := ACC_PLUS_X; pcr := "00X00001000000";
				when ACC_PLUS_X =>  state := TEMP_FINAL_MINUS_X; pcr := "00X00000010010";
				when TEMP_FINAL_MINUS_X =>
					if zero = '1'
						then state := WRITE_ACC;
						else state := X_PLUS_STEP;
					end if;
					pcr := "00X01011000101";
				when WRITE_ACC => state := WRITE_ACC; pcr:= "00X11100010010";
			end case;
		end if;
		cur_state <= state;
		data_in <= std_logic_vector(to_unsigned(dvr, data_in'length));
		pc <= std_logic_vector(pcr);
	end process;
	
	with cur_state select state_num <=
		to_unsigned(0,4) when READ_START,
		to_unsigned(1,4) when WRITE_START,
		to_unsigned(2,4) when READ_STEP,
		to_unsigned(3,4) when READ_FINAL,
		to_unsigned(4,4) when ACC_X,
		to_unsigned(5,4) when X_PLUS_STEP,
		to_unsigned(6,4) when ACC_PLUS_X,
		to_unsigned(7,4) when TEMP_FINAL_MINUS_X,
		to_unsigned(8,4) when WRITE_ACC;
end architecture;