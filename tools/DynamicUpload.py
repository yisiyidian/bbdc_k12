#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import json
import os, os.path, errno, subprocess
import sys
import zipfile
import shutil
import hashlib

tmp_assetPath = os.getcwd() + '/../tmp_asset/debug/'
AssetsManager = 'AssetsManagerDebug'

# tmp_assetPath = os.getcwd() + '/../tmp_asset/release/'
# AssetsManager = 'AssetsManagerRelease/1.6.0'

for parent, dirnames, filenames in os.walk(tmp_assetPath):
    for filename in filenames:
        fullPath = os.path.join(parent, filename)
        if filename.find('.manifest') > 0:
            cmd = 'scp %s root@yisiyidian.com:/var/www/ysyd/%s/%s' % (fullPath, AssetsManager, fullPath.replace(tmp_assetPath, ''))
        else:
            cmd = 'scp %s root@yisiyidian.com:/var/www/ysyd/%s/ServerAssets/%s' % (fullPath, AssetsManager, fullPath.replace(tmp_assetPath, ''))
        print cmd
        subprocess.call(cmd, shell=True)
