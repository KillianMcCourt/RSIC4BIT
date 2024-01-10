library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
   Port (
      clk, rst : in STD_LOGIC;
		ALU_enable_ra, ALU_enable_rb: in STD_LOGIC;
		a, b : in STD_LOGIC_VECTOR(3 downto 0);
      ALU_command : in STD_LOGIC_VECTOR(3 downto 0);
		ALU_enable_r : OUT STD_LOGIC;
		ALU_output_a, ALU_output_b : OUT STD_LOGIC_VECTOR(3 downto 0)
   );
end ALU;

architecture Behavioral of ALU is
   signal temp : std_logic_vector(3 downto 0);

begin
   process(clk)
   begin
      if rst = '1' then
         ALU_output <= (others => '0');
      elsif rising_edge(clk) then
         case ALU_command is 
            when "000" => ALU_output <= (others => '0') & (a(3) and b(3)) & (a(2) and b(2)) & (a(1) and b(1)) & (a(0) and b(0));
            when "001" => ALU_output <= a - b;
            when "010" =>
               case a is
                  when "0000" => temp <= b srl 1;
                  when "0001" => temp <= b srl 2;
                  when "0010" => temp <= b srl 3;
                  when "0011" => temp <= b srl 4;
                  when others => temp <= (others => '0');
               end case;
               ALU_output <= temp;

            when "011" =>
               case a is 
                  when "0000" => temp <= b sll 1;
                  when "0001" => temp <= b sll 2;
                  when "0010" => temp <= b sll 3;
                  when "0011" => temp <= b sll 4;
                  when others => temp <= (others => '0');
               end case;
               ALU_output <= temp;

            when "100" => ALU_output <= a and b;
            when "101" => ALU_output <= a or b;
            when "110" => ALU_output <= b;
            when "111" => null; -- You need to define the behavior for this case
            when others => null; -- Add a default behavior if needed
         end case;
      end if;
   end process;
end Behavioral;