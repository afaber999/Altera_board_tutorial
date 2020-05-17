
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SegCounter is
   port (
      clk   : in std_logic;
      led7  : out std_logic_vector(7 downto 0);
      led7s : out std_logic_vector(7 downto 0)
   );
end SegCounter;

architecture RTL of SegCounter is

   signal clk_1Hz   : std_logic := '0';
   signal clk_100Hz : std_logic := '0';
   signal led_counter : INTEGER range 0 to 15 := 0;
   signal seg_counter : INTEGER range 0 to  7 := 0;

begin

   -- Process to generate 1Hz clock, bases on 50 Mhz system clock
   P1 : process (clk)
      variable counter_100Hz : INTEGER range 0 to 249999 := 0;
   begin
      if rising_edge(clk) then
         if counter_100Hz = 249999 then
            clk_100Hz <= not clk_100Hz;
            counter_100Hz := 0;
         else
            counter_100Hz := counter_100Hz + 1;
         end if;
      end if;
   end process P1;

   P2 : process (clk_100Hz)
      variable counter_1Hz : INTEGER range 0 to 100 := 0;
   begin
      if rising_edge(clk_100Hz) then
         if counter_1Hz = 100 then
            clk_1Hz <= not clk_1Hz;
            counter_1Hz := 0;
         else
            counter_1Hz := counter_1Hz + 1;
         end if;
      end if;
   end process P2;


   -- LED output process
   P3 : process (clk_1Hz)
      -- variable led_counter : integer range 0 to 15 := 0;
   begin
      if rising_edge(clk_1Hz) then
         if led_counter = 15 then
            led_counter <= 0;
         else
            led_counter <= led_counter + 1;
         end if;

         case led_counter is
            when 0 => led7s <= "11000000"; --0 
            when 1 => led7s <= "11111001"; --1 
            when 2 => led7s <= "10100100"; --2 
            when 3 => led7s <= "10110000"; --3 
            when 4 => led7s <= "10011001"; --4 
            when 5 => led7s <= "10010010"; --5 
            when 6 => led7s <= "10000010"; --6 
            when 7 => led7s <= "11111000"; --7 
            when 8 => led7s <= "10000000"; --8 
            when 9 => led7s <= "10010000"; --9 
            when 10 => led7s <= "10001000"; --A
            when 11 => led7s <= "10000011"; --b
            when 12 => led7s <= "11000110"; --C
            when 13 => led7s <= "10100001"; --d
            when 14 => led7s <= "10000110"; --E
            when 15 => led7s <= "10001110"; --F
            when others => null;
         end case;
					
      end if;
   end process P3;

   P4: process(seg_counter)
   begin
     led7 <= "00000000";
     case seg_counter is
       when 0 => led7 <= "10000000"; 
       when 1 => led7 <= "01000000"; 
       when 2 => led7 <= "00100000"; 
       when 3 => led7 <= "00010000"; 
       when 4 => led7 <= "00001000"; 
       when 5 => led7 <= "00000100"; 
       when 6 => led7 <= "00000010";
       when 7 => led7 <= "00000001";
     end case;
   end process P4;

--   with seg_counter select
--	  led7 <= "10000000" when 0,
--	          "01000000" when 1,
--	          "00100000" when 2,
--	          "00010000" when 3,
--	          "00001000" when 4,
--	          "00000100" when 5,
--	          "00000010" when 6,
--	          "00000001" when 7;

end RTL;