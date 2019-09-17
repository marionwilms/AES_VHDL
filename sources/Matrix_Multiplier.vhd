--------------------------------------------------------------------------------
--@author WILMS Marion
--@date 23 Novembre 2018
--@component Matrix_Multiplier
--------------------------------------------------------------------------------
--library declaration
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library AESLibrary;
use AESLibrary.state_definition_package.all;
library source;
use source.all;

--entity
entity Matrix_Multiplier is
	port (
		matrix_multiplier_i : in column_state;
		matrix_multiplier_o : out column_state
	);
end entity Matrix_Multiplier;

--debut architecture
architecture Matrix_Multiplier_arch of Matrix_Multiplier is

--signaux pour multiplication
signal Columnx2_s : column_state; -- multiplication par 2
signal Columnx4_s : column_state; -- multiplication par 4
signal Columnx8_s : column_state; -- multiplication par 8

signal Columnx9_s : column_state; -- multiplication par 9
signal Columnx11_s : column_state; -- multiplication par 0b
signal Columnx13_s : column_state; -- multiplication par 0d
signal Columnx14_s : column_state; -- multiplication par 0e


begin
--on utilise des signaux intermediaires pour les multiplications par 9, 11, 13 et 14 pour eviter les lignes trop longues et pour simplifier la comprehension
multiplication2 : for i in 0 to 3 generate
	Columnx2_s(i) <= (matrix_multiplier_i(i)(6 downto 0) & '0') xor ("000" & matrix_multiplier_i(i)(7) & matrix_multiplier_i(i)(7) & '0' & matrix_multiplier_i(i)(7) & matrix_multiplier_i(i)(7));
end generate multiplication2;

multiplication4 : for i in 0 to 3 generate
	Columnx4_s(i) <= (Columnx2_s(i)(6 downto 0) & '0') xor ("000" & Columnx2_s(i)(7) & Columnx2_s(i)(7) & '0' & Columnx2_s(i)(7) & Columnx2_s(i)(7));
end generate multiplication4;

multiplication8 : for i in 0 to 3 generate
	Columnx8_s(i) <= (Columnx4_s(i)(6 downto 0) & '0') xor ("000" & Columnx4_s(i)(7) & Columnx4_s(i)(7) & '0' & Columnx4_s(i)(7) & Columnx4_s(i)(7));
end generate multiplication8;

multiplication9 : for i in 0 to 3 generate
	Columnx9_s(i) <= Columnx8_s(i) xor matrix_multiplier_i(i);
end generate multiplication9;

multiplication11 : for i in 0 to 3 generate
	Columnx11_s(i) <= Columnx8_s(i) xor Columnx2_s(i) xor matrix_multiplier_i(i);
end generate multiplication11;

multiplication13 : for i in 0 to 3 generate
	Columnx13_s(i) <= Columnx8_s(i) xor Columnx4_s(i) xor matrix_multiplier_i(i);
end generate multiplication13;

multiplication14 : for i in 0 to 3 generate
	Columnx14_s(i) <= Columnx8_s(i) xor Columnx4_s(i) xor Columnx2_s(i);
end generate multiplication14;

-- produit final de la matrice par la colonne
matrix_multiplier_o(0) <= (Columnx14_s(0) xor Columnx11_s(1)) xor (Columnx13_s(2) xor Columnx9_s(3));
matrix_multiplier_o(1) <= (Columnx9_s(0) xor Columnx14_s(1)) xor (Columnx11_s(2) xor Columnx13_s(3));
matrix_multiplier_o(2) <= (Columnx13_s(0) xor Columnx9_s(1)) xor (Columnx14_s(2) xor Columnx11_s(3));
matrix_multiplier_o(3) <= (Columnx11_s(0) xor Columnx13_s(1)) xor (Columnx9_s(2) xor Columnx14_s(3));

end architecture Matrix_Multiplier_arch;
