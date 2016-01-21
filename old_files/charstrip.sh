#!/bin/sh

cur=$(pwd)
CSV=$cur/CSV-F/*/*.csv

#regex='*\\(?=,)'

for c in $CSV; do
    value=$(grep -o '\\,' $CSV)
    if [ -n "$value" ]
    then 
    #echo "yes" $value
    sed 's/[\\]//g' $c > tmp && mv tmp $c
    else 
    echo "no"
    fi

done
