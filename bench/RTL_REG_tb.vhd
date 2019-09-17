--------------------------------------------------------------------------------
--@author WILMS Marion
--@date 29 Novembre 2018
--@component RTL_REG
--------------------------------------------------------------------------------
--library declaration
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library AESLibrary;
use AESLibrary.state_definition_package.all;
library source;
use source.all;

--empty entity
entity RTL_REG_tb is
end RTL_REG_tb;

--architecture
architecture RTL_REG_tb_arch of RTL_REG_tb is

component RTL_REG is
  port (
  enable_i, clock_i, resetb_i : in std_logic;
  currenttext_s_i : in bit128;
  data_o : out bit128);
end component;

--signaux
signal enable_is, resetb_is : std_logic;
signal clock_is : std_logic := '0';
signal currenttext_is : bit128;
signal data_os : bit128;

begin

DUT : RTL_REG port map (
  clock_i => clock_is,
  resetb_i => resetb_is,
  enable_i => enable_is,
  currenttext_s_i => currenttext_is,
  data_o => data_os
);

enable_is <= '0', '1' after 20 ns, '0' after 145 ns;
resetb_is <= '1','0' after 5 ns, '1' after 15 ns;
clock_is <= not clock_is after 25 ns;
currenttext_is <= x"d6efa6dc4ce8efd2476b9546d76acdf0";

end RTL_REG_tb_arch;

--configuration
configuration RTL_REG_tb_conf of RTL_REG_tb is
	for RTL_REG_tb_arch
		for DUT : RTL_REG
			use entity source.RTL_REG(RTL_REG_arch);
		end for;
	end for;
end RTL_REG_tb_conf;
