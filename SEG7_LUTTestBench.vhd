library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SEG7_LUT_tb is
end entity SEG7_LUT_tb;

architecture tb_arch of SEG7_LUT_tb is
    signal iDIG_tb : std_logic_vector(3 downto 0);
    signal oSEG_tb : std_logic_vector(6 downto 0);

    component SEG7_LUT
        port (
            iDIG : in std_logic_vector(3 downto 0);
            oSEG : out std_logic_vector(6 downto 0)
        );
    end component;

begin
    -- Instantiate the SEG7_LUT module
    uut: SEG7_LUT
        port map(
            iDIG => iDIG_tb,
            oSEG => oSEG_tb
        );

    -- Stimulus process
    process
    begin
        -- Testcase 1: Input X"1"
        iDIG_tb <= "0001";
        wait for 10 ns;
        assert oSEG_tb = B"1111001"
            report "Testcase 1 failed" severity error;

        -- Testcase 2: Input X"8"
        iDIG_tb <= "1000";
        wait for 10 ns;
        assert oSEG_tb = B"0000000"
            report "Testcase 2 failed" severity error;

        -- Testcase 3: Input X"d"
        iDIG_tb <= "1101";
        wait for 10 ns;
        assert oSEG_tb = B"0100001"
            report "Testcase 3 failed" severity error;

        -- Add more test scenarios as needed

        wait;
    end process;

end tb_arch;
