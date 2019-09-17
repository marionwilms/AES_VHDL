--------------------------------------------------------------------------------
--@author WILMS Marion
--@date 19 Novembre 2018
--@component AddRoundKey_tb
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
entity Add_Round_Key_tb is
end Add_Round_Key_tb;

--architecture
architecture Add_Round_Key_tb_arch of Add_Round_Key_tb is

	component Add_Round_Key
	port (
		ark_i: in type_state;   --entree
		clef_i: in type_state;  --clef
    ark_o: out type_state); --sortie
	end component;

	--declaration signaux
	-- test Round 0 de Resto en ville? pour voir si on retrouve le Plain text du Round 0
	signal ark_is : type_state := ((x"79", x"47", x"8b", x"65"),(x"1b", x"8e", x"81", x"aa"),(x"66", x"b7", x"7c", x"6f"),(x"62", x"c8", x"e4", x"03"));
	signal clef_is : type_state := ((x"2b", x"28", x"ab", x"09"),(x"7e", x"ae", x"f7", x"cf"),(x"15", x"d2", x"15", x"4f"),(x"16", x"a6", x"88", x"3c"));
	signal ark_os : type_state;

	begin --Add_Round_Key_tb_arch

	--component instanciation
	DUT : Add_Round_Key
	  port map (
		ark_i	=> ark_is,
		clef_i 	=> clef_is,
	 	ark_o 	=> ark_os);

		--debut process
		P0 : process

		begin
			wait for 100 ns;		--pour pouvoir visualiser sur modelsim
		end process P0;
	end architecture Add_Round_Key_tb_arch;

--configuration
configuration Add_Round_Key_tb_conf of Add_Round_Key_tb is
for Add_Round_Key_tb_arch
	for DUT : Add_Round_Key
		use entity source.Add_Round_Key(Add_Round_Key_arch);
	end for;
end for;
end Add_Round_Key_tb_conf;
