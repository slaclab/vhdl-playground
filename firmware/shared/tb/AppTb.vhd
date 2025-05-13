library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library surf;
use surf.StdRtlPkg.all;

library work;
use work.AppPkg.all;


entity AppTb is
end AppTb;

architecture behavioral of AppTb is

   -- Signal declarations
   signal clk   : sl := '0';
   signal rst   : sl := '0';
   signal start : sl := '0';
   signal done  : sl;
   signal dout  : slv(CNT_WIDTH_C-1 downto 0);

   -- Constant for clock period
   constant CLK_PERIOD_C : time := 10 ns;

   -- Instantiate the DUT (Device Under Test)
   begin

   U_Clk : entity surf.ClkRst
      generic map (
         CLK_PERIOD_G      => CLK_PERIOD_C,
         CLK_DELAY_G       => 1 ns,
         RST_START_DELAY_G => 0 ns,
         RST_HOLD_TIME_G   => 5 us,
         SYNC_RESET_G      => true)
      port map (
         clkP => clk,
         clkN => open);

   U_Dut: entity work.App
      generic map (
         TPD_G          => 1 ns,
         RST_ASYNC_G    => false,
         RST_POLARITY_G => '1',
         DELAY_G        => OUT_DELAY_C)
      port map (
         clk   => clk,
         rst   => rst,
         start => start,
         done  => done,
         dout  => dout);

   -- Test stimulus process
   stimulus_process : process
   begin
      -- Initial reset
      rst <= '1';
      wait for CLK_PERIOD_C*10;
      rst <= '0';

      -- Test case 1: Start counting
      start <= '1';
      wait for CLK_PERIOD_C*5;
      start <= '0';

      -- Wait for done signal
      wait until done = '1';
      wait for CLK_PERIOD_C*10;

      -- Finish simulation
      wait;
   end process;

end behavioral;