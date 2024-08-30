library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.mux_p.all;

entity FSM is port (
	clk, zero, negative, carry, overflow: in std_logic;
	pc : out std_logic_vector(13 downto 0)
);
end entity;

architecture ex9 of FSM is
	type state_t is (
		READ_START,
		READ_STEP,
		READ_FINAL,
		ACC_X,
		X_PLUS_STEP,
		ACC_PLUS_X,
		TEMP_FINAL_MINUS_X,
		WRITE_ACC
		);
	signal state: state_t := ACC_X;
begin
	process(clk, state, zero)
	begin
		case state is
			when READ_START => pc <= "1XXXXXXXXXX000"; state <= READ_STEP;
			when READ_STEP => pc <= "1XXXXXXXXXX001"; state <= READ_FINAL;
			when READ_FINAL => pc <= "1XXXXXXXXXX010"; state <= ACC_X;
			when ACC_X => pc <= "00X11100000010"; state <= X_PLUS_STEP;
			when X_PLUS_STEP => pc <= "00X00001000000"; state <= ACC_PLUS_X;
			when ACC_PLUS_X => pc <= "00X00000010010"; state <= TEMP_FINAL_MINUS_X;
			when TEMP_FINAL_MINUS_X => pc <= "00X01000011101";
				if zero = '1'
					then state <= WRITE_ACC;
					else state <= X_PLUS_STEP;
				end if;
			when WRITE_ACC => pc <= "00X11100010010"; state <= WRITE_ACC;
		end case;
	end process;
end architecture;