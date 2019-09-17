--------------------------------------------------------------------------------
--@author WILMS Marion
--@date 28 Novembre 2018
--@component FSM_Moore
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
entity FSM_Moore is

	port(
	 start_i, clock_i, resetb_i : in std_logic;
	 round_i : in bit4;
	 done_o, enableCounter_o, enableMixcolumns_o, enableOutput_o, enableRoundComputing_o, getciphertext_o, resetCounter_o : out std_logic);

end entity FSM_Moore;

architecture FSM_Moore_arch of FSM_Moore is

	--definition du type enumere
	type state is (hold, start, round, round0, stop);
	--definition des signaux
	signal etat_present, etat_futur : state;

begin --moore_arch

	--initialisation
	--mise a jour de l'etat present par l'etat futur sur les front montant d'horloge
	seq_0 : process(clock_i, resetb_i)
	begin --process seq_0
		if resetb_i = '0' then
			etat_present <= hold;
		elsif clock_i'event and clock_i ='1' then
			etat_present <= etat_futur;
		else
			etat_present <= etat_present;
		end if;
	end process seq_0;

	--calcul de l'état futur à partir des entrées
	comb0 : process (etat_present, start_i, round_i)
	begin --process comb0
		case etat_present is
			when hold =>
				if start_i = '1' then
					etat_futur <= start;
				else
					etat_futur <= hold;
				end if;
			when start =>
				if round_i = "1010" then
					etat_futur <= round;
				else
					etat_futur <= start;
				end if;
			when round =>
				if round_i = "0001" then
					etat_futur <= round0;
				else
					etat_futur <= round;
				end if;
			when round0 =>
				if round_i = "0000" then
					etat_futur <= stop;
				else
					etat_futur <= round;
				end if;
			when stop =>
				if start_i = '1' then
					etat_futur <= stop;
				else
					etat_futur <= hold;
				end if;
		end case;
	end process comb0;

	--calcul des sorties
	comb1 : process (etat_present)
	begin --process comb1
		case etat_present is
			--initialisation (attente start)
			when hold =>
				done_o <= '0';
				enableCounter_o <= '0';
				enableMixcolumns_o <= '0';
				enableOutput_o <= '0';
				enableRoundComputing_o <= '0';
				getciphertext_o <= '0';
				resetCounter_o <= '0';
			-- round10
			when start =>
				done_o <= '1';								--en phase de dechiffrement
				enableCounter_o <= '1';				--on decremente le round
				enableMixcolumns_o <= '0';		--au round 10 seulement AddRoundKey
				enableOutput_o <= '0';
				enableRoundComputing_o <= '0';
				getciphertext_o <= '1';				--on prend comme texte courant a dechiffrer l'entree
				resetCounter_o <= '1';				--reset a l'etat bas
			--round 9 à 1
			when round =>
				done_o <= '1';								--en phase de dechiffrement
				enableCounter_o <= '1';				--on decremente le round
				enableMixcolumns_o <= '1';		-- on fait les 4 transformations
				enableOutput_o <= '0';
				enableRoundComputing_o <= '1';
				getciphertext_o <= '0';				--on prend le texte de sortie de InvAESRound
				resetCounter_o <= '1';
			--round 0
			when round0 =>
				done_o <= '1';								-- en phase de dechiffrement
				enableCounter_o <= '0';				-- on ne decremente plus le round
				enableMixcolumns_o <= '0';		--on ne fait pas InvMixColumns
				enableOutput_o <= '0';
				enableRoundComputing_o <= '1';
				getciphertext_o <= '0';
				resetCounter_o <= '1';
			-- fin dechiffremenet
			when stop =>
				done_o <= '0';									--fin de dechiffrement
				enableCounter_o <= '0';
				enableMixcolumns_o <= '0';
				enableOutput_o <= '1';					--on autorise la sortie
				enableRoundComputing_o <= '0';
				getciphertext_o <= '0';
				resetCounter_o <= '0';						-- on reset le compteur

		end case;
	end process comb1;
end FSM_Moore_arch;
