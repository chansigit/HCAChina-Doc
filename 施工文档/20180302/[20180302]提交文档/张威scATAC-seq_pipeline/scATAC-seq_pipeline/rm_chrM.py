#!/usr/bin/python
# -*- coding: utf-8 -*-


import sys
import re

fir1 = sys.argv[1]
fir2 = sys.argv[2]

f = open(r'%s' % fir1, 'r')
g = open(r'%s' % fir2, 'w')

chr_info = ['chr1', 'chr2', 'chr3', 'chr4', 'chr5', 'chr6', 'chr7', 'chr8', 'chr9', 'chr10', 'chr11', 'chr12', 'chr13',
            'chr14', 'chr15', 'chr16', 'chr17', 'chr18', 'chr19', 'chr20', 'chr21', 'chr22', 'chrX']

for line in f.readlines():
    temp = line.split()
    if temp[0] in chr_info:
        new_line = '\t'.join([str(i) for i in temp])
        g.write(new_line + '\n')

f.close()
g.close()


