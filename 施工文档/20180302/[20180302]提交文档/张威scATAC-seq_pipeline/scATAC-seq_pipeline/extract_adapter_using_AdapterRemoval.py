#!/usr/bin/python
# -*- coding: utf-8 -*-

# this program extract adapters recognized by AdapterRemoval, and
# save them to a new file

import sys
import re
import subprocess

fir1 = sys.argv[1]  # input file
fir2 = sys.argv[2]  # output file

f = open(r'%s' % fir1, 'r')
g = open(r'%s' % fir2, 'w')

for line in f.readlines():
    tmp = line.split()
    if "--adapter1:" in tmp:
        adapter1 = tmp[1]
    elif "--adapter2:" in tmp:
        adapter2 = tmp[1]

new_line = adapter1 + "\t" + adapter2
g.write(new_line)

f.close()
g.close()


