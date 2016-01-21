#!/bin/sh

MYSQL_ARGS=" --defaults-extra-file=~/.my.cnf"
DB="TEST"
DELIM=","
QT='"'
RTRN='\r\n'
CSV="$(pwd)/CSV-F/*/"

vc_insert() {
	FIELDS=$(head -1 "$cs" | sed -e 's/'$DELIM'/` varchar(255),\n`/g' -e 's/\r//g')
	FIELDS='`'"$FIELDS"'` varchar(255)'

	mysql $MYSQL_ARGS $DB --local-infile=1 -e "
		CREATE TABLE IF NOT EXISTS $TABLE ($FIELDS);

		LOAD DATA LOCAL INFILE '$(pwd)/$cs' INTO TABLE $TABLE
		FIELDS TERMINATED BY '$DELIM'
		OPTIONALLY ENCLOSED BY '$QT' 
		LINES TERMINATED BY '$RTRN' 
		IGNORE 1 LINES
		;
	" 
}

blb_insert() {
	FIELDS=$(head -1 "$cs" | sed -e 's/'$DELIM'/` BLOB,\n`/g' -e 's/\r//g')
	FIELDS='`'"$FIELDS"'` BLOB'

	mysql $MYSQL_ARGS $DB --local-infile=1 -e "
		CREATE TABLE IF NOT EXISTS $TABLE ($FIELDS);

		LOAD DATA LOCAL INFILE '$(pwd)/$cs' INTO TABLE $TABLE
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
			#echo $cs, $TABLE
			continue
		fi
			blb_insert
			#echo $cs, $TABLE "for mod"
done

