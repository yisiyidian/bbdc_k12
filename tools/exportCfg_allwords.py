#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import sys
import json

def export(raw, des):
    reload(sys)
    sys.setdefaultencoding( "utf-8" )

    content = open(raw).read()

    a = json.loads(content)

    df = open(des, "w")

    for w in a:    
        b = []
        b.append(w)
        b.append(a[w]["sound_en"])
        b.append(a[w]["sound_us"])
        b.append(a[w]["meaning"])
        b.append(a[w]["small_meaning"])
        b.append(a[w]["sentence_en"])
        b.append(a[w]["sentence_cn"])
        df.write("%s\n"%"\t".join(b))

    df.close()
    pass

if __name__ == "__main__":
    export(sys.argv[1], sys.argv[2])