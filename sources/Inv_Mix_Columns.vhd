--------------------------------------------------------------------------------
--@author WILMS Marion
--@date 23 Novembre 2018
--@component Inv_Mix_Columns
--------------------------------------------------------------------------------
--library declaration
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library AESLibrary;
use AESLibrary.state_definition_package.all;
library source;
use source.all;

--entite Inv_Mix_Columns
entity Inv_Mix_Columns is
	port (
		inv_mix_columns_i : in type_state;
		inv_mix_columns_o : out type_state
	);
end entity Inv_Mix_Columns;

--debut architecture
architecture Inv_Mix_Columns_arch of Inv_Mix_Columns is
	--utilisation du composant de multiplication sur 1 colonne
	component Matrix_Multiplier
		port (
			matrix_multiplier_i : in column_state;
			matrix_multiplier_o : out column_state
		);
	end component Matrix_Multiplier;

	signal column1_is, column2_is, column3_is, column4_is : column_state; -- colonnes intermediares entrées
	signal column1_os, column2_os, column3_os, column4_os : column_state; -- colonnes intermediares sorties

begin

--passage de ligne à colonne
lignee: for l in 0 to 3 generate
	column1_is(l) <= inv_mix_columns_i(l)(0);
	column2_is(l) <= inv_mix_columns_i(l)(1);
	column3_is(l) <= inv_mix_columns_i(l)(2);
	column4_is(l) <= inv_mix_columns_i(l)(3);
end generate lignee;

-- on utilise 4 composants car on a 4 colonnes (pas besoin de machine d'etat)
	component1 : Matrix_Multiplier
		port map (
			matrix_multiplier_i  => column1_is,
			matrix_multiplier_o  => column1_os
		);

	component2 : Matrix_Multiplier
		port map (
			matrix_multiplier_i  => column2_is,
			matrix_multiplier_o  => column2_os
		);

	component3 : Matrix_Multiplier
		port map (
			matrix_multiplier_i  => column3_is,
			matrix_multiplier_o  => column3_os
		);

	component4 : Matrix_Multiplier
		port map (
			matrix_multiplier_i  => column4_is,
			matrix_multiplier_o  => column4_os
		);

--passage de colonne à ligne
lignes: for l in 0 to 3 generate
	inv_mix_columns_o(l)(0) <= column1_os(l);
	inv_mix_columns_o(l)(1) <= column2_os(l);
	inv_mix_columns_o(l)(2) <= column3_os(l);
	inv_mix_columns_o(l)(3) <= column4_os(l);
end generate lignes;

end architecture Inv_Mix_Columns_arch;

--configuration
configuration Inv_Mix_Columns_conf of Inv_Mix_Columns is
	for Inv_Mix_Columns_arch
		for all : Matrix_Multiplier
			use entity source.Matrix_Multiplier(Matrix_Multiplier_arch);
		end for;
	end for;
end Inv_Mix_Columns_conf;
