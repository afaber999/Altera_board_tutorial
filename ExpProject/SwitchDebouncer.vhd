-- Simple switch deboubcer
-- requires an input clock of +- 200 Hz

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SwitchDebouncer is
  generic (
    g_single_pulse : boolean := false;
    g_invert_input : boolean := false
  );
  port (
    -- low clock, +- 200 Hz should be fine
    i_clk     : in std_logic;

    i_switch  : in std_logic;
    o_switch  : out std_logic
  );
end SwitchDebouncer;

architecture RTL of SwitchDebouncer is

  signal r_delay_1 : std_logic := '0';
  signal r_delay_2 : std_logic := '0';
  signal r_delay_3 : std_logic := '0';
  
begin

  P_DEBOUNCE: process (i_clk, r_delay_1, r_delay_2, r_delay_3)
  begin
    if rising_edge(i_clk) then
		if ( g_invert_input ) then 
			r_delay_1 <= not i_switch;
		else
			r_delay_1 <= i_switch;
		end if;
		
      r_delay_2 <= r_delay_1;
      r_delay_3 <= r_delay_2;
    end if;
	 if ( g_single_pulse ) then 
		o_switch <= r_delay_1 and r_delay_2 and ( not r_delay_3);
	 else
		o_switch <= r_delay_1 and r_delay_2 and r_delay_3;
	 end if;
  end process P_DEBOUNCE;

end RTL;
