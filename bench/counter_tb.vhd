--------------------------------------------------------------------------------
--@author WILMS Marion
--@date 28 Novembre 2018
--@component Counter_tb
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
entity Counter_tb is
end Counter_tb;

--architecture
architecture Counter_tb_arch of Counter_tb is

	component Counter is

	port(
	 clock_i, enable_i, resetb_i : in std_logic; 	--entrees
	 counter_o : out bit4													--sortie
	);

	end component;

--signaux
signal clock_is : std_logic := '0';
signal enable_is : std_logic := '0';
signal resetb_is : std_logic;										--reset a l'etat bas
signal counter_os : bit4;

begin

--association ports et signaux
DUT : Counter port map (
	clock_i => clock_is,
	enable_i => enable_is,
	resetb_i => resetb_is,
	counter_o => counter_os
);

clock_is <= not clock_is after 25 ns;
resetb_is <= '1', '0' after 10 ns,'1' after 20 ns;

P0: process
	begin
	wait for 50 ns;
	if enable_is = '1' then
		enable_is <= '0';
	else
		enable_is <= '1';
	end if;
end process P0;

end architecture Counter_tb_arch;

configuration Counter_tb_conf of Counter_tb is
	for Counter_tb_arch
		for DUT : Counter
			use entity source.Counter(Counter_arch);
		end for;
	end for;
end Counter_tb_conf;
