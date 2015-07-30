# import json
import os, os.path, errno, subprocess
import sys
import zipfile
import shutil
import json
import hashlib
from json import *

data = os.getcwd()
# print data
import sys

def getMD5(file_name):
    # Open,close, read file and calculate MD5 on its contents 
    with open(file_name) as file_to_check:
        # read contents of the file
        data = file_to_check.read()    
        # pipe contents of the file through
        md5_returned = hashlib.md5(data).hexdigest()

        return md5_returned

def compressFile(raw_dir, zip_dir):
    if not os.path.exists(zip_dir):
        os.system('mkdir ' + zip_dir)
    # compress files
    for parent, dirnames, filenames in os.walk(raw_dir):
        for dirname in dirnames:
            dir_path = parent + '/' + dirname
            filelist = []
            filename_list = []
            zip_file_path = zip_dir + '/' + dirname + '.zip'
            for root, dirs, files in os.walk(dir_path):
                for fname in files:
                    filelist.append(os.path.join(root,fname))
                    filename_list.append(fname)
            zf = zipfile.ZipFile(zip_file_path,'w',zipfile.zlib.DEFLATED)
            for i in range(0, len(filelist)):
                zf.write(filelist[i],filename_list[i])
            zf.close()
        break

def generateManifest(zip_dir, manifest_dir):
    for parent, dirnames, filenames in os.walk(zip_dir):
        for filename in filenames:
            if filename.find('.zip') > 0:
                manifest_file_path = manifest_dir + '/book_sound_' + filename.replace('.zip','.manifest')
                manifest_dict = {}
                manifest_dict["packageUrl"] = "http://123.56.84.196/BookSoundBag/"
                manifest_dict["remoteManifestUrl"]="http://123.56.84.196/BookSoundBag/book_sound_%s_server.manifest" % filename.replace('.zip','')
                manifest_dict["remoteVersionUrl"]="http://123.56.84.196/BookSoundBag/book_sound_%s_version.manifest" % filename.replace('.zip','')
                manifest_dict["version"]="2.0.0.0"
                manifest_dict["engineVersion"]="3.3 rc2"
                manifest_dict["assets"] = {}
                manifest_dict["assets"][filename] = {}
                manifest_dict["assets"][filename]["md5"] = getMD5(os.path.join(parent,filename))
                manifest_dict["assets"][filename]["compressed"]='true'
                manifest_dict["searchPaths"] = {}
                json_format = JSONEncoder().encode(manifest_dict)
                #print json_format
                json_file = open(manifest_file_path,'w')
                json.dump(json_format,json_file)
                json_file.close()
                #print(filename, getMD5(filename))

def uploadManifestFile(manifest_dir):
    for parent, dirnames, filenames in os.walk(manifest_dir):
        for filename in filenames:
            if filename.find('.manifest') > 0:
                target = os.path.splitext(filename)[0]
                print target
                ser = target + '_server.manifest'
                ver = target + '_version.manifest'
                cmd = 'scp %s/%s root@123.56.84.196:/var/www/ysyd/BookSoundBag/%s' % (manifest_dir,filename,ser)
                print cmd
                subprocess.call(cmd, shell=True)
                cmd = 'scp %s/%s root@123.56.84.196:/var/www/ysyd/BookSoundBag/%s' % (manifest_dir,filename,ver)
                print cmd
                subprocess.call(cmd, shell=True)

def uploadZipFile(zip_dir):
    for parent, dirnames, filenames in os.walk(zip_dir):
        for filename in filenames:
            if filename.find('.zip') > 0:
                cmd = 'scp %s/%s root@123.56.84.196:/var/www/ysyd/BookSoundBag/' % (zip_dir,filename)
                print cmd
                subprocess.call(cmd, shell=True)

if __name__ == '__main__':
    if len(sys.argv) < 4:
        print 'argv[1]:raw file dir'
        print 'argv[2]:zip file dir'
        print 'argv[3]:manifest dir'
        exit(-1)

    raw_dir = sys.argv[1]
    zip_dir = sys.argv[2]
    manifest_dir = sys.argv[3]
    if not os.path.exists(manifest_dir):
        os.system('mkdir ' + manifest_dir)
    # first compress raw file
    #compressFile(raw_dir,zip_dir)

    # generate manifest file
    #generateManifest(zip_dir,manifest_dir)

    # upload manifest file
    #uploadManifestFile(manifest_dir)

    # upload zip file
    uploadZipFile(zip_dir)




