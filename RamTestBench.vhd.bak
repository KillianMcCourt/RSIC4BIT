library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_tb is
end entity ram_tb;

architecture tb_arch of ram_tb is
    signal clk_tb      : std_logic := '0';
    signal rst_tb      : std_logic := '0';
    signal rw_tb       : std_logic;
    signal en_tb       : std_logic;
    signal Adress_tb   : std_logic_vector(7 downto 0);
    signal Data_in_tb  : std_logic_vector(7 downto 0);
    signal Data_out_tb : std_logic_vector(7 downto 0);

    component ram
        port(
            rw        : in std_logic;
            en        : in std_logic;
            clk       : in std_logic;
            rst       : in std_logic;
            Adress    : in std_logic_vector(7 downto 0);
            Data_in   : in std_logic_vector(7 downto 0);
            Data_out  : out std_logic_vector(7 downto 0)
        );
    end component;

begin
    -- Instantiate the ram module
    uut: ram
        port map(
            rw        => rw_tb,
            en        => en_tb,
            clk       => clk_tb,
            rst       => rst_tb,
            Adress    => Adress_tb,
            Data_in   => Data_in_tb,
            Data_out  => Data_out_tb
        );

    -- Clock generation process
    process
    begin
        while now < 100 ns loop
            clk_tb <= not clk_tb;
            wait for 5 ns;  -- Adjust the clock
