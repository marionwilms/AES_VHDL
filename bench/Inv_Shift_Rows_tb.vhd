--------------------------------------------------------------------------------
--@author WILMS Marion
--@date 19 Novembre 2018
--@component Inv_Shift_Rows_tb
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
entity Inv_Shift_Rows_tb is
end Inv_Shift_Rows_tb;

--architecture
architecture Inv_Shift_Rows_tb_arch of Inv_Shift_Rows_tb is

	component Inv_Shift_Rows
	port (
		inv_shift_rows_i: in type_state;
        	inv_shift_rows_o: out type_state);
	end component;

	--declaration signaux
	-- test Round 1 de Resto en ville? pour voir si on retrouve la sortie de SubBytes du Round 1
	signal inv_shift_rows_is : type_state := ((x"b6", x"a0", x"3d", x"4d"),(x"19", x"0c", x"ac", x"af"),(x"10", x"a8", x"33", x"a9"),(x"7b", x"aa", x"e8", x"69"));
	signal inv_shift_rows_os : type_state;

	begin --Add_Round_Key_tb_arch

	--component instanciation
	DUT : Inv_Shift_Rows
	  port map (
			inv_shift_rows_i => inv_shift_rows_is,
      inv_shift_rows_o => inv_shift_rows_os);

		--debut process
		P0 : process

		begin
			wait for 100 ns; --pour pouvoir obeserver sur modelsim
		end process P0;
	end architecture Inv_Shift_Rows_tb_arch;

--configuration
configuration Inv_Shift_Rows_tb_conf of Inv_Shift_Rows_tb is
for Inv_Shift_Rows_tb_arch
	for DUT : Inv_Shift_Rows
		use entity source.Inv_Shift_Rows(Inv_Shift_Rows_arch);
	end for;
end for;
end Inv_Shift_Rows_tb_conf;
