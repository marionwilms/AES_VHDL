#!/bin/bash

export PROJECTNAME="."
echo "the project location is : $PROJECTNAME"
# clean source and bench libs
echo "removing libs"
vdel -lib $PROJECTNAME/lib/source -all
vdel -lib $PROJECTNAME/lib/bench -all

# create source and bench libs
echo "creating work libs"
vlib $PROJECTNAME/lib/source
vmap source $PROJECTNAME/lib/source
vlib $PROJECTNAME/lib/bench
vmap bench $PROJECTNAME/lib/bench
# map existing AESLibrary lib
vlib $PROJECTNAME/lib/AESLibrary
vmap AESLibrary $PROJECTNAME/lib/AESLibrary

# compile sources and launch the VHDL simulator
echo "compile vhdl sources"
vcom -work source $PROJECTNAME/sources/KeyExpansion_table.vhd
vcom -work source $PROJECTNAME/sources/Inv_S_BOX.vhd
vcom -work source $PROJECTNAME/sources/Inv_SubBytes.vhd
vcom -work source $PROJECTNAME/sources/Add_Round_Key.vhd
vcom -work source $PROJECTNAME/sources/Inv_Shift_Rows.vhd
vcom -work source $PROJECTNAME/sources/Matrix_Multiplier.vhd
vcom -work source $PROJECTNAME/sources/Inv_Mix_Columns.vhd
vcom -work source $PROJECTNAME/sources/FSM_Moore.vhd
vcom -work source $PROJECTNAME/sources/Counter.vhd
vcom -work source $PROJECTNAME/sources/RTL_REG.vhd
vcom -work source $PROJECTNAME/sources/InvAESRound.vhd
vcom -work source $PROJECTNAME/sources/InvAES.vhd

echo "compile vhdl test bench"
vcom -work bench $PROJECTNAME/bench/KeyExpansion_table_tb.vhd
vcom -work bench $PROJECTNAME/bench/Inv_S_BOX_tb.vhd
vcom -work bench $PROJECTNAME/bench/Inv_SubBytes_tb.vhd
vcom -work bench $PROJECTNAME/bench/Add_Round_Key_tb.vhd
vcom -work bench $PROJECTNAME/bench/Inv_Shift_Rows_tb.vhd
vcom -work bench $PROJECTNAME/bench/Matrix_Multiplier_tb.vhd
vcom -work bench $PROJECTNAME/bench/Inv_Mix_Columns_tb.vhd
vcom -work bench $PROJECTNAME/bench/FSM_Moore_tb.vhd
vcom -work bench $PROJECTNAME/bench/Counter_tb.vhd
vcom -work bench $PROJECTNAME/bench/RTL_REG_tb.vhd
vcom -work bench $PROJECTNAME/bench/InvAESRound_tb.vhd
vcom -work bench $PROJECTNAME/bench/InvAES_tb.vhd

echo "compilation finished"
echo "start simulation..."
