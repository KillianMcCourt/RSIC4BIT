library ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity Fetch_tb is
end Fetch_tb;

architecture tb_arch of Fetch_tb is
    -- Import the module
    signal clk, rst, en, PC_load : std_logic := '0';
    signal PC_Jump, PC_out : std_logic_vector(7 downto 0) := (others => '0');
    -- Instantiate the Fetch module
    COMPONENT Fetch
        port(
            en          : in std_logic;
            clk         : in std_logic;
            rst         : in std_logic;
            PC_load     : in std_logic;
            PC_Jump     : in std_logic_vector(7 downto 0);
            PC_out      : out std_logic_vector(7 downto 0)
        );
    end component;

begin
    -- Clock generation process
    process
    begin
        while now < 100 ns loop
            clk <= not clk;
            wait for 5 ns; -- Adjust the clock period as needed
        end loop;
        wait;
    end process;

    -- Stimulus process
    process
    begin
        rst <= '1'; -- Initialize with reset active
        wait for 10 ns;
        rst <= '0'; -- Release the reset
        wait for 10 ns;

        -- Testcase 1: Incrementing PC
        en <= '1';
        PC_load <= '0';
        wait for 10 ns;

        -- Testcase 2: Jump to a valid address
        PC_load <= '1';
        PC_Jump <= "00000010"; -- Jump to address 2
        wait for 10 ns;

        -- Testcase 3: Jump to an invalid address
        PC_Jump <= "110010000"; -- Jump to address 400 (out of range)
        wait for 10 ns;

        -- Add more test scenarios as needed

        wait;
    end process;

    -- Instantiate the Fetch module
    uut: Fetch
        port map(
            en      => en,
            clk     => clk,
            rst     => rst,
            PC_load => PC_load,
            PC_Jump => PC_Jump,
            PC_out  => PC_out
        );

end tb_arch;