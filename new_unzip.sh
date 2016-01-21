#!/bin/sh

dir=/mnt/Aloha/
cur=$(pwd)
CSV=$dir/CSV-F

cd $CSV
for zip in *.zip; do
    #unzip "${zip}" 
    unzip -d "${zip%*.zip}" "$zip";
    for file in "${zip}"; do	
	mv "${zip%*.zip}"/*/* "${zip%*.zip}"/
	mkdir "${zip%.zip}_CSV"
	st=${zip%%.*}
	st=${st#*_}
	#echo $st
	for f in ${zip%*.zip}/*; do
	mv $f "${zip%*.zip}"/${st}_${f#*/}
        find "${zip%*.zip}"/* -type d -empty  -delete
	#| find . -type f -size -160c -delete
    	done
    python $cur/mod.py 
    done
python $cur/delete.py
rm -f $zip
done

cd $cur

#remove all files except those specified
./rmmost.sh 
#removes the '\\' character when directly next to a ','
#no longer necessary, no emp files are being kept at the moment
#might change later on, depending on which files we need
#./charstrip.sh
#insert to mysql database TEST
#send all errors to error_log.txt in current folder
#credentials should be located in .my.cnf file with read and execute 
#permissions 
./new_mysql.sh >error_log.txt 2>error_log.txt

exit
