--------------------------------------------------------------------------------
--@author WILMS Marion
--@date 13 Novembre 2018
--@component Inv_S_Box_tb
--------------------------------------------------------------------------------

--library declaration
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
library AESLibrary;
use AESLibrary.state_definition_package.all;
library source;
use source.all;

--empty entity
entity Inv_S_BOX_tb is
end Inv_S_BOX_tb;

architecture Inv_S_BOX_tb_arch of Inv_S_BOX_tb is
	--component ports
	component Inv_S_BOX
	port (
			inv_s_box_i: in bit8;
			inv_s_box_o: out bit8);
	end component;

	--definition des signaux
	signal Inv_S_BOX_is : bit8;
	signal Inv_S_BOX_os : bit8;

	begin --adder_tb_arch

	--component instanciation
	DUT : Inv_S_BOX
	  port map (
		inv_s_box_i 	=> inv_s_box_is,
	 	inv_s_box_o 	=> inv_s_box_os);

		-- process pour tester les 256 valeurs d'entrees (test exhaustif)
		P0 : process
			variable count  : bit8 := "00000000"; --entree bit8


		begin
			wait for 100 ns; --pour visualiser sur modelsim
			if count = "11111111" then
				count := "00000000";
			else
				count := std_logic_vector(count + 1); --incrementation compteur
			end if;
			Inv_S_BOX_is <= std_logic_vector(count);
		end process P0;
	end architecture Inv_S_BOX_tb_arch;

-- configuration du test bench
configuration Inv_S_BOX_tb_conf of Inv_S_BOX_tb is
for Inv_S_BOX_tb_arch
	for DUT : Inv_S_BOX
		use entity source.Inv_S_BOX(Inv_S_BOX_arch);
	end for;
end for;
end Inv_S_BOX_tb_conf;
