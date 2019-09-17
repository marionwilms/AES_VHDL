--------------------------------------------------------------------------------
--@author WILMS Marion
--@date 19 Novembre 2018
--@component Inv_Shift_Rows
--------------------------------------------------------------------------------
--library declaration
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library AESLibrary;
use AESLibrary.state_definition_package.all;
library source;
use source.all;

--entite Inv_Shift_Rows
entity Inv_Shift_Rows is
    port (
        inv_shift_rows_i: in type_state;
        inv_shift_rows_o: out type_state);
end entity Inv_Shift_Rows;

--architecture
architecture Inv_Shift_Rows_arch of Inv_Shift_Rows is

begin
	--permutation des bit8 sur chaque ligne
	inv_shift_rows_o(0) <= inv_shift_rows_i(0);
	inv_shift_rows_o(1) <= inv_shift_rows_i(1)(3)&inv_shift_rows_i(1)(0)&inv_shift_rows_i(1)(1)&inv_shift_rows_i(1)(2);  --& concatenation des lignes
	inv_shift_rows_o(2) <= inv_shift_rows_i(2)(2)&inv_shift_rows_i(2)(3)&inv_shift_rows_i(2)(0)&inv_shift_rows_i(2)(1);
	inv_shift_rows_o(3) <= inv_shift_rows_i(3)(1)&inv_shift_rows_i(3)(2)&inv_shift_rows_i(3)(3)&inv_shift_rows_i(3)(0);

end Inv_Shift_Rows_arch;
