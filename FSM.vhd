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
		ZERO_REG4,
		READ_STEP,
		READ_FINAL,
		ACC_X,
		X_PLUS_STEP,
		ACC_PLUS_X,
		LOOP_TEST,
		PRINT_TEMP,
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
				when READ_START =>   pcr := "10000000000000"; -- 0) 000 = X [B = ?]
				state := ZERO_REG4; dvr := 25;
				data_in <= std_logic_vector(to_unsigned(dvr, data_in'length));
				when ZERO_REG4 =>    pcr := "10000000000100"; -- 1) 100 = "0" [B = X]
				state := READ_STEP; dvr := 0;
				data_in <= std_logic_vector(to_unsigned(dvr, data_in'length));
				when READ_STEP =>    pcr := "10000000100001"; -- 2) 001 = STEP [B = ZERO]
				state := READ_FINAL; dvr := 5;
				data_in <= std_logic_vector(to_unsigned(dvr, data_in'length));
				when READ_FINAL =>   pcr := "10000000001011"; -- 3) 011 = FINAL [B = STEP]
				state := ACC_X; dvr := 35;
				data_in <= std_logic_vector(to_unsigned(dvr, data_in'length));
				when ACC_X =>        pcr := "00011100000010"; -- 4) "0" ^ X = X [B = X]
				state := X_PLUS_STEP;
								
				-- DO
				when X_PLUS_STEP =>  pcr := "00000000001000"; -- 5) X + STEP = X [B = STEP]
				state := ACC_PLUS_X;
				when ACC_PLUS_X =>   pcr := "00000010000010"; -- 6) ACC + X = ACC [B = X]
				state := LOOP_TEST;
				when LOOP_TEST =>
					if negative = '1'
						then state := PRINT_TEMP;
						else state := WRITE_ACC;
					end if;
					pcr := "00001000011101"; -- 7) X - FINAL = TEMP; -- 101 = TEMP [B = FINAL]
				-- WHILE (FINAL - X == 0)
				when PRINT_TEMP => pcr:= "00011101100101"; -- 8) TEMP ^ "0" = TEMP [B = TEMP]
					state := X_PLUS_STEP;
				when WRITE_ACC => pcr := "00011100010010"; -- 9) "0" ^ ACC = ACC [B = ACC]
				 state := WRITE_ACC;
			end case;
		end if;
		cur_state <= state;
		data_in <= std_logic_vector(to_unsigned(dvr, data_in'length));
		pc <= std_logic_vector(pcr);
	end process;
	
	with cur_state select state_num <=
		to_unsigned(0,4) when READ_START,
		to_unsigned(1,4) when ZERO_REG4,
		to_unsigned(2,4) when READ_STEP,
		to_unsigned(3,4) when READ_FINAL,
		to_unsigned(4,4) when ACC_X,
		to_unsigned(5,4) when X_PLUS_STEP,
		to_unsigned(6,4) when ACC_PLUS_X,
		to_unsigned(7,4) when LOOP_TEST,
		to_unsigned(8,4) when PRINT_TEMP,
		to_unsigned(9,4) when WRITE_ACC;
end architecture;