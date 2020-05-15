-- Tutorial 1

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
                   
ENTITY Tut1 is
  PORT(
    clk  :in  std_logic;
    led1 :out std_logic_vector(11 DOWNTO 0)
  );                                              
END Tut1;



ARCHITECTURE RTL OF Tut1 IS            

  signal clk_1Hz     : std_logic := '0';

BEGIN                                                                  

  -- Generate 1Hz clock
  P1:PROCESS (clk)
		variable counter_1Hz : integer range 0 TO 24999999 := 0;
  BEGIN
    IF rising_edge( clk ) THEN
      IF counter_1Hz = 24999999 THEN
        clk_1Hz <= not clk_1Hz;
  		  counter_1Hz := 0;
      ELSE
  		  counter_1Hz := counter_1Hz + 1;
      END IF;
    END IF;
    
  END PROCESS P1;
  
  
  -- LED counter
  P2 : PROCESS(clk_1Hz)                                              
    variable led_counter : integer range 0 to 15 := 0;
  BEGIN
    IF rising_edge(clk_1Hz) THEN 
     IF led_counter = 15 THEN
        led_counter := 0;
  	  ELSE
        led_counter := led_counter + 1;
     END IF;
    END IF;

    CASE led_counter IS
      WHEN 0=>      led1 <="111111111110";
      WHEN 1=>      led1 <="111111111100"; 
      WHEN 2=>      led1 <="111111111000";
      WHEN 3=>      led1 <="111111110000";
      WHEN 4=>      led1 <="111111100000";
      WHEN 5=>      led1 <="111111000000";
      WHEN 6=>      led1 <="111110000000";
      WHEN 7=>      led1 <="111100000000";
      WHEN 8=>      led1 <="111000000000";
      WHEN 9=>      led1 <="110000000000";
      WHEN 10=>     led1 <="100000000000";
      WHEN 11=>     led1 <="000000000000"; 
      WHEN OTHERS=> led1 <="111111111111";             
    END CASE;
	 
  END PROCESS P2; 
 
END RTL;
