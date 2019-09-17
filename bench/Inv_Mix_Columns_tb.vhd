--------------------------------------------------------------------------------
--@author WILMS Marion
--@date 23 Novembre 2018
--@component Inv_Mix_Columns_tb
--------------------------------------------------------------------------------
--library declaration
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library AESLibrary;
use AESLibrary.state_definition_package.all;
library source;
use source.all;

-- empty entity
entity Inv_Mix_Columns_tb is
end Inv_Mix_Columns_tb;

--architecture
architecture Inv_Mix_Columns_tb_arch of Inv_Mix_Columns_tb is

	component Inv_Mix_Columns
	port (
		inv_mix_columns_i : in type_state;
		inv_mix_columns_o : out type_state
	);
	end component;

--declaration signaux
-- test Round 1 de Resto en ville? pour voir si on retrouve la sortie de ShiftRows du Round 1
	signal inv_mix_columns_is : type_state := ((x"37",x"4d",x"4e",x"b0"),(x"cf",x"f1", x"c3", x"81"), (x"02", x"02", x"d4", x"10"), (x"3e", x"10", x"13", x"03"));
	signal inv_mix_columns_os : type_state;

	begin --Inv_Mix_Columns_tb_arch

	--component instanciation
	DUT : Inv_Mix_Columns
	  port map (
			inv_mix_columns_i => inv_mix_columns_is,
      inv_mix_columns_o => inv_mix_columns_os);

		--debut process
		P0 : process

		begin
			wait for 100 ns; --pour pouvoir visualiser sur modelsim
		end process P0;
	end architecture Inv_Mix_Columns_tb_arch;

--configuration
configuration Inv_Mix_Columns_tb_conf of Inv_Mix_Columns_tb is
for Inv_Mix_Columns_tb_arch
	for DUT : Inv_Mix_Columns
		use entity source.Inv_Mix_Columns(Inv_Mix_Columns_arch);
	end for;
end for;
end Inv_Mix_Columns_tb_conf;
