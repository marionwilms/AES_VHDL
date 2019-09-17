--------------------------------------------------------------------------------
--@author WILMS Marion
--@date 07 Decembre 2018
--@component InvAES
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
entity InvAES is

	port(
	 start_i, clock_i, reset_i : in std_logic;
	 data_i : in bit128;
	 aes_on_o : out std_logic;
	 data_o : out bit128);

end entity InvAES;

--debut architecture
architecture InvAES_arch of InvAES is

  component KeyExpansion_table is
  port (  round_i : in bit4;
          expansion_key_o : out bit128);
  end component KeyExpansion_table;

  component RTL_REG is
  	port(
  	 enable_i, clock_i, resetb_i : in std_logic;
  	 currenttext_s_i : in bit128;
  	 data_o : out bit128);
  end component RTL_REG;

  component Counter is
  	port(
  	 clock_i, enable_i, resetb_i : in std_logic;
  	 counter_o : out bit4
  	);
  end component Counter;

  component FSM_Moore is
	   port(
  	 	start_i, clock_i, resetb_i : in std_logic;
  	 	round_i : in bit4;
  	 	done_o, enableCounter_o, enableMixcolumns_o, enableOutput_o, enableRoundComputing_o, getciphertext_o, resetCounter_o : out std_logic);
  end component FSM_Moore;

  component InvAESRound is
  	port(
  	 enableMixColumns_i, enableRoundComputing_i, clock_i, resetb_i : in std_logic;
  	 currentkey_i, currenttext_i : in bit128;
  	 data_o : out bit128);
  end component InvAESRound;
--signaux
signal enableCounter_s, resetCounter_s, enableMixcolumns_s, enableOutput_s, enableRoundComputing_s, getciphertext_s, done_s: std_logic;
signal resetb_s : std_logic := '0';
signal count_s : bit4;
signal expansion_key_s, outputInvAESRound_s, inputInvAESRound_s : bit128;

begin

  --instanciation components

  	C : Counter
      		port map (
          	  clock_i => clock_i,
              enable_i => enableCounter_s,
              resetb_i => resetCounter_s,
          	  counter_o => count_s
  		);

  	FSM : FSM_Moore
      		port map (
          	start_i => start_i,
            resetb_i => resetb_s,
            clock_i => clock_i,
            round_i => count_s,
          	done_o => aes_on_o,
            enableCounter_o => enableCounter_s,
            enableMixcolumns_o => enableMixcolumns_s,
            enableOutput_o => enableOutput_s,
            enableRoundComputing_o => enableRoundComputing_s,
            getciphertext_o => getciphertext_s,
            resetCounter_o => resetCounter_s
  		);



  	KET : KeyExpansion_table
      		port map(
          	round_i => count_s,
            expansion_key_o => expansion_key_s

  		);

  	REG: RTL_REG
  		port map(
      		enable_i => enableOutput_s,
      		clock_i => clock_i,
      		resetb_i => resetb_s,
      		currenttext_s_i => outputInvAESRound_s,
      		data_o => data_o
  		);

    IAR: InvAESRound
    	port map(
      	enableMixColumns_i => enableMixcolumns_s,
      	enableRoundComputing_i => enableRoundComputing_s,
      	clock_i => clock_i,
      	resetb_i => resetb_s,
   			currentkey_i => expansion_key_s,
      	currenttext_i => inputInvAESRound_s,
   			data_o => outputInvAESRound_s
      );

resetb_s <= not(reset_i); --inverseur pour passer en reset a l'etat bas

      --process sequentiel pour multiplexeur en fonction de getciphertext_s
      seq_0 : process (getciphertext_s, inputInvAESRound_s, outputInvAESRound_s, data_i)

      	begin

      	if getciphertext_s = '1' then			--multiplexeur
      		inputInvAESRound_s <= data_i;
      	else
      		inputInvAESRound_s <= outputInvAESRound_s;

      	end if;
      end process seq_0;

end architecture InvAES_arch;

--configuration
configuration InvAES_conf of InvAES is
	for InvAES_arch
		for all : KeyExpansion_table
			use entity source.KeyExpansion_table(KeyExpansion_table_arch);
		end for;
		for all : RTL_REG
			use entity source.RTL_REG(RTL_REG_arch);
		end for;
		for all : Counter
			use entity source.Counter(Counter_arch);
		end for;
		for all : FSM_Moore
			use entity source.FSM_Moore(FSM_Moore_arch);
		end for;
    		for all : InvAESRound
			use entity source.InvAESRound(InvAESRound_arch);
		end for;
	end for;
end InvAES_conf;
