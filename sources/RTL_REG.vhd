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

--entite
entity RTL_REG is

	port(
	 enable_i, clock_i, resetb_i : in std_logic;
	 currenttext_s_i : in bit128;
	 data_o : out bit128);

end entity RTL_REG;

--architecture
architecture RTL_REG_arch of RTL_REG is

--signaux
signal data_os : bit128;
signal data_is : bit128;

begin
	--process combinatoire pour affecter la sortie sur front d'horloge
	comb0 : process(clock_i, resetb_i, data_is)
	begin
		if resetb_i = '0' then
			data_os <= (others => '0');
		elsif clock_i'event and clock_i ='1' then
			data_os <= data_is;
		end if;
	end process comb0;

	--process sequentiel pour affecter la sortie si enable vaut 1.
	seq0 : process(data_os, currenttext_s_i, enable_i)
	begin
		if enable_i = '1' then
			data_is <= currenttext_s_i;
		else
			data_is <= data_os;
		end if;
	end process seq0;

	data_o <= data_os;		--passage par un signal intermediaire


end architecture RTL_REG_arch;
