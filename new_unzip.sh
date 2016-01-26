#!/bin/sh

dir=/mnt/Aloha/
cur=$(pwd)
CSV=$dir/<csv-folder>

cd $CSV
for zip in *.zip; do
    folder="${zip%*.zip}"
    unzip -d $folder "$zip";
    for file in "${zip}"; do	
	mv $folder/*/* $folder/
	mkdir $folder"_CSV"
        find $folder/* -type d -empty  -delete
	st=${zip%%.*}
	st=${st#*_}
	#echo $st

	cd $folder
	    $cur/rmDBF.sh & 
	    wait
	cd $CSV

        for f in $folder/*; do
	    mv $f $folder/${st}_${f#*/}
    	done
    python $cur/mod.py 
    done
python $cur/delete.py
rm -f $zip
done

cd $cur

#insert to mysql database TEST
#send all errors to error_log.txt in current folder
./new_mysql.sh >>error_log.txt 2>>error_log.txt

exit
