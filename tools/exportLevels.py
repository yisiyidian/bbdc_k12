#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import json
import os, os.path, errno
import sys
import zipfile
import shutil

def export(rawjsonPath, targetPath, bookKey):
    print(rawjsonPath)
    f = open(rawjsonPath)
    s = f.read()
    jsonStr = json.loads(s)
    Levels = jsonStr['Levels']
    Level = Levels['Level']

    outStr = '''{
  "Levels": {
    "Level": [
'''
    for lv in Level:
        book_key = lv['book_key']

        if book_key == bookKey:
            outStr += str(json.dumps(lv, indent=4)) + '\n,'

    outStr += ',,'
    outStr = outStr.replace(',,,', '')
    outStr += '''
]
         }
}'''
    print('levels: ' + targetPath + 'lv_' + bookKey + '.json')
    out = open(targetPath + 'lv_' + bookKey + '.json', 'w')
    out.write(outStr)
    out.close()

    pass
                
if __name__ == "__main__":
    export(sys.argv[1], sys.argv[2], sys.argv[3])
