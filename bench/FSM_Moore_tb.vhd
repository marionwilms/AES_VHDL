--------------------------------------------------------------------------------
--@author WILMS Marion
--@date 28 Novembre 2018
--@component FSM_Moore_tb
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
entity FSM_Moore_tb is
end FSM_Moore_tb;

architecture FSM_Moore_tb_arch of FSM_Moore_tb is

  component FSM_Moore is

  	port(
  	 start_i, clock_i, resetb_i : in std_logic;
  	 round_i : in bit4;
  	 done_o, enableCounter_o, enableMixcolumns_o, enableOutput_o, enableRoundComputing_o, getciphertext_o, resetCounter_o : out std_logic
     );
  end component;

--signaux
signal start_is, resetb_is : std_logic;
signal clock_is : std_logic := '0';
signal round_is : bit4;
signal done_os, enableCounter_os, enableMixcolumns_os, enableOutput_os, enableRoundComputing_os, getciphertext_os, resetCounter_os : std_logic;

begin
--association ports et signaux
DUT : FSM_Moore port map (
	  start_i => start_is,
	  clock_i => clock_is,
  	round_i => round_is,
	  resetb_i => resetb_is,
	  done_o => done_os,
  	enableCounter_o => enableCounter_os,
  	enableMixcolumns_o => enableMixcolumns_os,
  	enableOutput_o => enableOutput_os,
  	enableRoundComputing_o => enableRoundComputing_os,
  	getciphertext_o => getciphertext_os,
  	resetCounter_o => resetCounter_os
);

start_is <= '0', '1' after 10 ns, '0' after 30 ns;
resetb_is <= '1';
clock_is <= not clock_is after 25 ns; --oscillation de l'horloge
-- décrementation manuelle des round
round_is <= "1010" after 50 ns, "1001" after 100 ns, "1000" after 150 ns, "0111" after 200 ns, "0110" after 250 ns, "0101" after 300 ns, "0100" after 350 ns, "0011" after 400 ns, "0010" after 450 ns, "0001" after 500 ns, "0000" after 550 ns;

end FSM_Moore_tb_arch;

configuration FSM_Moore_tb_conf of FSM_Moore_tb is
	for FSM_Moore_tb_arch
		for DUT : FSM_Moore
			use entity source.FSM_Moore(FSM_Moore_arch);
		end for;
	end for;
end FSM_Moore_tb_conf;
