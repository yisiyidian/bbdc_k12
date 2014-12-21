#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import os
import sys
import json

def export(raw, des):
    os.system("cp %s %s"%(raw, des))
    pass

if __name__ == "__main__":
    export(sys.argv[1], sys.argv[2])