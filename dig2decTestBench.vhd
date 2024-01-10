library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dig2dec_tb is
end entity dig2dec_tb;

architecture tb_arch of dig2dec_tb is
    signal vol_tb    : std_logic_vector(15 downto 0) := "0000000000000000";
    signal seg4_tb   : std_logic_vector(3 downto 0);
    signal seg3_tb   : std_logic_vector(3 downto 0);
    signal seg2_tb   : std_logic_vector(3 downto 0);
    signal seg1_tb   : std_logic_vector(3 downto 0);
    signal seg0_tb   : std_logic_vector(3 downto 0);

    component dig2dec
        port (
            vol  : in std_logic_vector(15 downto 0);
            seg4 : out std_logic_vector(3 downto 0);
            seg3 : out std_logic_vector(3 downto 0);
            seg2 : out std_logic_vector(3 downto 0);
            seg1 : out std_logic_vector(3 downto 0);
            seg0 : out std_logic_vector(3 downto 0)
        );
    end component;

begin
    -- Instantiate the dig2dec module
    uut: dig2dec
        port map(
            vol  => vol_tb,
            seg4 => seg4_tb,
            seg3 => seg3_tb,
            seg2 => seg2_tb,
            seg1 => seg1_tb,
            seg0 => seg0_tb
        );

    -- Stimulus process
    process
    begin
        -- Testcase 1: Input "1234" (binary 0000 0100 1101 0010)
        vol_tb <= "0000010011010010";
        wait for 10 ns;
        assert(seg4_tb = "0001" and seg3_tb = "0010" and seg2_tb = "0011" and seg1_tb = "0100" and seg0_tb = "0000")
            report "Testcase 1 failed" severity error;

        -- Testcase 2: Input "9876" (binary 0010 0011 1001 1100)
        vol_tb <= "0010001110011100";
        wait for 10 ns;
        assert(seg4_tb = "1001" and seg3_tb = "1000" and seg2_tb = "0111" and seg1_tb = "0110" and seg0_tb = "0000")
            report "Testcase 2 failed" severity error;

        -- Add more test scenarios as needed

        wait;
    end process;

end tb_arch;
