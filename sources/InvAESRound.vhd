--------------------------------------------------------------------------------
--@author WILMS Marion
--@date 04 Decembre 2018
--@component InvAESRound
--------------------------------------------------------------------------------
--library declaration
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library AESLibrary;
use AESLibrary.state_definition_package.all;
library source;
use source.all;

--declaration de l'entite
entity InvAESRound is

	port(
	 enableMixColumns_i, enableRoundComputing_i, clock_i, resetb_i : in std_logic;
	 currentkey_i, currenttext_i : in bit128;
	 data_o : out bit128);

end entity InvAESRound;

--debut architecture
architecture InvAESRound_arch of InvAESRound is

	--instanciation des 4 composant de transformation
	component Inv_Mix_Columns
		port (
			inv_mix_columns_i : in type_state;
			inv_mix_columns_o : out type_state
	);
	end component Inv_Mix_Columns;

	component Inv_SubBytes is
    		port (
        		inv_subbytes_i: in type_state;
        		inv_subbytes_o: out type_state);
	end component Inv_SubBytes;

	component Inv_Shift_Rows is
    		port (
        		inv_shift_rows_i: in type_state;
        		inv_shift_rows_o: out type_state);
	end component Inv_Shift_Rows;

	component Add_Round_Key is
    		port (
        		ark_i: in type_state;
			clef_i: in type_state;
        		ark_o: out type_state);
	end component Add_Round_Key;

--signaux

signal inter1_s, outputISB_s, inputark_s, inter3_s, inter4_s, data_os, currentkey_is, currenttext_is: type_state;
signal datainter_s : bit128; --variable intermediaire pour le passage de bit128 a type_state

begin

--transformation bit128 en type_state de la clef
colonne1: for c in 0 to 3 generate
 	ligne1 : for l in 0 to 3 generate
		currentkey_is(l)(c) <= currentkey_i((127-8*(l+c*4)) downto (128-8*(l+c*4+1)));
		currenttext_is(l)(c) <= currenttext_i((127-8*(l+c*4)) downto (128-8*(l+c*4+1)));
	end generate ligne1;
end generate colonne1;


--instanciation components

	ISR : Inv_Shift_Rows
    		port map (
        		inv_shift_rows_i => currenttext_is,
        		inv_shift_rows_o => inter1_s
		);

	ISB : Inv_SubBytes
    		port map (
        		inv_subbytes_i => inter1_s,
        		inv_subbytes_o => outputISB_s
		);



	ARK : Add_Round_Key
    		port map(
        		ark_i => inputark_s,
			clef_i=> currentkey_is,
        		ark_o=> inter3_s
		);

	IMC: Inv_Mix_Columns
		port map(
			inv_mix_columns_i => inter3_s,
			inv_mix_columns_o => inter4_s
		);


--process sequentiel pour multiplexeur en fonction de enableMixColumns
seq_0 : process (enableMixColumns_i, inter4_s, inter3_s)

	begin

	if enableMixColumns_i = '1' then
		data_os <= inter4_s;
	else
		data_os <= inter3_s;

	end if;
end process seq_0;

--process sequentiel pour multiplexeur en fonction de enableRoundComputing
seq_1:process(enableRoundComputing_i, outputISB_s, currenttext_is)
begin
	if (enableRoundComputing_i = '1') then
		inputark_s <= outputISB_s;
	else
		inputark_s <= currenttext_is;
	end if;
end process seq_1;

--passage type_state a bit128
colonne2: for c in 0 to 3 generate
 	ligne2 : for l in 0 to 3 generate
		datainter_s((127-8*(l+c*4)) downto (128-8*(l+c*4+1)))<= data_os(l)(c);
	end generate ligne2;
end generate colonne2;

--processus combinatoire pour envoyer la sortie sur les front d'horloge
comb_1 : process (resetb_i, clock_i, datainter_s)
	begin
	if resetb_i = '0' then
		data_o <= (others =>'0');
	elsif clock_i'event and clock_i = '1' then --pour avoir un rebouclage stable
		data_o <= datainter_s;

	end if;
end process comb_1;

end architecture InvAESRound_arch;

--configuration
configuration InvAESRound_conf of InvAESRound is
	for InvAESRound_arch
		for all : Inv_Mix_Columns
			use entity source.Inv_Mix_Columns(Inv_Mix_Columns_arch);
		end for;
		for all : Inv_SubBytes
			use entity source.Inv_SubBytes(Inv_SubBytes_arch);
		end for;
		for all : Add_Round_Key
			use entity source.Add_Round_Key(Add_Round_Key_arch);
		end for;
		for all : Inv_Shift_Rows
			use entity source.Inv_Shift_Rows(Inv_Shift_Rows_arch);
		end for;
	end for;
end InvAESRound_conf;
