library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Decoder is
   Port (
      clk, rst : in STD_LOGIC;
      Ra, Rb : in STD_LOGIC_VECTOR(3 downto 0);
      opcode : in STD_LOGIC_VECTOR(7 downto 0);
		decoder_enable_ra, decoder_enable_rb: OUT STD_LOGIC;
      ALU_command : out STD_LOGIC_VECTOR(3 downto 0);
      a, b : out STD_LOGIC_VECTOR(3 downto 0)
   );
end Decoder;

architecture Behavioral of Decoder is
   signal format : std_logic_vector(1 downto 0); -- 2 bits
   signal operator : std_logic_vector(2 downto 0); -- 3 bits
   signal output : std_logic_vector(3 downto 0); -- Added signal declaration

begin
   process(clk)
   begin
      if rst = '1' then
         output <= (others => '0');
      elsif rising_edge(clk) then
         format <= opcode(7 downto 6);
         operator <= opcode(5 downto 2);
         
         ALU_command <= operator;
         a <= Ra;
         b <= Rb;
      end if;
   end process;
end Behavioral;