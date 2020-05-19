

LIBRARY ieee;
USE ieee.std_logic_1164.all;

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
        when others => data_out <= x"30";
      end case;
    end if;
  end process;

end RTL;