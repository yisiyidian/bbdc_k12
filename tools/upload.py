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


for parent, dirnames, filenames in os.walk(path):
	for filename in filenames:
		if filename.find('.manifest') > 0:
			target = os.path.splitext(filename)[0]
			ser = target + '_server.manifest'
			ver = target + '_version.manifest'
			cmd = 'scp %s/%s root@123.56.84.196:/var/www/ysyd/BookSoundBag/%s' % (path,filename,ser)
			print cmd
			subprocess.call(cmd, shell=True)
			cmd = 'scp %s/%s root@123.56.84.196:/var/www/ysyd/BookSoundBag/%s' % (path,filename,ver)
			print cmd
			subprocess.call(cmd, shell=True)





