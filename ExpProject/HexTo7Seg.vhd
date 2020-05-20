
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HexTo7Seg is
  port (
    i_clk       : in std_logic;

    i_digit_0   : in std_logic_vector(3 downto 0);
    i_digit_1   : in std_logic_vector(3 downto 0);
    i_digit_2   : in std_logic_vector(3 downto 0);
    i_digit_3   : in std_logic_vector(3 downto 0);
    i_digit_4   : in std_logic_vector(3 downto 0);
    i_digit_5   : in std_logic_vector(3 downto 0);
    i_digit_6   : in std_logic_vector(3 downto 0);
    i_digit_7   : in std_logic_vector(3 downto 0);

    o_led7      : out std_logic_vector(7 downto 0);
    o_led7s     : out std_logic_vector(7 downto 0)
  );
end HexTo7Seg;

architecture RTL of HexTo7Seg is

  signal w_digit_sel : std_logic_vector(3 downto 0);
  signal r_digit_idx : INTEGER range 0 to  7 := 0;
  
begin

  P_SEL7SEG_STATE: process (i_clk)
  begin
    if rising_edge(i_clk) then
      if r_digit_idx = 7 then
        r_digit_idx <= 0;
      else
        r_digit_idx <= r_digit_idx + 1;
      end if;
    end if;
  end process P_SEL7SEG_STATE;
  
  
  -- select digit to display, enable w_digit_sel 7 segment display and select
  -- input to display
  P_SEL7SEG: process(r_digit_idx,i_digit_0,i_digit_1,i_digit_2,i_digit_3,i_digit_4,i_digit_5,i_digit_6,i_digit_7)
  begin
    w_digit_sel <= i_digit_0;  
    o_led7 <= "00000000";
    case r_digit_idx is
      when 0 => 
        o_led7 <= "01111111";
        w_digit_sel <= i_digit_0;  
      when 1 => 
        o_led7 <= "10111111"; 
        w_digit_sel <= i_digit_1;  
      when 2 => 
        o_led7 <= "11011111";
        w_digit_sel <= i_digit_2;  
      when 3 => 
        o_led7 <= "11101111";
        w_digit_sel <= i_digit_3;  
      when 4 => 
        o_led7 <= "11110111";
        w_digit_sel <= i_digit_4;  
      when 5 => 
        o_led7 <= "11111011";
        w_digit_sel <= i_digit_5;
      when 6 => 
        o_led7 <= "11111101";
        w_digit_sel <= i_digit_6;  
      when 7 => 
        o_led7 <= "11111110";
        w_digit_sel <= i_digit_7; 
    end case;
  end process P_SEL7SEG;

  -- convert selected digit to 7 segment output
  P_HEXTO7SEG : process (w_digit_sel)
  begin
    case w_digit_sel is
      when X"0" => o_led7s <= "11000000";
      when X"1" => o_led7s <= "11111001";
      when X"2" => o_led7s <= "10100100";
      when X"3" => o_led7s <= "10110000";
      when X"4" => o_led7s <= "10011001";
      when X"5" => o_led7s <= "10010010";
      when X"6" => o_led7s <= "10000010";
      when X"7" => o_led7s <= "11111000";
      when X"8" => o_led7s <= "10000000";
      when X"9" => o_led7s <= "10010000";
      when X"A" => o_led7s <= "10001000";
      when X"B" => o_led7s <= "10000011";
      when X"C" => o_led7s <= "11000110";
      when X"D" => o_led7s <= "10100001";
      when X"E" => o_led7s <= "10000110";
      when X"F" => o_led7s <= "10001110";
      when others => null;
    end case;
  end process P_HEXTO7SEG;

end RTL;