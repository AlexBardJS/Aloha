#!/bin/sh

MYSQL_ARGS=" --defaults-file=/<home>/.my.cnf"
DB="TEST"
DELIM=","
QT='"'
RTRN='\r\n'
dir="/mnt/Aloha/<csv-folder>"
CSV=$dir/*/

vc_insert() {
	FIELDS=$(head -1 "$cs" | sed -e 's/'$DELIM'/` varchar(255),\n`/g' -e 's/\r//g')
	FIELDS='`'"$FIELDS"'` varchar(255)'

	mysql $MYSQL_ARGS $DB -e "
		CREATE TABLE IF NOT EXISTS $TABLE ($FIELDS);

		LOAD DATA LOCAL INFILE '$cs' INTO TABLE $TABLE
		FIELDS TERMINATED BY '$DELIM'
		OPTIONALLY ENCLOSED BY '$QT' 
		LINES TERMINATED BY '$RTRN' 
		IGNORE 1 LINES
		;
	" 
}

cd $CSV

	for cs in *.csv; do
		TABLE="${cs%*.csv}"

		[ "$cs" = "" -o "$TABLE" = "" ] && echo "Error in command: $0 empty set" && exit 1

		vc_insert 
		if [ $? -eq 0 ]; then
			rm -f $cs
		fi
        done

cd $dir

find * -type d -empty  -delete
