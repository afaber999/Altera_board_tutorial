
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ExpProjectTop is
   port (
      i_clk          : in std_logic;
      i_push_button_4: in std_logic;
      i_push_button_5: in std_logic;
      i_dip_switch   : in std_logic;
      i_rxd          : in std_logic;

      i_dipswitch    : in std_logic_vector(7 downto 0);
      o_led7         : out std_logic_vector(7 downto 0);
      o_led7s        : out std_logic_vector(7 downto 0);
      o_led          : out std_logic_vector(11 downto 0);
      o_txd          : out std_logic
   );

end ExpProjectTop;

architecture RTL of ExpProjectTop is

  constant c_ClkFrequency : integer := 50000000;
  constant c_ClkPeriod    : time    := 1 sec / c_ClkFrequency;
  constant c_BaudRate     : integer := 115200;
  constant c_CLKS_PER_BIT : integer := (c_ClkFrequency + c_BaudRate / 2 ) / c_BaudRate;
    
  signal r_clk1Hz         : std_logic := '0';
  signal r_clk190Hz       : std_logic := '0';
  signal r_clk762Hz       : std_logic := '0';

  signal r_acounter       : std_logic_vector(15 downto 0) := x"FFF0";
  signal r_bcounter       : std_logic_vector(15 downto 0) := x"0001";

  signal r_push_button_4  : std_logic := '1';
  signal r_push_button_5  : std_logic := '1';
    
  signal r_TX_DV          : std_logic := '0';
  signal r_TX_Byte        : std_logic_vector(7 downto 0);

begin
  o_led(7 downto 0) <= i_dipswitch(7 downto 0);
	
  -- An instance of T15_Mux with architecture rtl
  INST_SEGCOUNTER  : entity work.SegCounter(rtl) port map(
        i_clk     => r_clk762Hz,
        i_digit_0 => r_acounter(15 downto 12),
        i_digit_1 => r_acounter(11 downto  8),
        i_digit_2 => r_acounter( 7 downto  4),
        i_digit_3 => r_acounter( 3 downto  0),
        i_digit_4 => r_bcounter(15 downto 12),
        i_digit_5 => r_bcounter(11 downto  8),
        i_digit_6 => r_bcounter( 7 downto  4),
        i_digit_7 => r_bcounter( 3 downto  0),
     
        o_led7    => o_led7,
        o_led7s   => o_led7s 
  );


  -- An instance of T15_Mux with architecture rtl
  INST_SWDEB_4  : entity work.SwitchDebouncer(rtl) 
		generic map ( 
			g_single_pulse => true,
			g_invert_input => true )
		port map(
        i_clk     => r_clk190Hz,
        i_switch  => i_push_button_4,
        o_switch  => r_push_button_4
		);
  
  -- An instance of T15_Mux with architecture rtl
  INST_SWDEB_5  : entity work.SwitchDebouncer(rtl)
		generic map ( 
			g_single_pulse => true,
			g_invert_input => true )
		port map(
        i_clk     => r_clk190Hz,
        i_switch  => i_push_button_5,
        o_switch  => r_push_button_5
  );

  -- Process to generate 762 Hz clock (to cycle through the 7 segements displays)
  -- based on 50Mhz i_clk
  P_CLK762HZ : process (i_clk)
    variable counter_762Hz : INTEGER range 0 to ((2**15)-1) := 0;
  begin
    if rising_edge(i_clk) then
      if counter_762Hz = counter_762Hz'High then
        r_clk762Hz <= not r_clk762Hz;
        counter_762Hz := 0;
      else
        counter_762Hz := counter_762Hz + 1;
      end if;
    end if;
  end process P_CLK762HZ;

   -- Generate a 190 Hz clock for the debouncing switch(es)
  P_CLK190HZ : process (r_clk762Hz)
    variable counter_190Hz : INTEGER range 0 to 1 := 0;
  begin
    if rising_edge(r_clk762Hz) then
      if counter_190Hz = counter_190Hz'High then
        r_clk190Hz <= not r_clk190Hz;
        counter_190Hz := 0;
      else
        counter_190Hz := counter_190Hz + 1;
      end if;
    end if;
  end process P_CLK190HZ;

  -- Generate a 1 Hz clock for testing purposes
  P_CLK1HZ : process (r_clk190Hz)
    variable counter_1Hz : INTEGER range 0 to ((190/2)-1) := 0;
  begin
    if rising_edge(r_clk190Hz) then
      if counter_1Hz = counter_1Hz'high then
        r_clk1Hz <= not r_clk1Hz;
        counter_1Hz := 0;
      else
        counter_1Hz := counter_1Hz + 1;
      end if;
    end if;
  end process P_CLK1HZ;

 
  P2b : process (r_clk1Hz)
  begin
    if rising_edge(r_clk1Hz) then
      if r_acounter = x"FFFF" then
        r_acounter <= (others => '0');
      else
        r_acounter <= std_logic_vector( unsigned(r_acounter) + 1 );
      end if;
    end if;
  end process P2b;

  -- handle push button events of tactile switch 4 & 5
  P_HANDLEPB : process (r_clk190Hz)
  begin
    if ( rising_edge(r_clk190Hz)) then

      o_led(11 downto 8) <= (others => '1');

      if (r_push_button_4 = '1') then 
        o_led(10) <= '0';
        o_led( 8) <= '0';
        if r_bcounter = x"0000" then
          r_bcounter <= x"FFFF";
        else
          r_bcounter <= std_logic_vector( unsigned(r_bcounter) - 1 );
        end if;
      end if;

      if (r_push_button_5 = '1') then 
        o_led( 9) <= '0';
        o_led(11) <= '0';

        if r_bcounter = x"FFFF" then
          r_bcounter <= x"0000";
        else
          r_bcounter <= std_logic_vector( unsigned(r_bcounter) + 1 );
        end if;
      end if;

    end if;
  end process P_HANDLEPB;
   
  INST_ROM1 : entity work.sync_rom(RTL)
    port map (
      clk      => i_Clk,
      address  => r_bcounter(7 downto 0),
      data_out => r_TX_Byte
    );

  INST_UARTTX : entity work.UART_TX(RTL)
    generic map ( g_CLKS_PER_BIT => c_CLKS_PER_BIT )
    port map (
      i_Clk       => i_Clk,
      i_TX_DV     => r_TX_DV,
      i_TX_Byte   => r_TX_Byte,
      o_TX_Active => open,
      o_TX_Serial => o_txd,
      o_TX_Done   => open
    );
      
  P_SERTX : process (i_clk)
    variable last_btn : std_logic := '0';
  begin
    if ( rising_edge( i_clk) ) then 
      r_TX_DV <= '0';
      if ( (last_btn = '0') and (r_push_button_5 = '1' ) ) then
        r_TX_DV <= '1';
      end if;
		last_btn := r_push_button_5;
		
    end if;
  end process P_SERTX;   

	--o_txd <= i_rxd;
   

end RTL;