library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end entity rom_tb;

architecture tb_arch of rom_tb is
    signal clk_tb      : std_logic := '0';
    signal rst_tb      : std_logic := '0';
    signal en_tb       : std_logic;
    signal Adress_tb   : std_logic_vector(7 downto 0);
    signal Data_out_tb : std_logic_vector(7 downto 0);

    component rom
        port(
            en        : in std_logic;
            clk       : in std_logic;
            rst       : in std_logic;
            Adress    : in std_logic_vector(7 downto 0);
            Data_out  : out std_logic_vector(7 downto 0)
        );
    end component;

begin
    -- Instantiate the rom module
    uut: rom
        port map(
            en        => en_tb,
            clk       => clk_tb,
            rst       => rst_tb,
            Adress    => Adress_tb,
            Data_out  => Data_out_tb
        );

    -- Clock generation process
    process
    begin
        while now < 100 ns loop
            clk_tb <= not clk_tb;
            wait for 5 ns;  -- Adjust the clock period as needed
        end loop;
        wait;
    end process;

    -- Stimulus process
    process
    begin
        -- Testcase 1: Read data from memory
        rst_tb <= '1';
        wait for 10 ns;
        rst_tb <= '0';
        wait for 10 ns;
        en_tb <= '1';
        Adress_tb <= "00000000";  -- Address 0
        wait for 10 ns;
        assert Data_out_tb = (others => '0')
            report "Testcase 1 failed - Initial read not zero" severity error;

        -- Testcase 2: Read data from memory at a different address
        Adress_tb <= "00000001";  -- Address 1
        wait for 10 ns;
        assert Data_out_tb = (others => '0')
            report "Testcase 2 failed - Read data mismatch" severity error;

        -- Add more test scenarios as needed

        wait;
    end process;

end tb_arch;
