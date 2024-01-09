library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY register4 IS PORT(
    d   : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    ld  : IN STD_LOGIC; -- load/enable.
    clr : IN STD_LOGIC; -- async. clear.
    clk : IN STD_LOGIC; -- clock.
    q   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) -- output
);
END register4;

ARCHITECTURE description OF register4 IS

BEGIN
    process(clk, clr)
    begin
        if clr = '1' then
            q <= x"00000000";
        elsif rising_edge(clk) then
            if ld = '1' then
                q <= d;
            end if;
        end if;
    end process;
END description;