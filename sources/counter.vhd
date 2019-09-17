--------------------------------------------------------------------------------
--@author WILMS Marion
--@date 28 Novembre 2018
--@component Counter
--------------------------------------------------------------------------------
--library declaration
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library AESLibrary;
use AESLibrary.state_definition_package.all;
library source;
use source.all;

--declaration entite
-- il s'agit d'un decompteur
entity Counter is

	port(
	 clock_i, enable_i, resetb_i : in std_logic;
	 counter_o : out bit4
	);

end Counter;

--architecture
architecture Counter_arch of Counter is

	--definition des signaux
	signal counter_s : integer range 0 to 15; --sur 4 bits donc de 0 à 15

	begin

	seq_0 : process (clock_i, resetb_i, enable_i)  --liste de sensibilitee

		begin

		if resetb_i = '0' then				-- reset a l'etat bas recommande
			counter_s <= 10; --initialisation a 10
		elsif clock_i'event and clock_i = '1' then		--synchrone
			if enable_i = '1' then							--decrementation si enable
				counter_s <= counter_s - 1;
			else
				counter_s <= counter_s;
			end if;
		else
			counter_s <= counter_s;
		end if;
	end process seq_0;
	counter_o <= std_logic_vector(to_unsigned(counter_s, 4));		--transformation en bit4

end architecture Counter_arch;
