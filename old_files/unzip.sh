#!/bin/sh

#dir=/mnt/Aloha/
cur=$(pwd)
CSV=$cur/CSV-F/

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
rm $zip
done

cd $cur

#remove all one line files and additional unnecessary files
./linecount.sh 
#remove the '\\' character when directly next to a ','
./charstrip.sh
#insert to mysql database TEST using either varchar or blob, send
#all errors to error_log.txt in current folder
#credentials should be located in debian.cnf file with read and execute 
#permissions (?)
./insert_mysql.sh >error_log.txt 2>error_log.txt

exit
