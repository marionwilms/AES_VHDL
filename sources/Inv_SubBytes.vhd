--------------------------------------------------------------------------------
--@author WILMS Marion
--@date 13 Novembre 2018
--@component InvSubBytes
--------------------------------------------------------------------------------
--library declaration
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library AESLibrary;
use AESLibrary.state_definition_package.all;
library source;
use source.all;

--entite Inv_SubBytes
entity Inv_SubBytes is
    port (
        inv_subbytes_i: in type_state;
        inv_subbytes_o: out type_state);
end entity Inv_SubBytes;

--architecture
architecture Inv_SubBytes_arch of Inv_SubBytes is

--utilisation du composant inv_s_box
component Inv_S_BOX
    port(inv_s_box_i : in bit8;
        inv_s_box_o : out bit8);
end component;

begin
    --parcours de la matrice pour appliquer la transformation inv_s_box a tous les bit8
    ligne : for l in 0 to 3 generate
        colonne : for c in 0 to 3 generate
		    inter: Inv_S_BOX port map (
		        inv_s_box_i => inv_subbytes_i(l)(c),
		        inv_s_box_o => inv_subbytes_o(l)(c));
        end generate colonne;
    end generate ligne;
end Inv_SubBytes_arch;

--configuration
configuration Inv_SubBytes_conf of Inv_SubBytes is
for Inv_SubBytes_arch
	for ligne
		for colonne
			for inter : Inv_S_BOX
				use entity source.Inv_S_BOX(Inv_S_BOX_arch); --utilisation du composant inv_s_box et de son architecture
			end for;
		end for;
	end for;
end for;
end Inv_SubBytes_conf;
