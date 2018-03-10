#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import subprocess

fir = sys.argv[1]

f = open("%s" % fir, "r")

for line in f.readlines():
    tmp = line.split()[0]
    print("Now, processing %s......" % tmp)
    cmd_comd = "sh order_new.sh " + tmp
    subprocess.call(r'%s' % cmd_comd, shell=True)

f.close()
