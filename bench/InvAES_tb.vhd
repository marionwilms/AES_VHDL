--------------------------------------------------------------------------------
--@author WILMS Marion
--@date 04 Decembre 2018
--@component InvAES_tb
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
entity InvAES_tb is
end InvAES_tb;

--architecture
architecture InvAES_tb_arch of InvAES_tb is

component InvAES is
  port (
  start_i, clock_i, reset_i : in std_logic;
  data_i : in bit128;
  aes_on_o : out std_logic;
  data_o : out bit128);
end component;

--signaux
signal start_is, reset_is, aes_on_os : std_logic;
signal clock_is : std_logic := '0';
signal data_is : bit128;
signal data_os : bit128;

begin

DUT : InvAES port map (
  start_i => start_is,
  clock_i => clock_is,
  reset_i => reset_is,
  data_i => data_is,
  data_o => data_os,
  aes_on_o => aes_on_os
);

start_is <= '0', '1' after 20 ns, '0' after 40 ns;
reset_is <= '0','1' after 5 ns, '0' after 15 ns;  --ici c'est un reset a l'etat haut
clock_is <= not clock_is after 25 ns;
data_is <= x"d7ca070cc0d3ce1e3943287756404506";

end InvAES_tb_arch;

--configuration
configuration InvAES_tb_conf of InvAES_tb is
	for InvAES_tb_arch
		for DUT : InvAES
			use entity source.InvAES(InvAES_arch);
		end for;
	end for;
end InvAES_tb_conf;
