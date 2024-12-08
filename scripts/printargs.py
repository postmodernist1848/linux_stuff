#!/usr/bin/env python3

import sys
args = sys.argv[1:]
print(len(args), "argument(s):");
for arg in args:
    print('`', arg, '`', sep='');
