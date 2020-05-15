-- Tutorial 1

library ieee;
use ieee.std_logic_1164.all;
use  ieee.numeric_std.all;
                   
entity Tut1 is
  port(
    clk  :in  std_logic;
    led1 :out std_logic_vector(11 downto 0)
  );                                              
end Tut1;


architecture RTL of Tut1 IS            
  signal clk_1Hz     : std_logic := '0';
begin                                                                  

  -- Process to generate 1Hz clock, bases on 50 Mhz system clock
  P1:process (clk)
		variable counter_1Hz : integer range 0 TO 24999999 := 0;
  begin
    if rising_edge( clk ) then
      if counter_1Hz = 24999999 then
        clk_1Hz <= not clk_1Hz;
  		  counter_1Hz := 0;
      else
  		  counter_1Hz := counter_1Hz + 1;
      end if;
    end if;   
  end process P1;
    
  -- LED output process
  P2 : process(clk_1Hz)                                              
    variable led_counter : integer range 0 to 15 := 0;
  begin
    if rising_edge(clk_1Hz) then 
     if led_counter = 15 then
        led_counter := 0;
  	  else
        led_counter := led_counter + 1;
     end if;
    end if;

    case led_counter is
      when 0=>      led1 <="111111111110";
      when 1=>      led1 <="111111111100"; 
      when 2=>      led1 <="111111111000";
      when 3=>      led1 <="111111110000";
      when 4=>      led1 <="111111100000";
      when 5=>      led1 <="111111000000";
      when 6=>      led1 <="111110000000";
      when 7=>      led1 <="111100000000";
      when 8=>      led1 <="111000000000";
      when 9=>      led1 <="110000000000";
      when 10=>     led1 <="100000000000";
      when 11=>     led1 <="000000000000"; 
      when OTHERS=> led1 <="111111111111";             
    end case;	 
  end process P2; 
 
end RTL;
