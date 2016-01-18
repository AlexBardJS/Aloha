import re
import csv
from dbfpy import dbf
import os
import sys
import datetime as dt

now=dt.datetime.now()
ago=now-dt.timedelta(minutes=30)

for root,dirs,files in os.walk(os.getcwd()):  
    for dir in dirs:
        path=os.path.join(root,dir)
        st=os.stat(path)    
        mtime=dt.datetime.fromtimestamp(st.st_mtime)
        if mtime>ago:
	    if "_CSV" not in path: 
                for dirpath, dirnames, filenames in os.walk(path):
		    for filename in filenames:
			newpath = path+"_CSV"
			sub = re.sub(r'([DBF|dbf])+$', r'DBF', filename)
			#print sub
			if sub.endswith('.DBF'):
			    #print "Converting %s to csv" % filename
			    csv_fn = os.path.join(newpath, filename[:-4]+ ".csv")
			    with open(csv_fn,'wb') as csvfile:
				in_db = dbf.Dbf(os.path.join(dirpath, filename))
				out_csv = csv.writer(csvfile)
				names = []
				for field in in_db.header.fields:
				    names.append(field.name)
				out_csv.writerow(names)
				for rec in in_db:
				    out_csv.writerow(rec.fieldData)
				in_db.close()
				print "Done..."
		    	else:
		      	    print "Filename does not end with .dbf"
