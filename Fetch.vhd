library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_textio.all;

entity Fetch_tb is
end Fetch_tb;

architecture testbench of Fetch_tb is
    signal clk, rst, en, PC_load : std_logic := '0';
    signal PC_jump : std_logic_vector(7 downto 0) := (others => '0');
    signal PC_out_expected : std_logic_vector(7 downto 0);
    signal PC_out_actual : std_logic_vector(7 downto 0);

    component Fetch
        port (
            en : in std_logic;
            clk : in std_logic;
            rst : in std_logic;
            PC_load : in std_logic;
            PC_jump : in std_logic_vector(7 downto 0);
            PC_out : out std_logic_vector(7 downto 0)
        );
    end component;

begin
    -- Instantiate Fetch module
    uut: Fetch port map (en, clk, rst, PC_load, PC_jump, PC_out_actual);

    -- Clock process
    clk_process: process
    begin
        while now < 1000 ns loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_process: process
    begin
        -- Test case 1: Increment PC
        PC_out_expected <= "00000001";
        wait for 10 ns;
        en <= '1';
        PC_load <= '0';
        wait for 10 ns;
        assert PC_out_actual = PC_out_expected report "Error: PC_out mismatch for Test Case 1" severity failure;

        -- Test case 2: Jump to a specific address
        PC_out_expected <= "00000100"; -- Jump to address 4
        wait for 10 ns;
        PC_load <= '1';
        PC_jump <= "00000100";
        wait for 10 ns;
        assert PC_out_actual = PC_out_expected report "Error: PC_out mismatch for Test Case 2" severity failure;

        wait;
    end process;

end testbench;
