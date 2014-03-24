#!/usr/bin/python

# Don't worry, we only use python for a dirty generation script

max = 500

print "p cnf " + str(max + 1) + " " + str((max + 1) * (max + 1) / 2)

for base in range (1, max + 1):
    print str(base) + "<>" + str(max + 1)
    for i in range (base, max + 1):
        print  str(base) + "=" + str(i)
