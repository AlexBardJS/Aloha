# Aloha: Document transfer and conversion
These file have been written for transfer of a zipped folder from a windows computer to a linux EC2 instance.
This is a brief overview of what each file contains and it's explicit purpose.

**fileup.bat**-- Windows batch file meant to start the trasfer of folders from windows pc to linux instance.
This file sorts the set directory by date and takes the newest folder (located at the bottom of the sort stack) and transfers
that file to another folder. From there it is renamed and transfered via SFTP to the private EC2 instance. This file depends on
WINSCP and uses the WIN command to do this transfer without input from the command line. This file also calls the next file for use,
unzip.sh to be used on the EC2 instance.<br />
<sub>::sidenote, when using WIN you need to first ssh into your instance using the WIN GUI login to set the certificate for the
pc you are using, WIN SFTP does not allow automating certificate acceptance so it must be done manually::</sub>


**unzip.sh**-- Linux script that unzips the folder that was just transfered, moves all the files in the subdirectory one level up
and makes a new folder of the same name for the conversion from .dbf to .csv. The script then renames all files by taking the name
of the folder after the underscore (which contains the store number that the file came from and was renamed with in the previous script)
and deletes the now empty subdirectory. The script then calls the rest of the files necessary to finish conversion and transfer
and removes the zip file.<br />
<sub>::file calls get a bit laggy towards the end, possible replace of file calls from this script to an AWS Lambda function 
that can call these at a specified time later on ::</sub>


**mod.py**-- Python file that finds a folder, uploaded in the last 30 minutes, and searches the name to make sure it is not the
currently empty CSV folder. This file then starts the conversion from dbf file to csv file by checking each file extension and
converting the file to csv in it's new location (the no longer empty CSV folder). 


**delete.py**-- Simple python file that deletes the now converted DBF files and it's folder.


**linecount.sh**-- Script file that checks each CSV file's line count. If there is only one line (the header line), the file is 
deleted. Also manually deletes files that contain unnecessary content.


**charstrip.sh**-- This file is very specific to hashed password. If there is an escape character "\\" next to a column seperator
"," this file deletes the escape characters in the file so that it does not interfere with uploading the file into MySQL.

**insert_mysql.sh**-- This begins the creation of tables in MySQL by using the name of the file as the table name and the header
row for the creation of the columns. Currently taking all information from all of the files and uploading it. Columns are also
all varchar(255) which may have to be changed later on. One file in particular contains too much information in the rows to be
uploaded as varchar(255) so it catches that error and uses BLOB to upload that information to MySQL. All MySQL credentials 
are contained in the .my.cnf file located in the root folder. Send all errors to an error_log file for later review. <br />
<sub>::as of this moment there are no primary or foreign keys in the tables, this file is just uploading information as it. 
the `LOAD DATA INFILE` command also appends information to a file without checking if that data already exists, will have to 
be caught somehow, possibly with use of the a check for primary key or something similar::</sub>
<br /> <br />



------
###References
------
[Markdown Cheat Sheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Here-Cheatsheet)

[WinSCP Download](https://winscp.net/eng/download.php)

[WinSCP for Command Line](https://winscp.net/eng/docs/commandline)

[Mount S3 bucket to EC2 instance](https://winscp.net/eng/docs/guide_amazon_s3_sftp)

[S3FS-Fuse- For Bucket Mount on Amazon EC2](https://github.com/s3fs-fuse/s3fs-fuse)

[Batch Find Newest File](http://stackoverflow.com/questions/97371/how-do-i-write-a-windows-batch-script-to-copy-the-newest-file-from-a-directory)

[Batch Variable Expansion](http://www.robvanderwoude.com/variableexpansion.php)

[Bash Cheat Sheet](http://cli.learncodethehardway.org/bash_cheat_sheet.pdf)

[Unzip files and Rename](http://stackoverflow.com/questions/25432321/unix-shell-scripting-unzip-multiple-zip-files-rename-unzipped-file-following)

[Python Find Newest Files in Directory](http://stackoverflow.com/questions/8087693/python-code-to-find-all-newly-created-modified-and-deleted-files-in-all-the-dir)

[Python Convert DBF to CSV File](https://gist.github.com/bertspaan/8220892)

[Python Bulk Conversion of DBF to CSV](http://gis.stackexchange.com/questions/93303/bulk-convert-dbf-to-csv-in-a-folder-arcgis-10-1-using-python)

[Python Remove a Non-Empty Path](http://stackoverflow.com/questions/303200/how-do-i-remove-delete-a-folder-that-is-not-empty-with-python)

[Unix Script Delete File with One Line](http://stackoverflow.com/questions/5327981/unix-script-to-delete-file-if-it-contains-single-line)

[Bash GREP Linux Command](http://linux.about.com/od/commands/l/blcmdl1_grep.htm)

[The Basics of Using SED](https://www.digitalocean.com/community/tutorials/the-basics-of-using-the-sed-stream-editor-to-manipulate-text-in-linux)

[Install MySQL DB with YUM on Linux](https://www.rackspace.com/knowledge_center/article/centosfedorarhel-installing-mysql-database-with-yum)

[MySQL 5.5 Documentation: Load Data Infile Syntax](https://dev.mysql.com/doc/refman/5.5/en/load-data.html)

[MySQL Create Table and Load Data Infile](http://positon.org/import-csv-file-to-mysql)

[Load Data Infile on Amazon RDS](http://stackoverflow.com/questions/1641160/how-to-load-data-infile-on-amazon-rds)

[Bash Error Codes](http://linuxcommand.org/wss0150.php)

[Bash For Loop Examples](http://www.cyberciti.biz/faq/bash-for-loop/)
