@ECHO OFF
setlocal enabledelayedexpansion 

set current=%cd%

SET KEYPATH=C:\<path>\<to>\<private-key>\
:: set path to private key for ssh
SET PATH=C:\<path>\<to>\<zipped>\<folder>\
:: set path for grabbing zipped reports
SET NEWPATH=C:\<set>\<new>\<path>\
:: set path to move the reports for rename

cd %PATH%
:: use variable i for newest file *located at bottom of the stack*
FOR /F %%i IN ('DIR /B /O:D *.zip') DO (
		SET FILE=%%i 
		SET NEW=%%~ni_8.zip	
)	
	COPY !FILE! %NEWPATH% 	
:: set new as i filename only, add store number and add back extension
	cd %NEWPATH%
:: use !FILE! so that script does not hold previous value of %FILE%	

	REN !FILE! !NEW!
	
cd %current%

winscp.com /command "open sftp://ec2-user@<ec2-private-instance>.us-west-2.compute.amazonaws.com -privatekey=%KEYPATH%\<private-key>.ppk" ^
"cd /mnt/Aloha/<csv-folder>" "put %NEWPATH%\!NEW!" "cd /home/ec2-user/script/" "call /home/ec2-user/script/unzip.sh" "exit"
