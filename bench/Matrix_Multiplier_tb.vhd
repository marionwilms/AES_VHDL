--------------------------------------------------------------------------------
--@author WILMS Marion
--@date 23 Novembre 2018
--@component Matrix_Multiplier_tb
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
entity Matrix_Multiplier_tb is
end Matrix_Multiplier_tb;

--architecture
architecture Matrix_Multiplier_tb_arch of Matrix_Multiplier_tb is

	component Matrix_Multiplier
	port (
		matrix_multiplier_i : in column_state;
		matrix_multiplier_o : out column_state
	);
	end component;

--declaration signaux
-- test Round 1 de Resto en ville? pour voir si on retrouve la sortie de ShiftRows du Round 1
	signal matrix_multiplier_is : column_state := (x"37", x"cf", x"02", x"3e");
	signal matrix_multiplier_os : column_state;

	begin --Matrix_Multiplier_tb_arch

	--component instanciation
	DUT : Matrix_Multiplier
	  port map (
		matrix_multiplier_i => matrix_multiplier_is,
        	matrix_multiplier_o => matrix_multiplier_os);

		--debut process
		P0 : process

		begin
			wait for 100 ns; --pour visualiser sur modelsim
		end process P0;
	end architecture Matrix_Multiplier_tb_arch;

--configuration
configuration Matrix_Multiplier_tb_conf of Matrix_Multiplier_tb is
for Matrix_Multiplier_tb_arch
	for DUT : Matrix_Multiplier
		use entity source.Matrix_Multiplier(Matrix_Multiplier_arch);
	end for;
end for;
end Matrix_Multiplier_tb_conf;
