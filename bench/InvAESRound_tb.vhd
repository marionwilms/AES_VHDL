--------------------------------------------------------------------------------
--@author WILMS Marion
--@date 04 Decembre 2018
--@component InvAESRound_tb
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
entity InvAESRound_tb is
end InvAESRound_tb;

--architecture
architecture InvAESRound_tb_arch of InvAESRound_tb is

  component InvAESRound is

  	port(
  	 enableMixColumns_i, enableRoundComputing_i, clock_i, resetb_i : in std_logic;
	 currentkey_i, currenttext_i : in bit128;
	 data_o : out bit128
	);
  end component;

--signaux
signal enableMixColumns_is, enableRoundComputing_is, resetb_is : std_logic;
signal clock_is : std_logic := '0';
signal currentkey_is, currenttext_is : bit128;
signal data_os : bit128;

begin

DUT : InvAESRound port map (
	enableMixColumns_i => enableMixColumns_is,
	enableRoundComputing_i => enableRoundComputing_is,
	resetb_i => resetb_is,
	currenttext_i => currenttext_is,
	currentkey_i => currentkey_is,
	clock_i => clock_is,
	data_o => data_os
);

--on test pour le round 9 donc avec les 4 transformations
enableMixColumns_is <= '0', '1' after 20 ns, '0' after 70 ns;
enableRoundComputing_is <= '0', '1' after 20 ns, '0' after 70 ns;
resetb_is <= '1','0' after 5 ns, '1' after 15 ns;
clock_is <= not clock_is after 25 ns;
currentkey_is <= x"ac7766f319fadc2128d12941575c006e";  --clef du round 9
currenttext_is <= x"06fb5f748506ca5ba654998e6109c156"; --text a l'entree du round 9

end InvAESRound_tb_arch;

--configuration
configuration InvAESRound_tb_conf of InvAESRound_tb is
	for InvAESRound_tb_arch
		for DUT : InvAESRound
			use entity source.InvAESRound(InvAESRound_arch);
		end for;
	end for;
end InvAESRound_tb_conf;
