-------------------------------------------------------------------------------
-- Company    : SLAC National Accelerator Laboratory
-------------------------------------------------------------------------------
-- Description: Sample pkg file
--
-------------------------------------------------------------------------------
-- This file is part of 'vhdl-playground'.
-- It is subject to the license terms in the LICENSE.txt file found in the
-- top-level directory of this distribution and at:
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
-- No part of 'vhdl-playground', including this file,
-- may be copied, modified, propagated, or distributed except according to
-- the terms contained in the LICENSE.txt file.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library surf;
use surf.StdRtlPkg.all;

package AppPkg is

   constant OUT_DELAY_C : natural := 5;
   constant CNT_WIDTH_C : natural := 7;

end AppPkg;

package body AppPkg is

end package body AppPkg;
