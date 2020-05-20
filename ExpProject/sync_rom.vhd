

library ieee;
use ieee.std_logic_1164.all;

entity sync_rom is
  port (
    clk      : in std_logic;
    address  : in std_logic_vector(7 downto 0);
    data_out : out std_logic_vector(7 downto 0)
  );
end sync_rom;

architecture RTL of sync_rom is
begin

  process (clk)
  begin
    if rising_edge (clk) then
      case address is
        when X"00" => data_out <= x"41";
        when X"01" => data_out <= x"42";
        when X"02" => data_out <= x"43";
        when X"03" => data_out <= x"44";
        when X"04" => data_out <= x"45";
        when X"05" => data_out <= x"46";
        when X"06" => data_out <= x"47";
        when X"07" => data_out <= x"48";
        when X"08" => data_out <= x"49";
        when X"09" => data_out <= x"4A";
        when X"0A" => data_out <= x"4B";
        when X"0B" => data_out <= x"4C";
        when X"0C" => data_out <= x"4D";
        when X"0D" => data_out <= x"4E";
        when X"0E" => data_out <= x"4F";
        when X"0F" => data_out <= x"50";
        when X"10" => data_out <= x"51";
        when others => data_out <= x"52";
      end case;
    end if;
  end process;

end RTL;