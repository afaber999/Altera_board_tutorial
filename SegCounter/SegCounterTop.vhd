
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SegCounterTop is
   port (
      clk   : in std_logic;
      led7  : out std_logic_vector(7 downto 0);
      led7s : out std_logic_vector(7 downto 0)
   );
end SegCounterTop;

architecture RTL of SegCounterTop is

   signal r_clk1Hz   : std_logic := '0';
   signal r_clk762Hz : std_logic := '0';

   signal r_digit_0   : std_logic_vector(3 downto 0) := x"F";
   signal r_digit_1   : std_logic_vector(3 downto 0) := x"A";
   signal r_digit_2   : std_logic_vector(3 downto 0) := x"C";
   signal r_digit_3   : std_logic_vector(3 downto 0) := x"E";
   signal r_digit_4   : std_logic_vector(3 downto 0) := x"3";
   signal r_digit_5   : std_logic_vector(3 downto 0) := x"2";
   signal r_digit_6   : std_logic_vector(3 downto 0) := x"1";
   signal r_digit_7   : std_logic_vector(3 downto 0) := x"0";
	
begin

  -- An instance of T15_Mux with architecture rtl
  INST_SEGCOUNTER  : entity work.SegCounter(rtl) port map(
        i_clk     => r_clk762Hz,
        i_digit_0 => r_digit_0,
        i_digit_1 => r_digit_1,
        i_digit_2 => r_digit_2,
        i_digit_3 => r_digit_3,
        i_digit_4 => r_digit_4,
        i_digit_5 => r_digit_5,
        i_digit_6 => r_digit_6,
        i_digit_7 => r_digit_7,
     
        o_led7    => led7,
        o_led7s   => led7s 
  );

   -- Process to generate 7 clock, bases on 50 Mhz system clock
   P_CLK762HZ : process (clk)
      variable counter_762Hz : INTEGER range 0 to ((2**15)-1) := 0;
   begin
      if rising_edge(clk) then
         if counter_762Hz = ((2**15)-1) then
            r_clk762Hz <= not r_clk762Hz;
            counter_762Hz := 0;
         else
            counter_762Hz := counter_762Hz + 1;
         end if;
      end if;
   end process P_CLK762HZ;

   P2 : process (r_clk762Hz)
      variable counter_1Hz : INTEGER range 0 to ((762/2)-1) := 0;
   begin
      if rising_edge(r_clk762Hz) then
         if counter_1Hz = ((762/2)-1) then
            r_clk1Hz <= not r_clk1Hz;
            counter_1Hz := 0;
         else
            counter_1Hz := counter_1Hz + 1;
         end if;
      end if;
   end process P2;


   P2b : process (r_clk1Hz)
   begin
      if rising_edge(r_clk1Hz) then
         if r_digit_7 = x"F" then
            r_digit_7 <= (others => '0');
            if r_digit_6 = x"F" then
            else
              r_digit_6 <= std_logic_vector( unsigned(r_digit_6) + 1 );
            end if;  
          else
            r_digit_7 <= std_logic_vector( unsigned(r_digit_7) + 1 );
         end if;
      end if;
   end process P2b;

	
end RTL;