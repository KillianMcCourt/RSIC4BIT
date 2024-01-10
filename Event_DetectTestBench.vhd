library ieee;
use ieee.std_logic_1164.all;

entity Event_Detect_tb is
end entity Event_Detect_tb;

architecture tb_arch of Event_Detect_tb is
    signal clk_tb      : std_logic := '0';
    signal IN_Signal_tb : std_logic := '0';
    signal Event_L2H_tb : std_logic;
    signal Event_H2L_tb : std_logic;

    component Event_Detect
        port(
            clk         : in std_logic;
            IN_Signal   : in std_logic;
            Event_L2H   : out std_logic;
            Event_H2L   : out std_logic
        );
    end component;

begin
    -- Instantiate the Event_Detect module
    uut: Event_Detect
        port map(
            clk         => clk_tb,
            IN_Signal   => IN_Signal_tb,
            Event_L2H   => Event_L2H_tb,
            Event_H2L   => Event_H2L_tb
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
        -- Testcase 1: No edge transitions
        wait for 5 ns;
        assert Event_L2H_tb = '0' and Event_H2L_tb = '0'
            report "Testcase 1 failed" severity error;

        -- Testcase 2: Rising edge transition
        IN_Signal_tb <= '0';
        wait for 5 ns;
        IN_Signal_tb <= '1';
        wait for 5 ns;
        assert Event_L2H_tb = '1' and Event_H2L_tb = '0'
            report "Testcase 2 failed" severity error;

        -- Testcase 3: Falling edge transition
        IN_Signal_tb <= '1';
        wait for 5 ns;
        IN_Signal_tb <= '0';
        wait for 5 ns;
        assert Event_L2H_tb = '0' and Event_H2L_tb = '1'
            report "Testcase 3 failed" severity error;

        -- Add more test scenarios as needed

        wait;
    end process;

end tb_arch;
