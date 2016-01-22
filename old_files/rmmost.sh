#!/bin/bash

CSV="/mnt/Aloha/<csv-folder>/*/"
cd $CSV
for cs in *.csv; do

GLOBIGNORE=*_GNDDEPST.csv:*_GNDDRWR.csv:*_GNDITEM.csv:*_GNDLBSUM.csv:*_GNDLINE.csv:*_GNDPERF.csv:*_GNDREVN.csv:*_GNDSALE.csv:*_GNDSLSUM.csv:*_GNDTNDR.csv:*_GNDTURN.csv:*_GNDVOID.csv:*_PRF.csv

        rm -f *

unset GLOBIGNORE

done
