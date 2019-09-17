--------------------------------------------------------------------------------
--@author WILMS Marion
--@date 13 Novembre 2018
--@component InvSubBytes_tb
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
entity Inv_SubBytes_tb is
end Inv_SubBytes_tb;

--architecture
architecture Inv_SubBytes_tb_arch of Inv_SubBytes_tb is

	component Inv_SubBytes
	port (
			inv_subbytes_i: in type_state;
			inv_subbytes_o: out type_state);
	end component;

	--declaration signaux
	-- test Round 1 de Resto en ville? pour voir si on retrouve le message après AddRoundKey du Round 0
	signal inv_subbytes_is : type_state := ((x"b6", x"a0", x"3d", x"4d"),(x"af", x"19", x"0c", x"ac"),(x"33", x"a9", x"10", x"a8"),(x"aa", x"e8", x"69", x"7b"));
	signal inv_subbytes_os : type_state;

	begin --inv_SubBytes_tb_arch

	--component instanciation
	DUT : Inv_SubBytes
	  port map (
		inv_subbytes_i	=> inv_subbytes_is,
	 	inv_subbytes_o 	=> inv_subbytes_os);

		--debut process
		P0 : process

		begin
			wait for 100 ns;	--pour pouvoir visualiser sur modelsim
		end process P0;
	end architecture Inv_SubBytes_tb_arch;

--configuration
configuration Inv_SubBytes_tb_conf of Inv_SubBytes_tb is
for Inv_SubBytes_tb_arch
	for DUT : Inv_SubBytes
		use configuration source.Inv_SubBytes_conf;
	end for;
end for;
end Inv_SubBytes_tb_conf;
