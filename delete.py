#!/usr/bin/python
import shutil
import os
import sys

for root,dirs,files in os.walk(os.getcwd()):  
    for dir in dirs:
	path=os.path.join(root,dir)
	if "_CSV" not in dir:
	    for dirpath, dirnames, filenames in os.walk(path):
		  shutil.rmtree(dirpath)
