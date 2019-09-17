--------------------------------------------------------------------------------
--@author WILMS Marion
--@date 19 Novembre 2018
--@component AddRoundKey
--------------------------------------------------------------------------------
--library declaration
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library AESLibrary;
use AESLibrary.state_definition_package.all;
library source;
use source.all;

--entite Add_Round_Key
entity Add_Round_Key is
    port (
        ark_i: in type_state;     --entree
	      clef_i: in type_state;    --clef
        ark_o: out type_state);   --sortie
end entity Add_Round_Key;

--architecture
architecture Add_Round_Key_arch of Add_Round_Key is

begin
    --parcours de la matrice
    ligne : for l in 0 to 3 generate
        colonne : for c in 0 to 3 generate
		--on fait un xor entre l'entree et la clef (l'inverse d'un xor est un xor)
		ark_o(l)(c) <= ark_i(l)(c) xor clef_i(l)(c);
        end generate colonne;
    end generate ligne;
end Add_Round_Key_arch;
