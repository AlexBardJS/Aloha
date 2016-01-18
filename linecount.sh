#!/bin/bash

CSV="$(pwd)/CSV-F/*/"
cd $CSV
for cs in *.csv; do

LINECOUNT=`wc -l $cs | cut -f1 -d' '`

    if [[ $LINECOUNT == 1 ]]; then
       rm -f $cs
    fi

rm -f {*_SUB.csv,*_TAB.csv,*_LAB.csv,*_QUE.csv,*_VKP.csv,*_SMG.csv,*_TRK.csv,*_VDV.csv,*_GNDQKCNT.csv,*_VID.csv,*_SUR.csv,*_COIN.csv,*_VOL.csv,*_VER.csv,*_BRKRDT.csv,*_STO.csv,*_PC.csv}


done
