# import json
import os, os.path, errno, subprocess
import sys
import zipfile
import shutil
import hashlib

data = os.getcwd()
# print data

path = '/Users/tianweilande/Desktop/zip'
os.chdir(path)

def getMD5(file_name):
    # Open,close, read file and calculate MD5 on its contents 
    with open(file_name) as file_to_check:
        # read contents of the file
        data = file_to_check.read()    
        # pipe contents of the file through
        md5_returned = hashlib.md5(data).hexdigest()

        return md5_returned


for parent, dirnames, filenames in os.walk(path):
	for filename in filenames:
		if filename.find('.zip') > 0:
			print(filename, getMD5(filename))




