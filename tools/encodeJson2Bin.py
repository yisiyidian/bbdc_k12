#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import json
import os, os.path, errno
import sys
import zipfile
import shutil

# import xxteaFiles
import xxtea

def makeDirIfNotExist(dirPath):
    if not ( os.path.exists(dirPath) and os.path.isdir(dirPath) ):
        os.makedirs(dirPath)

def encode(inputfilepath, outputfilepath):
    try:
        fileRaw = open(inputfilepath, "rb")  #io.BufferedReader
        swf = open(outputfilepath, "wb")

        b = fileRaw.read() #string
        listInt = range(len(b))
        for i in range(len(b)):
            listInt[i] = ord(b[i])
        fileRaw.close()

        out = range(len(b))
        s = ''
        xor = len(listInt) + 17
        for i in range(len(listInt)):
            listInt[i] = (listInt[i] ^ xor) & 255
            out[i] = chr(listInt[i])
            s += out[i]

        swf.write(s)
        swf.close()
    
    except IOError:
        print(sys.stderr)
        print("File could not be opened: ", inputfilepath, outputfilepath)
        sys.exit(1)
    pass

def encode_xxtea(inputfilepath, outputfilepath):
    xxtea.encrypt_file(inputfilepath, outputfilepath, 0x0839042f, 0xa98f0ce1, 0x430c8bef, 0x765bc1f0)
    # try:
    #     fileRaw = open(inputfilepath, "rb")  #io.BufferedReader
    #     swf = open(outputfilepath, "wb")

    #     b = fileRaw.read()
    #     fileRaw.close()

    #     s = xxteaFiles.encryptStr(b)

    #     swf.write(s)
    #     swf.close()
    
    # except IOError:
    #     print(sys.stderr)
    #     print("File could not be opened: ", inputfilepath, outputfilepath)
    #     sys.exit(1)
    pass

def zipJSONFiles(json_path, bin_path):
    makeDirIfNotExist(bin_path)
    for parent, dirnames, filenames in os.walk(json_path):
        for filename in filenames:
            if (filename.find('.json') > 0 \
                and filename.find('.svn-base') <= 0 \
                and filename.find('.DS_Store') < 0 \
                and filename.find('all-wcprops') < 0 \
                and filename.find('.xls') <= 0):
                filename_encoded = filename.replace('.json', '.bin')
                encode_xxtea(json_path + '/' + filename, bin_path + '/' + filename_encoded)
                print('encoded: ' + bin_path + '/' + filename_encoded)
    pass

if __name__ == "__main__":
    zipJSONFiles(sys.argv[1], sys.argv[2])

